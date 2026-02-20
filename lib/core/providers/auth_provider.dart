import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/constants/pref_keys.dart';
import 'package:earnwise_app/core/di/di.dart';
import 'package:earnwise_app/core/providers/profile_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/toast.dart';
import 'package:earnwise_app/data/services/local_storage_service.dart';
import 'package:earnwise_app/domain/models/user_profile_model.dart';
import 'package:earnwise_app/domain/repositories/auth_repository.dart';
import 'package:earnwise_app/main.dart';
import 'package:earnwise_app/presentation/features/auth/screens/onboarding_screen.dart';
import 'package:earnwise_app/presentation/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final authNotifier = ChangeNotifierProvider((ref) => AuthProvider(ref));

class AuthProvider extends ChangeNotifier {
  late final AuthRepository authRepository;

  late final Ref ref;

  AuthProvider(Ref r) {
    ref = r;
    authRepository = di.get();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    final result = await authRepository.login(email: email, password: password);

    result.fold(
      (success) {
        _isLoading = false;
        notifyListeners();
        storeAuthTokens(success);

        pushAndRemoveUntil(const DashboardScreen());
        logger.d("Login successful");
      },
      (failure) {
        _isLoading = false;
        notifyListeners();
        logger.e("Login failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> register({
    required String firstName, 
    required String lastName, 
    required String email, 
    required String password
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await authRepository.register(
      firstName: firstName, 
      lastName: lastName, 
      email: email, 
      password: password
    );
    
    result.fold(
      (success) async {
        await login(email: email, password: password);
        _isLoading = false;
        notifyListeners();
      },
      (failure) {
        _isLoading = false;
        notifyListeners();
        logger.e("Registration failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> refreshToken({required String refreshToken}) async {
    final result = await authRepository.refreshToken(refreshToken: refreshToken);
    result.fold((l) => null, (r) => null);
  }

  void logout() async {
    await LocalStorageService.clearDB();
    ref.read(profileNotifier).clearProfile();
    LocalStorageService.put(PrefKeys.isLoggedIn, false);

    pushAndRemoveUntil(const OnboardingScreen());
  }

  void storeAuthTokens(Response<dynamic> loginResponse) async {
    await LocalStorageService.put(PrefKeys.accessToken, loginResponse.data['data']['access_token']);
    await LocalStorageService.put(PrefKeys.refreshToken, loginResponse.data['data']['refresh_token']);
    await LocalStorageService.put(PrefKeys.userId, loginResponse.data['data']['user']['id']);
    await LocalStorageService.put(PrefKeys.profile, jsonEncode(UserProfileModel.fromJson(loginResponse.data['data']).toJson()));

    var profileModel = UserProfileModel.fromJson(loginResponse.data['data']);
    ref.read(profileNotifier).storeProfile(profileModel);
    LocalStorageService.put(PrefKeys.isLoggedIn, true);
    notifyListeners();

    logger.i("Auth credentials stored successfully {}");
  }
}