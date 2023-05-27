import 'package:flutter/cupertino.dart';

class TextWidget extends StatelessWidget {
  TextWidget({Key? key,
  required this.text,
  required this.color,
  required this.textSize,
  this.isTile = false,
  this.maxLines = 10}) : super(key: key);
  final String text;
  final Color color;
  final double textSize;
  bool isTile;
  int maxLines = 10;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: TextStyle(
        overflow: TextOverflow.ellipsis,
        color: color,
        fontSize: textSize,
        fontWeight: isTile ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
