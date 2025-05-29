

import 'package:fyers_option_trading/option_trading/domain/entities/option_entity.dart';

import '../../../core/errors/app_error.dart';
import '../../../core/utils/result.dart';
import '../repositories/i_option_repository.dart';

class GetOptionChainUseCase {
  final OptionChainRepository _repository;

  GetOptionChainUseCase(this._repository);

  Future<Result<List<OptionEntity>, AppError>> call(String symbol) async {
    return await _repository.getOptionChain(symbol);
  }
}