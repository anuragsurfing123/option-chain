// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/utils/service_locator.dart';
import 'option_trading/presentation/viewmodels/option_chain_viewmodel.dart';
import 'option_trading/presentation/views/option_trading_home.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Option Chain',
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<OptionChainViewModel>(
            create: (context) => sl<OptionChainViewModel>(),
          ),
        ],
        child: const OptionTradingHome(),
      ),
    );
  }
}