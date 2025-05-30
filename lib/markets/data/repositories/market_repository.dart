import '../../../../option_trading/data/models/option_data_model.dart';
import '../../domain/repositories/i_market_repository.dart';
import '../datasources/market_data_source.dart';


class MarketRepositoryImpl implements MarketRepository {
  final MarketDataSource _dataSource;

  MarketRepositoryImpl(this._dataSource);

  @override
  Stream<List<OptionDataModel>> getMarketData() {
    return _dataSource.fetchMarketData();
  }

  @override
  void dispose() {
    _dataSource.dispose();
  }
}