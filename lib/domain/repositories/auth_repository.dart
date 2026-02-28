import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class AuthRepository {
  Future<Either<Response, String>> login({required String email, required String password});
  Future<Either<Response, String>> register({required String firstName, required String lastName, required String email, required String password});
  Future<Either<Response, String>> googleAuth({required String idToken});
  Future<Either<Response, String>> refreshToken({required String refreshToken});
}