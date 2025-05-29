class OptionEntity {
  // strike
  final String strikePrice;
  // calls
  final String bidQtyCall;
  final String bidPriceCall;
  final String askPriceCall;
  final String askQtyCall;
  final String ltpCall;
  final String changeCall;
  final String volumeCall;
  final String oiCall;
  final String ivCall;

  // puts
  final String bidQtyPut;
  final String bidPricePut;
  final String askPricePut;
  final String askQtyPut;
  final String ltpPut;
  final String changePut;
  final String volumePut;
  final String oiPut;
  final String ivPut;

  OptionEntity({
    required this.strikePrice,
    required this.bidQtyCall,
    required this.bidPriceCall,
    required this.askPriceCall,
    required this.askQtyCall,
    required this.ltpCall,
    required this.changeCall,
    required this.volumeCall,
    required this.oiCall,
    required this.ivCall,
    required this.bidQtyPut,
    required this.bidPricePut,
    required this.askPricePut,
    required this.askQtyPut,
    required this.ltpPut,
    required this.changePut,
    required this.volumePut,
    required this.oiPut,
    required this.ivPut,
  });
}