/// Exception that occurs when there is an error authenticating
/// with Twitch.
class IllegalStateException implements Exception {
  /// Message describing the error.
  final String? message;

  IllegalStateException([this.message]);

  @override
  String toString() => "IllegalStateException: $message";
}
