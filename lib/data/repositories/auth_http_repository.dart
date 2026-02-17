import 'package:earnwise_app/core/constants/endpoints.dart';
import 'package:earnwise_app/core/utils/error_util.dart';
import 'package:earnwise_app/data/services/api_service.dart';
import 'package:earnwise_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AuthHttpRepository extends ApiService implements AuthRepository {
  @override
  Future<Either<Response, String>> login({required String email, required String password}) async {
    try {
      final response = await http.post(Endpoints.login, data: {
        "email": email,
        "password": password,
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
  Future<Either<Response, String>> register({required String firstName, required String lastName, required String email, required String password}) async {
    try {
      final response = await http.post(Endpoints.register, data: {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
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
  Future<Either<Response, String>> refreshToken({required String refreshToken}) async {
    try {
      final response = await http.post(Endpoints.refresh, data: {
        "refresh_token": refreshToken,
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