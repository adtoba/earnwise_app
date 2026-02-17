import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:earnwise_app/core/constants/endpoints.dart';
import 'package:earnwise_app/core/utils/error_util.dart';
import 'package:earnwise_app/data/services/api_service.dart';
import 'package:earnwise_app/domain/dto/create_expert_profile_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_availability_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_details_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_rate_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_socials_dto.dart';
import 'package:earnwise_app/domain/repositories/expert_repository.dart';

class ExpertHttpRepository extends ApiService implements ExpertRepository {
  @override
  Future<Either<Response<dynamic>, String>> createExpertProfile({required CreateExpertProfileDto createExpertProfileDto}) async {
    try {
      final response = await http.post(Endpoints.experts, data: createExpertProfileDto.toJson());
      return left(response);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<Response<dynamic>, String>> getExpertProfile() {
    // TODO: implement getExpertProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Response<dynamic>, String>> updateExpertAvailability({required List<UpdateExpertAvailabilityDto> updateExpertAvailabilityDto}) {
    // TODO: implement updateExpertAvailability
    throw UnimplementedError();
  }

  @override
  Future<Either<Response<dynamic>, String>> updateExpertDetails({required UpdateExpertDetailsDto updateExpertDetailsDto}) {
    // TODO: implement updateExpertDetails
    throw UnimplementedError();
  }

  @override
  Future<Either<Response<dynamic>, String>> updateExpertRate({required UpdateExpertRateDto updateExpertRateDto}) {
    // TODO: implement updateExpertRate
    throw UnimplementedError();
  }

  @override
  Future<Either<Response<dynamic>, String>> updateExpertSocials({required UpdateExpertSocialsDto updateExpertSocialsDto}) {
    // TODO: implement updateExpertSocials
    throw UnimplementedError();
  }

}