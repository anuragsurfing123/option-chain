import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../option_trading/data/models/option_data_model.dart';
import '../../../core/api/api_constants.dart';

abstract class MarketDataSource {
  Stream<List<OptionDataModel>> fetchMarketData();
  void dispose();
}

class MarketWebSocketDataSourceImpl implements MarketDataSource {
  final String _wsUrl = '${ApiConstants.webSocketBaseUrl}${ApiConstants.marketDataSocketEndpoint}';
  WebSocketChannel? _channel;

  @override
  Stream<List<OptionDataModel>> fetchMarketData() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));
      debugPrint('Attempting to connect to WebSocket: $_wsUrl');

      return _channel!.stream.map((message) {
        if (message is String) {
          try {
            final List<dynamic> jsonList = json.decode(message);
            return jsonList.map((json) => OptionDataModel.fromJson(json)).toList();
          } catch (e) {
            debugPrint('Error decoding WebSocket message for Markets: $e');
            throw FormatException('Invalid data format from WebSocket: $message, Error: $e');
          }
        }
        throw Exception('Unexpected message type from WebSocket: ${message.runtimeType}');
      }).handleError((error) {
        debugPrint('WebSocket Stream Error for Markets: $error');
        throw error;
      });
    } catch (e) {
      debugPrint('WebSocket connection error for Markets: $e');
      return Stream.error('Failed to connect to WebSocket: $e');
    }
  }

  @override
  void dispose() {
    _channel?.sink.close();
    debugPrint('WebSocket channel for Markets disposed.');
  }
}