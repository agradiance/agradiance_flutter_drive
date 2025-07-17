import 'package:agradiance_flutter_drive/src/errors/exceptions.dart';
import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  const Failure({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  // String get errorMessage => '$statusCode Error: $message';
  String get errorMessage => message;

  @override
  List<Object?> get props => [message, statusCode];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, required super.statusCode});
}

class APIFailure extends Failure {
  const APIFailure({required super.message, required super.statusCode});

  APIFailure.fromException(APIException exception)
    : this(message: exception.message, statusCode: exception.statusCode ?? -1);
}
