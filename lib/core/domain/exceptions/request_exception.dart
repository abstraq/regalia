class RequestException implements Exception {
  String message;

  RequestException(this.message);

  @override
  String toString() => "RequestException: $message";
}
