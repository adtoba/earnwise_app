import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:earnwise_app/domain/dto/create_expert_profile_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_availability_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_details_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_rate_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_socials_dto.dart';
import 'package:earnwise_app/domain/models/expert_dashboard_model.dart';
import 'package:earnwise_app/domain/models/expert_profile_model.dart';
import 'package:earnwise_app/domain/models/slot_model.dart';

abstract class ExpertRepository {
  Future<Either<Response, String>> createExpertProfile({required CreateExpertProfileDto createExpertProfileDto});
  Future<Either<ExpertDashboardModel, String>> getExpertDashboard();
  Future<Either<Response, String>> getExpertProfile();
  Future<Either<List<ExpertProfileModel>, String>> getRecommendedExperts();
  Future<Either<List<ExpertProfileModel>, String>> searchExperts({required String searchQuery});
  Future<Either<List<ExpertProfileModel>, String>> getSavedExperts();
  Future<Either<ExpertProfileModel, String>> getExpertProfileById({required String expertId});
  Future<Either<List<SlotModel>, String>> getExpertAvailableSlots({required String expertId, required String? date, required int duration});
  Future<Either<Response, String>> saveExpert({required String expertId});
  Future<Either<Response, String>> unSaveExpert({required String expertId});
  Future<Either<Response, String>> updateExpertDetails({required UpdateExpertDetailsDto updateExpertDetailsDto});
  Future<Either<Response, String>> updateExpertRate({required UpdateExpertRateDto updateExpertRateDto});
  Future<Either<Response, String>> updateExpertAvailability({required List<UpdateExpertAvailabilityDto> updateExpertAvailabilityDto});
  Future<Either<Response, String>> updateExpertSocials({required UpdateExpertSocialsDto updateExpertSocialsDto});
}