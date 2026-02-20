import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/constants/pref_keys.dart';
import 'package:earnwise_app/core/di/di.dart';
import 'package:earnwise_app/core/utils/toast.dart';
import 'package:earnwise_app/data/services/cloudinary_service.dart';
import 'package:earnwise_app/data/services/local_storage_service.dart';
import 'package:earnwise_app/domain/dto/update_profile_dto.dart';
import 'package:earnwise_app/domain/models/expert_profile_model.dart';
import 'package:earnwise_app/domain/models/user_profile_model.dart';
import 'package:earnwise_app/domain/repositories/profile_repository.dart';
import 'package:earnwise_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

final profileNotifier = ChangeNotifierProvider((ref) => ProfileProvider());

class ProfileProvider extends ChangeNotifier {
  late final ProfileRepository profileRepository;

  ProfileProvider() {
    profileRepository = di.get();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUploadingProfilePicture = false;
  bool get isUploadingProfilePicture => _isUploadingProfilePicture;

  UserProfileModel? _profile;
  UserProfileModel? get profile => _profile;

  String? _profilePictureUrl;
  String? get profilePictureUrl => _profilePictureUrl;
  set profilePictureUrl(String? value) {
    _profilePictureUrl = value;
    notifyListeners();
  }

  void uploadPicture() async {
    ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      if(value != null) {
        _isUploadingProfilePicture = true;
        notifyListeners();

        CloudinaryService.uploadImage(imagePath: value.path).then((value) async {
          if(value != null) {
            await uploadProfilePicture(value);
          }
        });
      }
    });
  }

  Future<void> getProfile() async {
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

  Future<void> uploadProfilePicture(String imagePath) async {
    _isUploadingProfilePicture = true;
    notifyListeners();

    final result = await profileRepository.uploadProfilePicture(imagePath: imagePath);
    result.fold(
      (success) async {
        await getProfile();
        _isUploadingProfilePicture = false;
        notifyListeners();
        showSuccessToast("Profile picture uploaded successfully");
      },
      (failure) {
        _isUploadingProfilePicture = false;
        notifyListeners();
        logger.e("Upload profile picture failed: $failure");
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