import "dart:developer" as developer;

import "package:dio/dio.dart";
import "package:regalia/core/domain/exceptions/request_exception.dart";
import "package:regalia/core/domain/exceptions/twitch_api_exception.dart";

/// Interceptor for [Dio] that handles logging requests and converting the [DioError]
/// into something more descriptive.
class RegaliaInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final method = options.method;
    final targetUri = options.uri;

    developer.log(name: "HTTP", "Sending $method to $targetUri");
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final requestOptions = err.requestOptions;
    final method = requestOptions.method;
    final targetUri = requestOptions.uri;

    switch (err.type) {
      case DioErrorType.connectTimeout:
        final message = "Connection timeout when sending $method to $targetUri";
        developer.log(name: "HTTP", message, error: err);
        handler.next(RequestException(message, requestOptions: requestOptions));
        break;

      case DioErrorType.sendTimeout:
        final message = "Send timeout when sending $method to $targetUri";
        developer.log(name: "HTTP", message, error: err);
        handler.next(RequestException(message, requestOptions: requestOptions));
        break;

      case DioErrorType.receiveTimeout:
        final message = "Receive timeout from $method to $targetUri";
        developer.log(name: "HTTP", message, error: err);
        handler.next(RequestException(message, requestOptions: requestOptions));
        break;

      case DioErrorType.response:
        final response = err.response!;
        final message = "Received $method to $targetUri with status code ${response.statusCode}";
        developer.log(name: "HTTP", message, error: err);
        handler.next(TwitchAPIException(message, requestOptions: requestOptions, response: response));
        break;

      case DioErrorType.cancel:
        final message = "Cancelled $method to $targetUri";
        developer.log(name: "HTTP", message, error: err);
        handler.next(RequestException(message, requestOptions: requestOptions));
        break;

      default:
        final message = "An error occurred when sending $method to $targetUri: ${err.message}";
        developer.log(name: "HTTP", message, error: err);
        handler.next(RequestException(message, requestOptions: requestOptions));
        break;
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final method = response.requestOptions.method;
    final targetUri = response.requestOptions.uri.toString();
    final status = response.statusCode.toString();

    developer.log(name: "HTTP", "Completed $method to $targetUri with status: $status");
    handler.next(response);
  }
}
