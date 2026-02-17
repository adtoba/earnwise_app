import 'package:earnwise_app/core/di/di.dart';
import 'package:earnwise_app/core/providers/profile_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/toast.dart';
import 'package:earnwise_app/domain/dto/create_expert_profile_dto.dart';
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

  ExpertProfileModel? _expertProfile;
  ExpertProfileModel? get expertProfile => _expertProfile;

  CreateExpertProfileDto? createExpertProfileDto;

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
}