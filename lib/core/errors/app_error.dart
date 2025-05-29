class AppError {
  final String message;
  final int? statusCode;
  final dynamic originalException;

  AppError({
    required this.message,
    this.statusCode,
    this.originalException,
  });

  @override
  String toString() {
    return 'AppError(message: $message, statusCode: $statusCode, originalException: $originalException)';
  }
}