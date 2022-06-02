/// Exception that occurs when the user attempts to access something
/// that the current state shouldn't have access to.
class IllegalStateException implements Exception {
  /// Message describing the error.
  final String? message;

  IllegalStateException([this.message]);

  @override
  String toString() => "IllegalStateException: $message";
}
