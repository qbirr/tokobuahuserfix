import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'package:provider/provider.dart';


import '../../providers/oders_provider.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import 'order_widgets.dart';


class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    // Size size = Utils(context).getScreenSize;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final ordersList = ordersProvider.getOrders;
    return FutureBuilder(
        future: ordersProvider.fetchOrders(),
        builder: (context, snapshot) {
          return ordersList.isEmpty
              ? const EmptyScreen(
            title: 'Pesanan Kamu Kosong',
            subtitle: 'Mari Beli Produk Kami :)',
            buttonText: 'Belanja Sekarang',
            imagePath: 'assets/images/cart.png',
          )
              : Scaffold(
              appBar: AppBar(
                leading: const BackWidget(),
                elevation: 0,
                centerTitle: false,
                title: TextWidget(
                  text: 'Your orders (${ordersList.length})',
                  color: color,
                  textSize: 24.0,
                  isTile: true,
                ),
                backgroundColor: Theme.of(context)
                    .scaffoldBackgroundColor
                    .withOpacity(0.9),
              ),
              body: ListView.separated(
                itemCount: ordersList.length,
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 2, vertical: 6),
                    child: ChangeNotifierProvider.value(
                      value: ordersList[index],
                      child: const OrderWidget(),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: color,
                    thickness: 1,
                  );
                },
              ));
        });
  }
}
