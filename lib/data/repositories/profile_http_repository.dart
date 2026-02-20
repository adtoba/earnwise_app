import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:earnwise_app/core/constants/endpoints.dart';
import 'package:earnwise_app/core/utils/error_util.dart';
import 'package:earnwise_app/data/services/api_service.dart';
import 'package:earnwise_app/domain/dto/update_profile_dto.dart';
import 'package:earnwise_app/domain/models/expert_profile_model.dart';
import 'package:earnwise_app/domain/models/user_profile_model.dart';
import 'package:earnwise_app/domain/repositories/profile_repository.dart';

class ProfileHttpRepository extends ApiService implements ProfileRepository {
  @override
  Future<Either<UserProfileModel, String>> getProfile() async {
    try {
      final response = await http.get(Endpoints.profile);
      final profile = UserProfileModel(
        user: response.data["data"]["user"] != null ? User.fromJson(response.data["data"]["user"]) : null,
        expertProfile: response.data["data"]["expert_profile"] != null ? ExpertProfileModel.fromJson(response.data["data"]["expert_profile"]) : null,
      );
      return left(profile);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());}
  }

  @override
  Future<Either<Response<dynamic>, String>> uploadProfilePicture({required String imagePath}) async {
    try {
      final response = await http.put("${Endpoints.users}/profile-picture", data: {
        "profile_picture": imagePath,
      });
      return left(response);
    }
    on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<Response<dynamic>, String>> updateProfile({required UpdateProfileDto updateProfileDto}) async {
    try {
      final response = await http.put(Endpoints.users, data: updateProfileDto.toJson());
      return left(response);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }
}