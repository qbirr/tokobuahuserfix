import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/inner_screen/product_details.dart';
import 'package:tokobuah/model/cart_model.dart';
import 'package:tokobuah/model/model_product.dart';
import 'package:tokobuah/providers/cart_providers.dart';
import 'package:tokobuah/providers/wishlist_provider.dart';
import 'package:tokobuah/services/global_method.dart';
import 'package:tokobuah/services/utils.dart';
import 'package:tokobuah/widgets/heart_btn.dart';
import 'package:tokobuah/widgets/price_widget.dart';
import 'package:tokobuah/widgets/text_widget.dart';

import '../consts/firebase_auth.dart';
import '../providers/product_providers.dart';
import '../providers/viewed_providers.dart';

class FeedsWidgets extends StatefulWidget {
  const FeedsWidgets({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedsWidgets> createState() => _FeedsWidgetsState();
}

class _FeedsWidgetsState extends State<FeedsWidgets> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = "1";
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).screenSize;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(22),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            viewedProdProvider.addProductToHistory(productId: productModel.id);
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
            // GlobalMethods.navigateTo(
            //     ctx: context,
            //     routeName: ProductDetails.routeName);
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              Image.network(
                productModel.imageUrl,
                height: size.width * 0.21,
                width: size.width * 0.2,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        flex: 3,
                        child: TextWidget(
                          text: productModel.title,
                          color: color,
                          maxLines: 1,
                          textSize: 18,
                          isTile: true,
                        )),
                    Flexible(
                        flex: 1,
                        child: HeartButton(
                            productId: productModel.id,
                            isInWishlist: _isInWishlist))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: PriceWidget(
                        textPrice: _quantityTextController.text,
                        salePrice: productModel.salePrice,
                        price: productModel.price,
                        isOnSale: productModel.isOnSale,
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 6,
                            child: FittedBox(
                                child: TextWidget(
                              text: productModel.isPiece ? 'Piece' : 'kg',
                              color: color,
                              textSize: 20,
                              isTile: true,
                            )),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                              flex: 2,
                              child: TextFormField(
                                controller: _quantityTextController,
                                key: const ValueKey('10'),
                                style: TextStyle(color: color, fontSize: 18),
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                enabled: true,
                                onChanged: (valueee) {
                                  setState(() {});
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp('[0-9.]'),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _isInCart
                      ? null
                      : () async {
                          /// if (_isInCart) {
                          ///   return;
                          /// }
                          final User? user = authInstance.currentUser;

                          if (user == null) {
                            GlobalMethods.errorDialog(
                                subtitle: 'No user found, Please login first',
                                context: context);
                            return;
                          }
                          await GlobalMethods.addToCart(
                              productId: productModel.id,
                              quantity: int.parse(_quantityTextController.text),
                              context: context);
                          await cartProvider.fetchCart();
                          /// cartProvider.addProductsToCart(
                          ///     productId: productModel.id,
                          ///    quantity: int.parse(_quantityTextController.text));
                        },
                  child: TextWidget(
                    text: _isInCart ? 'in cart' : "Masukkan Keranjang",
                    maxLines: 1,
                    color: color,
                    textSize: 17,
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).cardColor),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12.0),
                                  bottomRight: Radius.circular(12.0))))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
