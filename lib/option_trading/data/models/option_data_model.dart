
class OptionDataModel {
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

  OptionDataModel({
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

  factory OptionDataModel.fromJson(Map<String, dynamic> json) {
    String getString(dynamic value, {String defaultValue = '0'}) {
      if (value == null) return defaultValue;
      if (value is String) return value.isNotEmpty ? value : defaultValue;
      return value.toString();
    }

    String formatChange(dynamic changeValue) {
      if (changeValue == null) return '+0.00';
      double change = 0.0;
      if (changeValue is String) {
        change = double.tryParse(changeValue) ?? 0.0;
      } else if (changeValue is num) {
        change = changeValue.toDouble();
      }
      return (change >= 0 ? '+' : '') + change.toStringAsFixed(2);
    }

    Map<String, dynamic> callData = json['CE'] as Map<String, dynamic>? ?? {};
    Map<String, dynamic> putData = json['PE'] as Map<String, dynamic>? ?? {};

    return OptionDataModel(
      strikePrice: getString(json['strikePrice']),

      bidQtyCall: getString(callData['bidQty']),
      bidPriceCall: getString(callData['bidprice'], defaultValue: '0.00'),
      askPriceCall: getString(callData['askPrice'], defaultValue: '0.00'),
      askQtyCall: getString(callData['askQty']),
      ltpCall: getString(callData['lastPrice'], defaultValue: '0.00'),
      changeCall: formatChange(callData['change']),
      volumeCall: getString(callData['totalTradedVolume']),
      oiCall: getString(callData['openInterest']),
      ivCall: getString(callData['impliedVolatility'], defaultValue: '0.0'),

      bidQtyPut: getString(putData['bidQty']),
      bidPricePut: getString(putData['bidprice'], defaultValue: '0.00'),
      askPricePut: getString(putData['askPrice'], defaultValue: '0.00'),
      askQtyPut: getString(putData['askQty']),
      ltpPut: getString(putData['lastPrice'], defaultValue: '0.00'),
      changePut: formatChange(putData['change']),
      volumePut: getString(putData['totalTradedVolume']),
      oiPut: getString(putData['openInterest']),
      ivPut: getString(putData['impliedVolatility'], defaultValue: '0.0'),
    );
  }

}