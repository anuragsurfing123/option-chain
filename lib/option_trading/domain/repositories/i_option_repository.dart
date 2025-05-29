import '../../../core/errors/app_error.dart';
import '../../../core/utils/result.dart';
import '../entities/option_entity.dart';

abstract class OptionChainRepository {
  Future<Result<List<OptionEntity>, AppError>> getOptionChain(String symbol);
}