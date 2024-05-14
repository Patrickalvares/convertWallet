class ApplicationException implements Exception {
  ApplicationException(
    this.message, {
    this.stackTrace,
  });
  final String message;
  final StackTrace? stackTrace;

  @override
  String toString() {
    return message;
  }
}
