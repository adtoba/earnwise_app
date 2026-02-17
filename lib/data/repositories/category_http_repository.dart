import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:earnwise_app/core/constants/endpoints.dart';
import 'package:earnwise_app/core/utils/error_util.dart';
import 'package:earnwise_app/data/services/api_service.dart';
import 'package:earnwise_app/domain/models/category_model.dart';
import 'package:earnwise_app/domain/models/expert_profile_model.dart';
import 'package:earnwise_app/domain/repositories/category_repository.dart';

class CategoryHttpRepository extends ApiService implements CategoryRepository {
  @override
  Future<Either<List<CategoryModel>, String>> getCategories() async {
    try {
      final response = await http.get(Endpoints.categories);
      return left((response.data["data"] as List<dynamic>).map((e) => CategoryModel.fromJson(e)).toList());
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<List<ExpertProfileModel>, String>> getExpertsByCategory({required String category}) async {
    try {
      final response = await http.get(Endpoints.expertsByCategory(category));
      if(response.data["data"] != null) {
        return left((response.data["data"] as List<dynamic>).map((e) => ExpertProfileModel.fromJson(e)).toList());
      } else {
        return left([]);
      }
      
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }
}