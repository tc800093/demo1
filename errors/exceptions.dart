// lib/core/error/exceptions.dart
import 'package:dio/dio.dart';

class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});

  factory ServerException.fromDioError(DioException dioError) {
    String message = "Something went wrong";
    int? statusCode;

    if (dioError.response?.data != null && dioError.response?.data is Map) {
      if (dioError.response!.data.containsKey('message')) {
        message = dioError.response!.data['message'];
      }
    } else if (dioError.message != null) {
      message = dioError.message!;
    }

    statusCode = dioError.response?.statusCode;

    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = "Connection timeout with API server";
        break;
      case DioExceptionType.badResponse:
        message = "Bad response from server";
        break;
      case DioExceptionType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioExceptionType.unknown:
      default:
        if (dioError.message!.contains("SocketException")) {
          message = "No Internet Connection";
        }
        break;
    }
    return ServerException(message: message, statusCode: statusCode);
  }
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Cache Error'});
}
