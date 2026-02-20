import 'package:earnwise_app/core/di/di.dart';
import 'package:earnwise_app/core/providers/profile_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/toast.dart';
import 'package:earnwise_app/domain/dto/create_expert_profile_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_availability_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_details_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_rate_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_socials_dto.dart';
import 'package:earnwise_app/domain/models/expert_dashboard_model.dart';
import 'package:earnwise_app/domain/models/expert_profile_model.dart';
import 'package:earnwise_app/domain/repositories/expert_repository.dart';
import 'package:earnwise_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final expertNotifier = ChangeNotifierProvider((ref) => ExpertProvider(ref));

class ExpertProvider extends ChangeNotifier {
  late final ExpertRepository expertRepository;
  late final Ref ref;

  ExpertProvider(Ref r) {
    expertRepository = di.get();
    ref = r;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isExpertDashboardLoading = false;
  bool get isExpertDashboardLoading => _isExpertDashboardLoading;

  bool _isRecommendedExpertsLoading = false;
  bool get isRecommendedExpertsLoading => _isRecommendedExpertsLoading;

  bool _isSavedExpertsLoading = false;
  bool get isSavedExpertsLoading => _isSavedExpertsLoading;

  bool _isCurrentExpertProfileLoading = false;
  bool get isCurrentExpertProfileLoading => _isCurrentExpertProfileLoading;

  List<ExpertProfileModel> _recommendedExperts = [];
  List<ExpertProfileModel> get recommendedExperts => _recommendedExperts;

  List<ExpertProfileModel> _savedExperts = [];
  List<ExpertProfileModel> get savedExperts => _savedExperts;

  ExpertProfileModel? _expertProfile;
  ExpertProfileModel? get expertProfile => _expertProfile;

  ExpertDashboardModel? _expertDashboard;
  ExpertDashboardModel? get expertDashboard => _expertDashboard;

  CreateExpertProfileDto? createExpertProfileDto;

  bool _isCurrentSavedExpertSaved = false;
  bool get isCurrentSavedExpertSaved => _isCurrentSavedExpertSaved;

  ExpertProfileModel? _currentExpertProfile;
  ExpertProfileModel? get currentExpertProfile => _currentExpertProfile;

  void setCurrentSavedExpertSaved(bool value) {
    _isCurrentSavedExpertSaved = value;
    notifyListeners();
  }

  Future<void> createExpertProfile() async {
    _isLoading = true;
    notifyListeners();

    final result = await expertRepository.createExpertProfile(
      createExpertProfileDto: createExpertProfileDto!
    );

    result.fold(
      (success) {
        ref.read(profileNotifier).getProfile();
        _isLoading = false;
        notifyListeners();
        pop();
        pop();
        pop();
        showSuccessToast("Expert profile created successfully");
      },
      (failure) {
        _isLoading = false;
        notifyListeners();
        logger.e("Create expert profile failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> getExpertProfileById(String expertId) async {
    _currentExpertProfile = null;
    _isCurrentSavedExpertSaved = false;
    _isCurrentExpertProfileLoading = true;
    notifyListeners();

    final result = await expertRepository.getExpertProfileById(expertId: expertId);
    result.fold(
      (success) {
        _isCurrentExpertProfileLoading = false;
        _currentExpertProfile = success;
        _isCurrentSavedExpertSaved = success.isSaved ?? false;
        notifyListeners();
      },
      (failure) {
        _isCurrentExpertProfileLoading = false;
        _currentExpertProfile = null;
        _isCurrentSavedExpertSaved = false;
        notifyListeners();
        logger.e("Get expert profile by id failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> getExpertDashboard() async {
    _isExpertDashboardLoading = true;
    notifyListeners();

    final result = await expertRepository.getExpertDashboard();
    result.fold(
      (success) {
        _isExpertDashboardLoading = false;
        _expertDashboard = success;
        notifyListeners();
      },
      (failure) {
        _isExpertDashboardLoading = false;
        notifyListeners();
        logger.e("Get expert dashboard failed: $failure");
        showErrorToast(failure);
      },
    );
  }

  Future<void> getRecommendedExperts() async {
    _isRecommendedExpertsLoading = true;
    notifyListeners();

    final result = await expertRepository.getRecommendedExperts();
    result.fold(
      (success) {
        _isRecommendedExpertsLoading = false;
        _recommendedExperts = success;
        notifyListeners();
      },
      (failure) {
        _isRecommendedExpertsLoading = false;
        notifyListeners();
        logger.e("Get recommended experts failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> getSavedExperts() async {
    _isSavedExpertsLoading = true;
    notifyListeners();

    final result = await expertRepository.getSavedExperts();
    result.fold(
      (success) {
        _isSavedExpertsLoading = false;
        _savedExperts = success;
        notifyListeners();
      },
      (failure) {
        _isSavedExpertsLoading = false;
        _savedExperts = [];
        notifyListeners();
        logger.e("Get saved experts failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> saveExpert(String expertId) async {
    _isLoading = true;
    notifyListeners();

    final result = await expertRepository.saveExpert(expertId: expertId);
    result.fold(
      (success) {
        _isLoading = false;
        _isCurrentSavedExpertSaved = true;
        notifyListeners();
        showSuccessToast("Expert saved successfully");
      },
      (failure) {
        _isLoading = false;
        notifyListeners();
        logger.e("Save expert failed: $failure");
        showErrorToast(failure);
      } 
    );
  }

  Future<void> unsaveExpert(String expertId) async {
    _isLoading = true;
    notifyListeners();

    final result = await expertRepository.unSaveExpert(expertId: expertId);
    result.fold(
      (success) {
        _isLoading = false;
        _isCurrentSavedExpertSaved = false;
        _savedExperts = _savedExperts.where((element) => element.id != expertId).toList();
        notifyListeners();
        showSuccessToast("Expert unsaved successfully");
      },
      (failure) {
        _isLoading = false;
        _isCurrentSavedExpertSaved = false;
        notifyListeners();
        logger.e("Unsave expert failed: $failure");
        showErrorToast(failure);
      } 
    );
  }

  Future<void> updateExpertSocials(UpdateExpertSocialsDto updateExpertSocialsDto) async {
    _isLoading = true;
    notifyListeners();

    final result = await expertRepository.updateExpertSocials(updateExpertSocialsDto: updateExpertSocialsDto);
    result.fold(
      (success) async {
        await getExpertDashboard();
        _isLoading = false;
        notifyListeners();
        showSuccessToast("Socials updated successfully");
      },
      (failure) {
        _isLoading = false;
        notifyListeners();
        logger.e("Update expert profile failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> updateExpertDetails(UpdateExpertDetailsDto updateExpertDetailsDto) async {
    _isLoading = true;
    notifyListeners();

    final result = await expertRepository.updateExpertDetails(updateExpertDetailsDto: updateExpertDetailsDto);
    result.fold(
      (success) async {
        await getExpertDashboard();
        _isLoading = false;
        notifyListeners();
        showSuccessToast("Expert profile updated successfully");
      },
      (failure) {
        _isLoading = false;
        notifyListeners();
        logger.e("Update expert profile failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> updateExpertRate(UpdateExpertRateDto updateExpertRateDto) async {
    _isLoading = true;
    notifyListeners();

    final result = await expertRepository.updateExpertRate(updateExpertRateDto: updateExpertRateDto);
    result.fold(
      (success) async {
        await getExpertDashboard();
        _isLoading = false;
        notifyListeners();
        showSuccessToast("Rates updated successfully");
      },
      (failure) {
        _isLoading = false;
        notifyListeners();
        logger.e("Update expert profile failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> updateExpertAvailability(List<UpdateExpertAvailabilityDto> updateExpertAvailabilityDto) async {
    _isLoading = true;
    notifyListeners();

    final result = await expertRepository.updateExpertAvailability(updateExpertAvailabilityDto: updateExpertAvailabilityDto);
    result.fold(
      (success) async {
        await getExpertDashboard();
        _isLoading = false;
        notifyListeners();
        showSuccessToast("Availability updated successfully");
      },
      (failure) {
        _isLoading = false;
        notifyListeners();
        logger.e("Update expert profile failed: $failure");
        showErrorToast(failure);
      }
    );
  }
}