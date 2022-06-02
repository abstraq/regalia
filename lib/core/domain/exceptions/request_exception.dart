import "package:dio/dio.dart";

/// Exception that occurs when there was an error making a HTTP request.
class RequestException extends DioError {
  @override
  String message;

  RequestException(this.message, {required super.requestOptions});

  @override
  String toString() => "RequestException: $message";
}
