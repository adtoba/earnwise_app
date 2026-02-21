import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:earnwise_app/core/utils/error_util.dart';
import 'package:earnwise_app/data/services/api_service.dart';
import 'package:earnwise_app/domain/repositories/review_repository.dart';

class ReviewHttpRepository extends ApiService implements ReviewRepository {
  @override
  Future<Either<Response, String>> getExpertReviews({required String expertId}) async {
    try {
      final response = await http.get("/reviews/expert/$expertId");
      return left(response);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    }
  }

  @override
  Future<Either<Response, String>> addReview({required String expertId, required String userId, required String comment, required String fullName, required double rating}) async {
    try {
      final response = await http.post("/reviews", data: {
        "expert_id": expertId,
        "user_id": userId,
        "comment": comment,
        "full_name": fullName,
        "rating": rating,
      });
      return left(response);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    }
  }

  @override
  Future<Either<Response, String>> getMyReviews() async {
    try {
      final response = await http.get("/reviews");
      return left(response);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    }
  }
}