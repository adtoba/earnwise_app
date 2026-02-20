import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:earnwise_app/core/constants/endpoints.dart';
import 'package:earnwise_app/core/utils/error_util.dart';
import 'package:earnwise_app/data/services/api_service.dart';
import 'package:earnwise_app/domain/dto/create_expert_profile_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_availability_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_details_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_rate_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_socials_dto.dart';
import 'package:earnwise_app/domain/models/expert_dashboard_model.dart';
import 'package:earnwise_app/domain/models/expert_profile_model.dart';
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
  Future<Either<ExpertProfileModel, String>> getExpertProfileById({required String expertId}) async {
    try {
      final response = await http.get("${Endpoints.experts}/$expertId");
      return left(ExpertProfileModel.fromJson(response.data["data"]));
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<Response<dynamic>, String>> getExpertProfile() async {
    try {
      final response = await http.get("${Endpoints.experts}/profile");
      return left(response);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<Response<dynamic>, String>> updateExpertAvailability({required List<UpdateExpertAvailabilityDto> updateExpertAvailabilityDto}) async {
    try {
      final response = await http.put("${Endpoints.experts}/availability", data: {
        "availability": updateExpertAvailabilityDto.map((e) => e.toJson()).toList()
      });
      return left(response);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<Response<dynamic>, String>> updateExpertDetails({required UpdateExpertDetailsDto updateExpertDetailsDto}) async {
    try {
      final response = await http.put("${Endpoints.experts}/details", data: updateExpertDetailsDto.toJson());
      return left(response);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<Response<dynamic>, String>> updateExpertRate({required UpdateExpertRateDto updateExpertRateDto}) async {
    try {
      final response = await http.put("${Endpoints.experts}/rate", data: updateExpertRateDto.toJson());
      return left(response);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<Response<dynamic>, String>> updateExpertSocials({required UpdateExpertSocialsDto updateExpertSocialsDto}) async {
    try {
      final response = await http.put("${Endpoints.experts}/socials", data: updateExpertSocialsDto.toJson());
      return left(response);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<ExpertDashboardModel, String>> getExpertDashboard() async {
    try {
      final response = await http.get(Endpoints.expertDashboard);
      return left(ExpertDashboardModel.fromJson(response.data["data"]));
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<List<ExpertProfileModel>, String>> getRecommendedExperts() async {
    try {
      final response = await http.get("${Endpoints.experts}/recommended");
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

  @override
  Future<Either<List<ExpertProfileModel>, String>> getSavedExperts() async {
    try {
      final response = await http.get("${Endpoints.users}/saved-experts");
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

  @override
  Future<Either<Response, String>> saveExpert({required String expertId}) async {
    try {
      final response = await http.post("${Endpoints.users}/save-expert", data: {
        "expert_id": expertId,
      });
      return left(response);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<Response, String>> unSaveExpert({required String expertId}) async {
    try {
      final response = await http.delete("${Endpoints.users}/unsave-expert", data: {
        "expert_id": expertId,
      });
      return left(response);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }
  
}