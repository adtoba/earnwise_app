import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:earnwise_app/domain/dto/update_profile_dto.dart';
import 'package:earnwise_app/domain/models/user_profile_model.dart';

abstract class ProfileRepository {
  Future<Either<UserProfileModel, String>> getProfile();
  Future<Either<Response, String>> updateProfile({required UpdateProfileDto updateProfileDto});
  Future<Either<Response, String>> uploadProfilePicture({required String imagePath});
}