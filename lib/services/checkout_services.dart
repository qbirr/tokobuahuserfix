import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/consts/firebase_auth.dart';
import 'package:tokobuah/controllers/cart_controller.dart';
import 'package:tokobuah/fetch_screen.dart';
import 'package:tokobuah/model/cart_item.dart';
import 'package:tokobuah/providers/oders_provider.dart';
import 'package:tokobuah/providers/product_providers.dart';
import 'package:http/http.dart' as http;
import 'package:tokobuah/screens/payment/payment_screen.dart';
import 'package:tokobuah/services/global_method.dart';

class CheckoutService {
  User? user = authInstance.currentUser;

  Future<void> payOrder(
    // AddressModel address,
    double totalPayment,
    List<String> paymentMethod,
    String payment,
    RxList<CartItem> cart,
    String orderId,
    BuildContext context,
  ) async {
    EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    List<Map<String, dynamic>> dataProducts = [];
    dataProducts.clear();
    for (var cartItem in Get.find<CartController>().cartItems) {
      final product = ProductsProvider().findProdById(cartItem.productId);
      dataProducts.add({
        'name': product.title,
        'quantity': cartItem.quantity,
        'price': product.isOnSale ? product.salePrice : product.price
      });
    }
    try {
      var invoiceID = "inv-$orderId";
      var response = await http.post(
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic eG5kX2RldmVsb3BtZW50XzBhWXJKdkxxaDhXMGIyWlBiMmh4QzVQakdsWG9tN0xQTUQ5Vm1velhYYWpBTzBFb3JuZGtXMldvcHpOVVk6'
        },
        body: json.encode({
          "external_id": invoiceID,
          "amount": totalPayment,
          "success_redirect_url": 'https://www.youtube.com',
          "payment_methods": paymentMethod,
          "locale": "id",
          "currency": "IDR",
          "items": dataProducts,
        }),
        Uri.parse('https://api.xendit.co/v2/invoices'),
      );
      if (response.statusCode == 200) {
        print(response.body);
        var data = json.decode(response.body);
        var invoiceUrl = data['invoice_url'];
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaymentScreen(
              invoiceUrl: invoiceUrl,
              orderId: orderId,
              total: totalPayment,
              paymentMethod: payment),
        ));
        EasyLoading.dismiss();
        // Get.offAllNamed(Routes.PAYMENT, arguments: {
        //   "url": url,
        //   "metodePengiriman": metodePengiriman,
        //   "payment": payment,
        //   "address": address,
        // });
      } else {
        EasyLoading.dismiss();
        print(response.body);
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
    }
  }

  Future<void> onPaymentSuccess(
    String orderId,
    double total,
    BuildContext context,
    String paymentMethod,
  ) async {
    EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    Get.find<CartController>().cartItems.forEach(
      (cartItem) async {
        log('onPaymentSuccess dieksekusi');
        final getCurrProduct = productProvider.findProdById(
          cartItem.productId,
        );
        try {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(orderId)
              .set(
            {
              'orderId': orderId,
              'userId': user!.uid,
              'productId': cartItem.productId,
              'price': (getCurrProduct.isOnSale
                      ? getCurrProduct.salePrice
                      : getCurrProduct.price) *
                  cartItem.quantity,
              'totalPrice': total,
              'quantity': cartItem.quantity,
              'metodePembayaran': paymentMethod,
              'imageUrl': getCurrProduct.imageUrl,
              'userName': user!.displayName,
              'orderDate': Timestamp.now(),
            },
          ).then((_) async {
            Get.find<CartController>().clearOnlineCart();
            ordersProvider.fetchOrders();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const FetchScreen(),
                ),
                (route) => false);
            EasyLoading.dismiss();
          });
        } catch (error) {
          EasyLoading.dismiss();
          GlobalMethods.errorDialog(
              subtitle: error.toString(), context: context);
        }
      },
    );
  }
}
