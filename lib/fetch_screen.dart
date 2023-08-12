import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/consts/firebase_auth.dart';
import 'package:tokobuah/controllers/cart_controller.dart';
import 'package:tokobuah/providers/product_providers.dart';
import 'package:tokobuah/providers/wishlist_provider.dart';
import 'package:tokobuah/screens/btm_bar.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 5), () async {
      final productsProvider =
          Provider.of<ProductsProvider>(context, listen: false);
      final wishlistProvider =
          Provider.of<WishlistProvider>(context, listen: false);
      final User? user = authInstance.currentUser;
      if (user == null) {
        Get.find<CartController>().clearCart();
        await productsProvider.fetchProducts().then((value) {
          wishlistProvider.clearWishlist();
          Get.offAll(() => const BottomBarScreen());
        });
      } else {
        Get.find<CartController>().clearCart();
        await productsProvider.fetchProducts().then((_) async {
          await Get.find<CartController>().fetchCart().then((_) async {
            await wishlistProvider.fetchWishlist().then((_) {
              Get.offAll(() => const BottomBarScreen());
            });
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/landing/buyfood.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
