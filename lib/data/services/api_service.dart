import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:earnwise_app/core/constants/endpoints.dart';
import 'package:earnwise_app/core/constants/pref_keys.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/data/services/local_storage_service.dart';
import 'package:earnwise_app/main.dart';
import 'package:earnwise_app/presentation/features/auth/screens/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  late Dio http;

  // Static variables to ensure singleton behavior across all ApiService instances
  static bool _isRefreshing = false;
  static final List<Completer<String?>> _refreshCompleters = [];

  ApiService() {
    http = Dio(BaseOptions(
      baseUrl: Endpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        HttpHeaders.contentTypeHeader : "application/json"
      }
    ))..interceptors.add(
      QueuedInterceptorsWrapper(
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) async {
          if(error.response?.statusCode == 401) {
            log("401 error occured");
            // refresh token with singleton behavior
            String? newToken = await _refreshAuthTokenSingleton();

            if (newToken != null) {
              error.requestOptions.headers[HttpHeaders.authorizationHeader] = 'Bearer $newToken';
              return handler.resolve(await http.fetch(error.requestOptions));
            } else {
              // Token refresh failed, redirect to login
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
        onRequest: (options, handler) async {
          String? token = await LocalStorageService.get(PrefKeys.accessToken);

          if(options.path != Endpoints.login && options.path != Endpoints.register) {
            options.headers.addAll({
              HttpHeaders.authorizationHeader: "Bearer $token"
            });
          }
          
          return handler.next(options);
        },
      )
    )..transformer = BackgroundTransformer();

    if(!kReleaseMode) {
      http.interceptors.addAll([
        PrettyDioLogger(
          request: true,
          requestBody: true,
          responseBody: true,
          error: true,
          responseHeader: true
        )
      ]);
    }
  }

  /// Singleton token refresh method that prevents multiple simultaneous refresh calls
  static Future<String?> _refreshAuthTokenSingleton() async {
    // If already refreshing, wait for the existing refresh to complete
    if (_isRefreshing) {
      final completer = Completer<String?>();
      _refreshCompleters.add(completer);
      return completer.future;
    }

    // Start the refresh process
    _isRefreshing = true;
    String? result;

    try {
      result = await _performTokenRefresh();
    } finally {
      // Complete all waiting requests with the result
      for (final completer in _refreshCompleters) {
        completer.complete(result);
      }
      _refreshCompleters.clear();
      _isRefreshing = false;
    }

    return result;
  }

  /// Performs the actual token refresh
  static Future<String?> _performTokenRefresh() async {
    String? refreshToken = await LocalStorageService.get(PrefKeys.refreshToken);
    logger.d("Refreshing auth token => $refreshToken");
    
    try {
      if (refreshToken != null) {
        var dio = Dio(BaseOptions(
          baseUrl: Endpoints.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          headers: {
            HttpHeaders.contentTypeHeader : "application/json"
          }
        ));

        if(!kReleaseMode) {
          dio.interceptors.addAll([
            PrettyDioLogger(
              request: true,
              requestBody: true,
              responseBody: true,
              error: true,
              responseHeader: true
            )
          ]);
        }

        Response refreshResponse = await dio.post(Endpoints.refresh, data: {
          'refresh_token': refreshToken,
        });

        if (refreshResponse.statusCode == 200) {
          log('Token refreshed => ${refreshResponse.data}');
          String newAccessToken = refreshResponse.data['data']['access_token'];
          String newRefreshToken = refreshResponse.data['data']['refresh_token'];

          await LocalStorageService.put(PrefKeys.accessToken, newAccessToken);
          await LocalStorageService.put(PrefKeys.refreshToken, newRefreshToken);
          
          return newAccessToken;
        }
      }

      return null;
    } on DioException {
      // showErrorToast("Session Expired. Please login again");
      await LocalStorageService.clearDB();
      pushAndRemoveUntil(const LoginScreen());
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    } 
  }

  /// Legacy method for backward compatibility - now uses singleton
  Future<String?> refreshAuthToken() async {
    return await _refreshAuthTokenSingleton();
  }
}