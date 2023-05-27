import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/consts/firebase_auth.dart';
import 'package:tokobuah/providers/wishlist_provider.dart';
import 'package:tokobuah/services/global_method.dart';

import '../providers/product_providers.dart';
import '../services/utils.dart';


class HeartButton extends StatelessWidget {
  const HeartButton({Key? key, required this.productId, this.isInWishlist = false})
      : super(key: key);
  final String productId;
  final bool? isInWishlist;
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productProvider.findProdById(productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final Color color = Utils(context).color;
    return GestureDetector(
      onTap: () async {
      try {
        final User? user = authInstance.currentUser;

        if (user == null) {
          GlobalMethods.errorDialog(
              subtitle: 'No user found, Please login first',
              context: context);
          return;
        }
        if (isInWishlist == false && isInWishlist != null) {
          await GlobalMethods.addToWishlist(
              productId: productId, context: context);
        } else {
          await wishlistProvider.removeOneItem(
              wishlistId:
              wishlistProvider.getWishlistItems[getCurrProduct.id]!.id,
              productId: productId);
        }
        await wishlistProvider.fetchWishlist();
      } catch (error) {
      } finally {}
      ///print('user id is ${user.uid}');
      ///wishlistProvider.addRemoveProductToWishlist(productId: productId);
    },
      child: Icon(
        isInWishlist != null && isInWishlist == true
            ? IconlyBold.heart
            : IconlyLight.heart,
        size: 22,
        color:
        isInWishlist != null && isInWishlist == true ? Colors.red : color,
      ),
    );
  }
}

