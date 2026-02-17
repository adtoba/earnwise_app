import 'package:dio/dio.dart';

class ErrorUtil {
  static String parseDioError(DioException exception) {
    if(exception.type == DioExceptionType.badResponse) {
      if(exception.response?.data is String) {
        return exception.response?.data;
      }
      var response = exception.response;
      if(response?.data['error'] != null) {
        return response?.data['error'];
      } else if(response?.data['message'] != null) {
        return response?.data['message'];
      } else if(response?.data is String) {
        return response?.data;
      }
      return "An error occured, please try again later";
    } else if(exception.type == DioExceptionType.receiveTimeout || exception.type == DioExceptionType.sendTimeout) {
      return "Your request has timed out, please try again!";
    } else if(exception.type == DioExceptionType.connectionError) {
      return "An error occured, please try again later";
    } else {
      return "An error occured, please try again later";
    }
  }
}