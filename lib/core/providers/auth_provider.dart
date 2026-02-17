import 'package:dio/dio.dart';
import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/constants/pref_keys.dart';
import 'package:earnwise_app/core/di/di.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/toast.dart';
import 'package:earnwise_app/data/services/local_storage_service.dart';
import 'package:earnwise_app/domain/repositories/auth_repository.dart';
import 'package:earnwise_app/main.dart';
import 'package:earnwise_app/presentation/features/auth/screens/onboarding_screen.dart';
import 'package:earnwise_app/presentation/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final authNotifier = ChangeNotifierProvider((ref) => AuthProvider());

class AuthProvider extends ChangeNotifier {
  late final AuthRepository authRepository;

  AuthProvider() {
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
    userId = null;
    firstName = null;
    lastName = null;
    email = null;
    profilePicture = null;
    userExpertId = null;
    country = null;
    state = null;
    city = null;
    street = null;
    zip = null;
    gender = null;
    phone = null;
    LocalStorageService.put(PrefKeys.isLoggedIn, false);

    pushAndRemoveUntil(const OnboardingScreen());
  }

  void storeAuthTokens(Response<dynamic> loginResponse) async {
    await LocalStorageService.put(PrefKeys.accessToken, loginResponse.data['data']['access_token']);
    await LocalStorageService.put(PrefKeys.refreshToken, loginResponse.data['data']['refresh_token']);
    await LocalStorageService.put(PrefKeys.userId, loginResponse.data['data']['user']['id']);
    await LocalStorageService.put(PrefKeys.userFirstName, loginResponse.data['data']['user']['first_name']);
    await LocalStorageService.put(PrefKeys.userLastName, loginResponse.data['data']['user']['last_name']);
    await LocalStorageService.put(PrefKeys.userEmail, loginResponse.data['data']['user']['email']);
    if(loginResponse.data['data']['expert_profile'] != null) {
      await LocalStorageService.put(PrefKeys.userExpertId, loginResponse.data['data']['expert_profile']['id']);
    }
    await LocalStorageService.put(PrefKeys.userCountry, loginResponse.data['data']['user']['country']);
    await LocalStorageService.put(PrefKeys.userState, loginResponse.data['data']['user']['state']);
    await LocalStorageService.put(PrefKeys.userCity, loginResponse.data['data']['user']['city']);
    await LocalStorageService.put(PrefKeys.userStreet, loginResponse.data['data']['user']['street']);
    await LocalStorageService.put(PrefKeys.userZip, loginResponse.data['data']['user']['zip']);
    await LocalStorageService.put(PrefKeys.userGender, loginResponse.data['data']['user']['gender']);
    await LocalStorageService.put(PrefKeys.userPhone, loginResponse.data['data']['user']['phone']);
    await LocalStorageService.put(PrefKeys.isLoggedIn, true);

    userId = loginResponse.data['data']['user']['id'];
    firstName = loginResponse.data['data']['user']['first_name'];
    lastName = loginResponse.data['data']['user']['last_name'];
    profilePicture = loginResponse.data['data']['user']['profile_picture'];
    email = loginResponse.data['data']['user']['email'];
    userExpertId = loginResponse.data['data']['expert_profile']['id'];
    country = loginResponse.data['data']['user']['country'];
    state = loginResponse.data['data']['user']['state'];
    city = loginResponse.data['data']['user']['city'];
    street = loginResponse.data['data']['user']['address'];
    zip = loginResponse.data['data']['user']['zip'];
    gender = loginResponse.data['data']['user']['gender'];
    phone = loginResponse.data['data']['user']['phone'];
    notifyListeners();

    logger.i("Auth credentials stored successfully {}");
  }
}