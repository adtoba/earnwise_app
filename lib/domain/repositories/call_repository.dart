import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:earnwise_app/domain/models/call_model.dart';

abstract class CallRepository {
  Future<Either<Response, String>> bookCall({
    required String expertId, 
    required String scheduledDate, 
    required String subject,
    String? note,
    required String duration,
  });
  Future<Either<Response, String>> acceptCall({required String callId});
  Future<Either<List<CallModel>, String>> getUserCallHistory({String? status});
  Future<Either<List<CallModel>, String>> getExpertCallHistory({String? status});
}