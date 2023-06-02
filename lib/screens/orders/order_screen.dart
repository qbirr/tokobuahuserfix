import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tokobuah/consts/firebase_auth.dart';
import 'package:tokobuah/inner_screen/product_details.dart';
import 'package:tokobuah/model/order_model.dart';
import 'package:tokobuah/providers/product_providers.dart';
import 'package:tokobuah/services/global_method.dart';

import '../../providers/oders_provider.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';

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
    final User? user = authInstance.currentUser;
    Size size = Utils(context).screenSize;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final ordersList = ordersProvider.getOrders;
    final productProvider = Provider.of<ProductsProvider>(context);

    if (user?.uid != null) {
      // print(user?.uid);
      return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user!.uid)
            .orderBy('orderDate', descending: false)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.data!.docs.isNotEmpty) {
            return Scaffold(
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
                backgroundColor:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
              ),
              body: ListView.separated(
                itemCount: ordersList.length,
                itemBuilder: (ctx, index) {
                  Map<String, dynamic> data = snapshot.data!.docs[index].data();
                  OrderModel orderData = OrderModel(
                      orderId: data['orderId'],
                      userId: data['userId'],
                      productId: data['productId'],
                      userName: data['userName'],
                      price: data['price'].toString(),
                      imageUrl: data['imageUrl'],
                      quantity: data['quantity'].toString(),
                      orderDate: data['orderDate']);
                  var orderDate = orderData.orderDate.toDate();
                  String orderDateToShow =
                      '${orderDate.day}/${orderDate.month}/${orderDate.year}';
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                    child: ListTile(
                      subtitle: Text(
                          'Paid: Rp${double.parse(orderData.price).toStringAsFixed(0)}'),
                      onTap: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: ProductDetails.routeName);
                      },
                      leading: FancyShimmerImage(
                        width: size.width * 0.2,
                        imageUrl: orderData.imageUrl,
                        boxFit: BoxFit.fill,
                      ),
                      title: TextWidget(
                          text:
                              '${productProvider.findProdById(orderData.productId).title}  x${orderData.quantity}',
                          color: color,
                          textSize: 18),
                      trailing: TextWidget(
                          text: orderDateToShow, color: color, textSize: 18),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: color,
                    thickness: 1,
                  );
                },
              ),
            );
          } else {
            return const EmptyScreen(
              title: 'Pesanan Kamu Kosong',
              subtitle: 'Mari Beli Produk Kami :)',
              buttonText: 'Belanja Sekarang',
              imagePath: 'assets/images/cart.png',
            );
          }
        },
      );
    } else {
      return const EmptyScreen(
        title: 'Pesanan Kamu Kosong',
        subtitle: 'Mari Beli Produk Kami :)',
        buttonText: 'Belanja Sekarang',
        imagePath: 'assets/images/cart.png',
      );
    }
  }
}
