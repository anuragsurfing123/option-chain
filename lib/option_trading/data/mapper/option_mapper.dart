import '../../domain/entities/option_entity.dart';
import '../models/option_data_model.dart';

class OptionMapper {
  static OptionEntity fromModel(OptionDataModel model) {
    return OptionEntity(
      strikePrice: model.strikePrice,
      bidQtyCall: model.bidQtyCall,
      bidPriceCall: model.bidPriceCall,
      askPriceCall: model.askPriceCall,
      askQtyCall: model.askQtyCall,
      ltpCall: model.ltpCall,
      changeCall: model.changeCall,
      volumeCall: model.volumeCall,
      oiCall: model.oiCall,
      ivCall: model.ivCall,
      bidQtyPut: model.bidQtyPut,
      bidPricePut: model.bidPricePut,
      askPricePut: model.askPricePut,
      askQtyPut: model.askQtyPut,
      ltpPut: model.ltpPut,
      changePut: model.changePut,
      volumePut: model.volumePut,
      oiPut: model.oiPut,
      ivPut: model.ivPut,
    );
  }
}