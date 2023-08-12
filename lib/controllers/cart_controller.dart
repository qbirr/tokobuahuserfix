import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tokobuah/model/cart_item.dart';
import 'package:tokobuah/services/global_method.dart';

class CartController extends GetxController {
  RxList<CartItem> cartItems = <CartItem>[].obs;
  RxDouble totalAmount = 0.0.obs;
  RxInt totalItems = 0.obs;
  RxInt discount = 0.obs;
  RxDouble grandTotal = 0.0.obs;
  final _userCollection = FirebaseFirestore.instance.collection('users');
  final _couponsCollection = FirebaseFirestore.instance.collection('coupons');
  final _authInstance = FirebaseAuth.instance;

  bool isLogedIn() {
    return FirebaseAuth.instance.currentUser?.uid == null ? false : true;
  }

  void addProductToCart(
      {required String productId,
      required double price,
      required int quantity,
      required BuildContext context}) async {
    EasyLoading.show(
        status: 'Loading ...',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
    if (isLogedIn()) {
      try {
        await _userCollection
            .doc(_authInstance.currentUser!.uid)
            .collection('cart')
            .add({
          'productId': productId,
          'price': price,
          'quantity': quantity,
        });
        cartItems.add(
          CartItem.fromMap(
            {
              'productId': productId,
              'price': price,
              'quantity': quantity,
            },
          ),
        );
        await fetchCart();
        EasyLoading.dismiss();
        await Fluttertoast.showToast(
          msg: "Item has been added to your cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } catch (e) {
        EasyLoading.dismiss();
        print(e);
        GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
      }
    } else {
      EasyLoading.dismiss();

      GlobalMethods.errorDialog(
          subtitle: 'No user found, Please login first', context: context);
    }
  }

  Future<void> fetchCart() async {
    if (isLogedIn()) {
      await _userCollection
          .doc(_authInstance.currentUser!.uid)
          .collection('cart')
          .get()
          .then((cartData) async {
        cartItems.clear();
        totalAmount.value = 0.0;
        totalItems.value = 0;
        discount.value = 0;
        grandTotal.value = 0.0;
        for (var element in cartData.docs) {
          Map<String, dynamic> map = element.data();
          cartItems.add(CartItem.fromMap(map));
          totalAmount.value += map['price'] * map['quantity'];
          totalItems.value += 1;
        }
      }).then((_) async {
        await _couponsCollection
            .where('active', isEqualTo: true)
            .orderBy('minimum')
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            for (var element in value.docs) {
              if (totalAmount.value >= element.data()['minimum']) {
                discount.value = element.data()['value'];
                //grandTotal is percentage from discount
                grandTotal.value = totalAmount.value -
                    (totalAmount.value * discount.value) / 100;
              }
            }
            print(discount);
            print(grandTotal);
          }
        });
        update();
      });
    }
  }

  Future<void> setQuantity(String productId, int qty) async {
    if (isLogedIn()) {
      try {
        await _userCollection
            .doc(_authInstance.currentUser!.uid)
            .collection('cart')
            .where('productId', isEqualTo: productId)
            .get()
            .then((value) async {
          await _userCollection
              .doc(_authInstance.currentUser!.uid)
              .collection('cart')
              .doc(value.docs.first.id)
              .update({
            'quantity': qty,
          });
          await fetchCart();
        });
      } catch (e) {
        print(e);
      }
    } else {}
  }

  Future<void> decreaseQuantity(String productId) async {
    EasyLoading.show(
        status: 'Loading ...',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
    if (isLogedIn()) {
      try {
        final cartItem =
            cartItems.firstWhere((element) => element.productId == productId);
        if (cartItem.quantity > 1) {
          await _userCollection
              .doc(_authInstance.currentUser!.uid)
              .collection('cart')
              .where('productId', isEqualTo: productId)
              .get()
              .then((value) async {
            await _userCollection
                .doc(_authInstance.currentUser!.uid)
                .collection('cart')
                .doc(value.docs.first.id)
                .update({
              'quantity': cartItem.quantity - 1,
            });
            await fetchCart();
            EasyLoading.dismiss();
          });
        } else {
          await _userCollection
              .doc(_authInstance.currentUser!.uid)
              .collection('cart')
              .where('productId', isEqualTo: productId)
              .get()
              .then((value) async {
            await _userCollection
                .doc(_authInstance.currentUser!.uid)
                .collection('cart')
                .doc(value.docs.first.id)
                .delete();
            await fetchCart();
            EasyLoading.dismiss();
          });
        }
      } catch (e) {
        EasyLoading.dismiss();
        print(e);
      }
    } else {
      EasyLoading.dismiss();
    }
  }

  Future<void> increaseQuantity(String productId) async {
    EasyLoading.show(
        status: 'Loading ...',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
    if (isLogedIn()) {
      try {
        final cartItem =
            cartItems.firstWhere((element) => element.productId == productId);
        await _userCollection
            .doc(_authInstance.currentUser!.uid)
            .collection('cart')
            .where('productId', isEqualTo: productId)
            .get()
            .then((value) async {
          await _userCollection
              .doc(_authInstance.currentUser!.uid)
              .collection('cart')
              .doc(value.docs.first.id)
              .update({
            'quantity': cartItem.quantity + 1,
          });
          await fetchCart();
          EasyLoading.dismiss();
        });
      } catch (e) {
        EasyLoading.dismiss();
        print(e);
      }
    } else {
      EasyLoading.dismiss();
    }
  }

  Future<void> removeOneItem(String productId) async {
    EasyLoading.show(
        status: 'Loading ...',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
    if (isLogedIn()) {
      try {
        await _userCollection
            .doc(_authInstance.currentUser!.uid)
            .collection('cart')
            .where('productId', isEqualTo: productId)
            .get()
            .then((value) async {
          await _userCollection
              .doc(_authInstance.currentUser!.uid)
              .collection('cart')
              .doc(value.docs.first.id)
              .delete();
          await fetchCart();
          EasyLoading.dismiss();
        });
      } catch (e) {
        EasyLoading.dismiss();
        print(e);
      }
    } else {
      EasyLoading.dismiss();
    }
  }

  Future<void> clearOnlineCart() async {
    if (isLogedIn()) {
      EasyLoading.show(
          status: 'Loading ...',
          maskType: EasyLoadingMaskType.black,
          dismissOnTap: false);
      try {
        await _userCollection
            .doc(_authInstance.currentUser!.uid)
            .collection('cart')
            .get()
            .then((value) async {
          for (var element in value.docs) {
            await _userCollection
                .doc(_authInstance.currentUser!.uid)
                .collection('cart')
                .doc(element.id)
                .delete();
          }
        }).then((value) async {
          clearCart();
          await fetchCart();
        });
        EasyLoading.dismiss();
      } catch (e) {
        EasyLoading.dismiss();
        print(e);
      }
    }
  }

  void clearCart() {
    cartItems.clear();
    totalAmount = 0.0.obs;
    totalItems = 0.obs;
    discount.value = 0;
    grandTotal.value = 0.0;
    update();
  }
}
