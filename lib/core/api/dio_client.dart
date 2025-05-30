import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'api_constants.dart';
import '../errors/api_exceptions.dart';
import '../errors/app_error.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    final options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    );
    _dio = Dio(options);
    _dio.interceptors.add(LoggingInterceptor());
  }

  Dio get dio => _dio;

  AppError handleDioException(DioException error) {
    debugPrint("DioException caught by handler: ${error.type}, ${error.message}");
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return TimeoutError();
    } else if (error.type == DioExceptionType.badResponse) {
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;
      String errorMessage = "Server error occurred.";
      if (responseData is Map && responseData.containsKey('message')) {
        errorMessage = responseData['message'];
      } else if (responseData is String && responseData.isNotEmpty) {
        errorMessage = responseData;
      } else if (error.message != null && error.message!.isNotEmpty) {
        errorMessage = error.message!;
      }

      switch (statusCode) {
        case 400:
          return BadRequestError(message: errorMessage, originalException: error);
        case 401:
        case 403:
          return UnauthorizedError(message: errorMessage);
        case 404:
          return NotFoundError(message: errorMessage);
        case 500:
        case 502:
        case 503:
          return ServerError(message: errorMessage, statusCode: statusCode, originalException: error);
        default:
          return ServerError(message: "Received invalid status code: $statusCode. Message: $errorMessage", statusCode: statusCode, originalException: error);
      }
    } else if (error.type == DioExceptionType.cancel) {
      return AppError(message: "Request was cancelled.");
    } else if (error.error is SocketException) {
      return NetworkError();
    }
    return UnknownError(message: error.message ?? "An unknown error occurred", originalException: error);
  }

  Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

}

// logging
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path} => Query: ${options.queryParameters}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    debugPrint('ERROR_MESSAGE: ${err.message}');
    debugPrint('ERROR_TYPE: ${err.type}');
    return super.onError(err, handler);
  }
}