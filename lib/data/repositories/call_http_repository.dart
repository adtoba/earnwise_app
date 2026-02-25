import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:earnwise_app/core/utils/error_util.dart';
import 'package:earnwise_app/data/services/api_service.dart';
import 'package:earnwise_app/domain/models/call_model.dart';
import 'package:earnwise_app/domain/repositories/call_repository.dart';

class CallHttpRepository extends ApiService implements CallRepository {
  @override
  Future<Either<Response, String>> bookCall({
    required String expertId, 
    required String scheduledDate, 
    required String subject,
    String? note,
    required String duration,
  }) async {
    try {
      final response = await http.post("/calls/", data: {
        "expert_id": expertId,
        "scheduled_at": toIsoNoOffset(scheduledDate),
        "subject": subject,
        "timezone": "Africa/Lagos",
        "description": note,
        "duration_mins": int.parse(duration),
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
  Future<Either<List<CallModel>, String>> getUserCallHistory({String? status}) async {
    try {
      final response = await http.get("/calls/user", queryParameters: {
        "status": status,
      }); 
      if(response.data["data"] != null) {
        return left((response.data["data"] as List<dynamic>).map((e) => CallModel.fromJson(e)).toList());
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
  Future<Either<List<CallModel>, String>> getExpertCallHistory({String? status}) async {
    try {
      final response = await http.get("/calls/expert", queryParameters: {
        "status": status,
      });

      if(response.data["data"] != null) {
        return left((response.data["data"] as List<dynamic>).map((e) => CallModel.fromJson(e)).toList());
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
  Future<Either<Response, String>> acceptCall({required String callId}) async {
    try {
      final response = await http.put("/calls/$callId/accept");
      return left(response);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  String toIsoNoOffset(String input) {
    final dt = DateTime.parse(input);
    String two(int v) => v.toString().padLeft(2, '0');
    return "${dt.year}-${two(dt.month)}-${two(dt.day)}"
          "T${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}Z";
  }
}