import 'package:dio/dio.dart';

class NetworkException implements DioError {
  final _message;
  final int code;

  NetworkException(
    this.requestOptions,
    this._message, {
    this.code = -1,
  });

  String toString() {
    return _message;
  }

  @override
  var error;

  @override
  RequestOptions? request;

  @override
  String get message => _message;

  @override
  RequestOptions requestOptions;

  @override
  StackTrace? stackTrace;

  @override
  Response? response;

  @override
  DioErrorType type = DioErrorType.other;
}

/// Represents there's no internet connection
class NoInternetException extends NetworkException {
  NoInternetException([String? message, String? path]) : super(RequestOptions(path: path ?? ''), message ?? 'No internet connection found!');

  @override
  Response? response;

  @override
  DioErrorType type = DioErrorType.other;
}

/// Represents error in communicating with server
class ServerConnectionException extends NetworkException {
  ServerConnectionException([String? message, String? path]) : super(RequestOptions(path: path ?? ''), message ?? 'Failed to connect with server, please try again later');
}

class FetchDataException extends NetworkException {
  FetchDataException([String? message, String? path]) : super(RequestOptions(path: path ?? ''), "Error During Communication: $message");
}

class BadRequestException extends NetworkException {
  BadRequestException([message, String? path]) : super(RequestOptions(path: path ?? ''), "Invalid Request: $message");
}

class UnauthorisedException extends NetworkException {
  UnauthorisedException([message, String? path]) : super(RequestOptions(path: path ?? ''), "Unauthorised: $message");
}

class InvalidInputException extends NetworkException {
  InvalidInputException([String? message, String? path]) : super(RequestOptions(path: path ?? ''), "Invalid Input: $message");
}
