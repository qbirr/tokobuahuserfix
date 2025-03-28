import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tokobuah/widgets/text_widget.dart';

import '../services/utils.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget(
      {Key? key,
      required this.salePrice,
      required this.price,
      required this.textPrice,
      required this.isOnSale})
      : super(key: key);
  final double salePrice, price;
  final String textPrice;
  final bool isOnSale;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    double userPrice = isOnSale ? salePrice : price;
    return FittedBox(
        child: Row(children: [
      TextWidget(
          text: NumberFormat.currency(
            locale: 'id-ID',
            name: '',
            decimalDigits: 0,
          ).format((userPrice * int.parse(textPrice))),
          color: Colors.green,
          textSize: 18),
      const SizedBox(
        width: 5,
      ),
      Visibility(
        visible: isOnSale ? true : false,
        child: Text(
          NumberFormat.currency(
            locale: 'id-ID',
            name: '',
            decimalDigits: 0,
          ).format((price * int.parse(textPrice))),
          style: TextStyle(
              fontSize: 15,
              color: color,
              decoration: TextDecoration.lineThrough),
        ),
      )
    ]));
  }
}
