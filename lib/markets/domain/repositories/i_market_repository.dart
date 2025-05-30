import '../../../option_trading/data/models/option_data_model.dart';

abstract class MarketRepository {
  Stream<List<OptionDataModel>> getMarketData();
  void dispose();
}