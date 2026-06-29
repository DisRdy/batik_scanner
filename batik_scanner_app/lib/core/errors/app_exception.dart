class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

String errorMessage(Object error) {
  if (error is AppException) {
    return error.message;
  }
  return error.toString().replaceFirst('Exception: ', '');
}
