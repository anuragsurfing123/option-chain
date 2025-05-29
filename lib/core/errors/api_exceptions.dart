import 'app_error.dart';

class NetworkError extends AppError {
  NetworkError({String message = "No internet connection. Please check your network."})
      : super(message: message);
}

class ServerError extends AppError {
  ServerError({required String message, int? statusCode, dynamic originalException})
      : super(message: message, statusCode: statusCode, originalException: originalException);
}

class UnauthorizedError extends AppError {
  UnauthorizedError({String message = "Unauthorized. Please login again."})
      : super(message: message, statusCode: 401);
}

class BadRequestError extends AppError {
  BadRequestError({required String message, dynamic originalException})
      : super(message: message, statusCode: 400, originalException: originalException);
}

class NotFoundError extends AppError {
  NotFoundError({String message = "The requested resource was not found."})
      : super(message: message, statusCode: 404);
}

class TimeoutError extends AppError {
  TimeoutError({String message = "The request timed out. Please try again."})
      : super(message: message);
}

class DataParsingError extends AppError {
  DataParsingError({String message = "Error parsing data.", dynamic originalException})
      : super(message: message, originalException: originalException);
}

class UnknownError extends AppError {
  UnknownError({String message = "An unexpected error occurred.", dynamic originalException})
      : super(message: message, originalException: originalException);
}