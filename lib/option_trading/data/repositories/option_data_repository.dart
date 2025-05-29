import '../../../core/errors/app_error.dart';
import '../../../core/utils/result.dart';
import '../../domain/entities/option_entity.dart';
import '../../domain/repositories/i_option_repository.dart';
import '../datasources/option_chain_remote_data_source.dart';
import '../mapper/option_mapper.dart';
import '../models/option_data_model.dart';

class OptionChainRepositoryImpl implements OptionChainRepository {
  final OptionChainRemoteDataSource _remoteDataSource;

  OptionChainRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<OptionEntity>, AppError>> getOptionChain(String symbol) async {
    final result = await _remoteDataSource.fetchOptionChain(symbol);
    return result.when(
          (optionModels) { // First positional argument: success callback
        final List<OptionEntity> entities = optionModels
            .map((model) => OptionMapper.fromModel(model))
            .toList();
        return Success(entities);
      },
          (error) { // Second positional argument: failure callback
        return Failure(error);
      },
    );
  }

}