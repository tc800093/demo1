// lib/core/error/failures.dart
import 'package:equatable/equatable.dart';
import 'package:gscflutterappv3/core/constants/error_handler.dart';

abstract class Failure extends Equatable {
  const Failure([this.properties = const <dynamic>[]]);

  final List<dynamic> properties;

  @override
  List<Object?> get props => properties;
}

/* class ServerFailure extends Failure {
  final String message;
  const ServerFailure({this.message = 'Server Error'});

  @override
  List<Object?> get props => [message];
} */
class ServerFailure extends Failure {
  final String message;
  final int? statusCode;
  final ErrorCategory category;
  final bool isTokenExpired;

  const ServerFailure({
    required this.message,
    this.statusCode,
    this.category = ErrorCategory.unknown,
    this.isTokenExpired = false,
  });

  @override
  String toString() =>
      'ServerFailure(message: $message, statusCode: $statusCode, category: $category)';
}

class CacheFailure extends Failure {
  final String message;
  const CacheFailure({this.message = 'Cache Error'});

  @override
  List<Object?> get props => [message];
}

class DataFailures extends Failure {
  final String message;
  const DataFailures({this.message = 'Authentication Failed'});

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends Failure {
  final String message;
  const AuthFailure({this.message = 'Authentication Failed'});

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  final String message;
  const NetworkFailure({this.message = 'No Internet Connection'});

  @override
  List<Object?> get props => [message];
}
