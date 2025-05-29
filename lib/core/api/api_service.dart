import 'package:dio/dio.dart';
import 'dio_client.dart';
import '../utils/result.dart';
import '../errors/app_error.dart';
import '../errors/api_exceptions.dart';

class ApiService {
  final DioClient _dioClient;

  ApiService(this._dioClient);
  Future<Result<dynamic, AppError>> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final response = await _dioClient.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      if (response.data == null) {
        return Failure(DataParsingError(message: "Response data is null"));
      }
      return Success(response.data);
    } on DioException catch (e) {
      return Failure(_dioClient.handleDioException(e));
    } on FormatException catch (e) {
      return Failure(DataParsingError(message: "Failed to parse response: ${e.message}", originalException: e));
    } catch (e) {
      return Failure(UnknownError(message: "An unexpected error occurred: ${e.toString()}", originalException: e));
    }
  }
}