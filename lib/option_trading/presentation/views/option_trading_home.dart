import 'package:flutter/material.dart';
import 'option_chain_table.dart';

class OptionTradingHome extends StatefulWidget {
  const OptionTradingHome({Key? key}) : super(key: key);

  @override
  State<OptionTradingHome> createState() => _OptionTradingHomeState();
}

class _OptionTradingHomeState extends State<OptionTradingHome> {
  int _currentIndex = 1;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const Center(child: Text('Markets Screen', style: TextStyle(color: Colors.grey, fontSize: 24))),
      const OptionChainTable(),
      const Center(child: Text('Portfolio Screen', style: TextStyle(color: Colors.grey, fontSize: 24))),
      const Center(child: Text('Orders Screen', style: TextStyle(color: Colors.grey, fontSize: 24))),
      const Center(child: Text('Products Screen', style: TextStyle(color: Colors.grey, fontSize: 24))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Option Trading'),
          backgroundColor: Colors.white
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blueAccent,
          selectedIconTheme: const IconThemeData(color: Colors.blueAccent),
          selectedLabelStyle: const TextStyle(
            color: Colors.blueAccent,
          ),
          unselectedIconTheme: const IconThemeData(color: Colors.grey),
          unselectedLabelStyle: const TextStyle(
            color: Colors.grey,
          ),
          elevation: 10,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              label: 'Markets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_vert),
              label: 'Option chain',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business_center),
              label: 'Portfolio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books_rounded),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Products',
            ),
          ],
        ),
      ),
    );
  }
}