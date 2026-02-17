import 'package:dartz/dartz.dart';
import 'package:earnwise_app/domain/models/category_model.dart';
import 'package:earnwise_app/domain/models/expert_profile_model.dart';

abstract class CategoryRepository {
  Future<Either<List<CategoryModel>, String>> getCategories();
  Future<Either<List<ExpertProfileModel>, String>> getExpertsByCategory({required String category});
}