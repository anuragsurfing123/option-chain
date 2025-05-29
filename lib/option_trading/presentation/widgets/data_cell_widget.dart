import 'package:flutter/material.dart';

class DataCellWidget extends StatelessWidget {
  final String text;
  final double width;
  final bool isChange;

  const DataCellWidget({
    Key? key,
    required this.text,
    required this.width,
    this.isChange = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.black54;
    if (isChange) {
      if (text.startsWith('+')) {
        textColor = Colors.green;
      } else if (text.startsWith('-')) {
        textColor = Colors.red;
      }
    }
    return SizedBox(
      width: width,
      child: Center(
        child: Text(
          num.parse(text).toStringAsFixed(2),
          style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}