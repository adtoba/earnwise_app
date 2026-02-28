import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class ReviewRepository {
  Future<Either<Response, String>> getExpertReviews({required String expertId});
  Future<Either<Response, String>> addReview({
    required String expertId,
    required String userId,
    required String comment,
    required String fullName, 
    required double rating,
  });
  Future<Either<Response, String>> getMyReviews();
}