/// Exception for Twitch API errors.
class TwitchAPIException implements Exception {
  final int? statusCode;
  final String? message;

  TwitchAPIException({required this.statusCode, required this.message});

  @override
  String toString() => "TwitchAPIException(code: $statusCode, message: $message)";
}
