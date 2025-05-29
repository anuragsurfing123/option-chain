
import '../../../core/api/api_constants.dart';
import '../../../core/api/api_service.dart';
import '../../../core/errors/api_exceptions.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/utils/result.dart';
import '../models/option_data_model.dart';

abstract class OptionChainRemoteDataSource {
  Future<Result<List<OptionDataModel>, AppError>> fetchOptionChain(String symbol);
}

class OptionChainRemoteDataSourceImpl implements OptionChainRemoteDataSource {
  final ApiService _apiService;

  OptionChainRemoteDataSourceImpl(this._apiService);

  @override
  Future<Result<List<OptionDataModel>, AppError>> fetchOptionChain(String symbol) async {
    final result = await _apiService.get(
      ApiConstants.optionChainEndpoint,
      queryParameters: {'symbol': symbol},
    );

    return result.when(
          (jsonData) {
        try {
          if (jsonData is Map<String, dynamic> && jsonData.containsKey('records')) {
            final records = jsonData['records'] as Map<String, dynamic>?;
            if (records != null && records.containsKey('data')) {
              final dataList = records['data'] as List<dynamic>? ?? [];
              final options = dataList
                  .map((item) => OptionDataModel.fromJson(item as Map<String, dynamic>))
                  .toList();
              return Success(options);
            }
          }
          return Failure(DataParsingError(message: "Unexpected JSON structure from API."));

        } catch (e) {
          return Failure(DataParsingError(message: "Failed to parse option chain data: ${e.toString()}", originalException: e));
        }
      },
          (error) => Failure(error),
    );
  }
}