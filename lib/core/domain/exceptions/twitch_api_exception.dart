import "package:dio/dio.dart";

/// Exception for Twitch API errors.
class TwitchAPIException extends DioError {
  @override
  final String message;

  TwitchAPIException(this.message, {required super.requestOptions, required super.response});

  @override
  String toString() => "TwitchAPIException: $message";
}
