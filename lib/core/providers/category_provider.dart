import 'package:earnwise_app/core/di/di.dart';
import 'package:earnwise_app/core/utils/toast.dart';
import 'package:earnwise_app/domain/models/category_model.dart';
import 'package:earnwise_app/domain/models/expert_profile_model.dart';
import 'package:earnwise_app/domain/repositories/category_repository.dart';
import 'package:earnwise_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final categoryNotifier = ChangeNotifierProvider((ref) => CategoryProvider());

class CategoryProvider extends ChangeNotifier {
  late final CategoryRepository categoryRepository;

  CategoryProvider() {
    categoryRepository = di.get();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  List<ExpertProfileModel> _experts = [];
  List<ExpertProfileModel> get experts => _experts;

  Future<void> getCategories() async {
    _isLoading = true;
    notifyListeners();

    final result = await categoryRepository.getCategories();
    result.fold(
      (success) {
        _isLoading = false;
        _categories = success;
        notifyListeners();
      },
      (failure) {
        _isLoading = false;
        notifyListeners();

        logger.e("Get categories failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> getExpertsByCategory({required String category}) async {
    _isLoading = true;
    _experts = [];
    notifyListeners();

    final result = await categoryRepository.getExpertsByCategory(category: category);
    result.fold(
      (success) {
        _isLoading = false;
        _experts = success;
        notifyListeners();
      },
      (failure) {
        _isLoading = false;
        _experts = [];
        notifyListeners();

        logger.e("Get experts by category failed: $failure");
        showErrorToast(failure);
      }
    );
  }
}