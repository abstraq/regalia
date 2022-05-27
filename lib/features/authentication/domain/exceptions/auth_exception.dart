/// Exception that occurs when there is an error authenticating
/// with Twitch.
class AuthException implements Exception {
  /// Message describing the error.
  final String message;

  AuthException(this.message);

  @override
  String toString() => "AuthException: $message";
}
