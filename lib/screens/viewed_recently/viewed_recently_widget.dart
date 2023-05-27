import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/inner_screen/product_details.dart';
import 'package:tokobuah/providers/viewed_providers.dart';
import 'package:tokobuah/services/global_method.dart';
import 'package:tokobuah/services/utils.dart';
import 'package:tokobuah/widgets/text_widget.dart';

import '../../consts/firebase_auth.dart';
import '../../model/viewed_model.dart';
import '../../providers/cart_providers.dart';
import '../../providers/product_providers.dart';

class ViewedRecentlyWidget extends StatefulWidget {
  const ViewedRecentlyWidget({Key? key}) : super(key: key);

  @override
  State<ViewedRecentlyWidget> createState() => _ViewedRecentlyWidgetState();
}

class _ViewedRecentlyWidgetState extends State<ViewedRecentlyWidget> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);

    final viewedProdModel = Provider.of<ViewedProdModel>(context);

    final getCurrProduct =
    productProvider.findProdById(viewedProdModel.productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(getCurrProduct.id);
    Color color = Utils(context).color;
    Size size = Utils(context).screenSize;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          ///GlobalMethods.navigateTo(
          ///ctx: context, routeName: ProductDetails.routeName);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              getCurrProduct.imageUrl,
              fit: BoxFit.fill,
              width: size.width * 0.2,
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              children: [
                TextWidget(
                  text: getCurrProduct.title,
                  color: color,
                  textSize: 24,
                  isTile: true,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextWidget(
                  text: '${usedPrice.toStringAsFixed(0)}',
                  color: color,
                  textSize: 20,
                  isTile: false,
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Material(
                borderRadius: BorderRadius.circular(12),
                color: Colors.green,
                child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap:  _isInCart
                        ? null
                        :(){
                      final User? user = authInstance.currentUser;
                      if(user == null){
                        GlobalMethods.errorDialog(subtitle: "No User Found, Please Login First", context: context);
                        return;
                      }
                      GlobalMethods.addToCart(productId: getCurrProduct.id, quantity: 1, context: context);
                      ///cartProvider.addProductToCart(
                       /// productId: getCurrProduct.id,
                        ///quantity: 1,
                      ///);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        _isInCart ? Icons.check : IconlyBold.plus,
                        color: Colors.white,
                        size: 20,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
