import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:tokobuah/consts/firebase_auth.dart';
import '../model/order_model.dart';

class OrdersProvider with ChangeNotifier {
  static final List<OrderModel> _orders = [];
  final User? user = authInstance.currentUser;
  List<OrderModel> get getOrders {
    return _orders;
  }

  Future<void> fetchOrders() async {
    if (user?.uid != null) {
      await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: user!.uid)
          .orderBy('orderDate', descending: false)
          .get()
          .then((QuerySnapshot ordersSnapshot) {
        _orders.clear();
        for (var element in ordersSnapshot.docs) {
          _orders.insert(
            0,
            OrderModel(
              orderId: element.get('orderId'),
              userId: element.get('userId'),
              productId: element.get('productId'),
              userName: element.get('userName').toString(),
              price: element.get('price').toString(),
              imageUrl: element.get('imageUrl'),
              quantity: element.get('quantity').toString(),
              orderDate: element.get('orderDate'),
            ),
          );
        }
      });
    } else {
      _orders.clear();
    }
    notifyListeners();
  }
}
