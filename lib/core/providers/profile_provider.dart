import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/constants/pref_keys.dart';
import 'package:earnwise_app/core/di/di.dart';
import 'package:earnwise_app/core/utils/toast.dart';
import 'package:earnwise_app/data/services/local_storage_service.dart';
import 'package:earnwise_app/domain/dto/update_profile_dto.dart';
import 'package:earnwise_app/domain/models/expert_profile_model.dart';
import 'package:earnwise_app/domain/models/user_profile_model.dart';
import 'package:earnwise_app/domain/repositories/profile_repository.dart';
import 'package:earnwise_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

final profileNotifier = ChangeNotifierProvider((ref) => ProfileProvider());

class ProfileProvider extends ChangeNotifier {
  late final ProfileRepository profileRepository;

  ProfileProvider() {
    profileRepository = di.get();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserProfileModel? _profile;
  UserProfileModel? get profile => _profile;

  Future<void> getProfile() async {
    // String? userId = await LocalStorageService.get(PrefKeys.userId);
    // String? firstName = await LocalStorageService.get(PrefKeys.userFirstName);
    // String? lastName = await LocalStorageService.get(PrefKeys.userLastName);
    // String? email = await LocalStorageService.get(PrefKeys.userEmail);
    // String? profilePicture = await LocalStorageService.get(PrefKeys.userImageUrl);
    // String? userExpertId = await LocalStorageService.get(PrefKeys.userExpertId);
    // String? country = await LocalStorageService.get(PrefKeys.userCountry);
    // String? state = await LocalStorageService.get(PrefKeys.userState);
    // String? city = await LocalStorageService.get(PrefKeys.userCity);
    // String? street = await LocalStorageService.get(PrefKeys.userStreet);
    // String? zip = await LocalStorageService.get(PrefKeys.userZip);
    // String? gender = await LocalStorageService.get(PrefKeys.userGender);
    // String? phone = await LocalStorageService.get(PrefKeys.userPhone);
    
    // _profile = UserProfileModel(
    //   user: User(
    //     id: userId,
    //     firstName: firstName,
    //     lastName: lastName,
    //     email: email,
    //     profilePicture: profilePicture,
    //     country: country,
    //     state: state,
    //     city: city,
    //     address: street,
    //     zip: zip,
    //     gender: gender,
    //     phone: phone,
    //   ),
    //   expertProfile: ExpertProfileModel(
    //     id: userExpertId
    //   )
    // );
    
    _isLoading = true;
    notifyListeners();

    final result = await profileRepository.getProfile();
    result.fold(
      (success) {
        _isLoading = false;
        _profile = success;
        storeProfile(success);
        notifyListeners();
      },
      (failure) {
        _isLoading = false;
        notifyListeners();
        logger.e("Get profile failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> updateProfile(UpdateProfileDto updateProfileDto) async {
    _isLoading = true;
    notifyListeners();

    final result = await profileRepository.updateProfile(updateProfileDto: updateProfileDto);
    
    result.fold(
      (success) async {
        await getProfile();
        _isLoading = false;
        notifyListeners();
        showSuccessToast("Profile updated successfully");
      },
      (failure) {
        _isLoading = false;
        notifyListeners();
        logger.e("Update profile failed: $failure");
        showErrorToast(failure);
      }
    );

  }

  void storeProfile(UserProfileModel profile) {
    LocalStorageService.put(PrefKeys.userExpertId, profile.expertProfile?.id);
    LocalStorageService.put(PrefKeys.userImageUrl, profile.user?.profilePicture);
    LocalStorageService.put(PrefKeys.userFirstName, profile.user?.firstName);
    LocalStorageService.put(PrefKeys.userLastName, profile.user?.lastName);
    LocalStorageService.put(PrefKeys.userEmail, profile.user?.email);
    LocalStorageService.put(PrefKeys.userExpertId, profile.expertProfile?.id);
    LocalStorageService.put(PrefKeys.userCountry, profile.user?.country);
    LocalStorageService.put(PrefKeys.userState, profile.user?.state);
    LocalStorageService.put(PrefKeys.userCity, profile.user?.city);
    LocalStorageService.put(PrefKeys.userStreet, profile.user?.address);
    LocalStorageService.put(PrefKeys.userZip, profile.user?.zip);
    LocalStorageService.put(PrefKeys.userGender, profile.user?.gender);
    LocalStorageService.put(PrefKeys.userPhone, profile.user?.phone);

    userId = profile.user?.id;
    userExpertId = profile.expertProfile?.id;
    profilePicture = profile.user?.profilePicture;
    firstName = profile.user?.firstName;
    lastName = profile.user?.lastName;
    email = profile.user?.email;
    country = profile.user?.country;
    state = profile.user?.state;
    city = profile.user?.city;
    street = profile.user?.address;
    zip = profile.user?.zip;
    gender = profile.user?.gender;
    phone = profile.user?.phone;
    
    notifyListeners();
  }
}