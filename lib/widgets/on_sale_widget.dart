import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/controllers/cart_controller.dart';
import 'package:tokobuah/providers/wishlist_provider.dart';
import 'package:tokobuah/services/utils.dart';
import 'package:tokobuah/widgets/heart_btn.dart';
import 'package:tokobuah/widgets/price_widget.dart';
import 'package:tokobuah/widgets/text_widget.dart';

import '../inner_screen/product_details.dart';
import '../model/model_product.dart';
import '../providers/viewed_providers.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);
    final Color color = Utils(context).color;
    final theme = Utils(context).getTheme;
    Size size = Utils(context).screenSize;
    bool? isInCart = Get.find<CartController>()
        .cartItems
        .toString()
        .contains(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            viewedProdProvider.addProductToHistory(productId: productModel.id);
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: productModel.imageUrl,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          height: size.width * 0.19,
                          width: size.width * 0.19,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      placeholder: (context, url) => Container(
                        height: size.width * 0.19,
                        width: size.width * 0.19,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/placeholder.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        TextWidget(
                          text: productModel.isPiece ? "1piece" : "1kg",
                          color: color,
                          textSize: 12,
                          isTile: true,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(children: [
                          GestureDetector(
                            onTap: isInCart
                                ? null
                                : () async {
                                    Get.find<CartController>().addProductToCart(
                                        productId: productModel.id,
                                        price: productModel.isOnSale
                                            ? productModel.salePrice
                                            : productModel.price,
                                        quantity: 1,
                                        context: context);
                                    // final User? user = authInstance.currentUser;

                                    // if (user == null) {
                                    //   GlobalMethods.errorDialog(
                                    //       subtitle:
                                    //           'No user found, Please login first',
                                    //       context: context);
                                    //   return;
                                    // }
                                    // await GlobalMethods.addToCart(
                                    //     productId: productModel.id,
                                    //     quantity: 1,
                                    //     context: context);
                                    // await cartProvider.fetchCart();
                                  },
                            child: Icon(
                              isInCart ? IconlyBold.bag2 : IconlyLight.bag2,
                              size: 17,
                              color: isInCart ? Colors.green : color,
                            ),
                          ),
                          HeartButton(
                              productId: productModel.id,
                              isInWishlist: isInWishlist)
                        ]),
                      ],
                    )
                  ],
                ),
                PriceWidget(
                  textPrice: '1',
                  salePrice: productModel.salePrice,
                  price: productModel.price,
                  isOnSale: true,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextWidget(text: productModel.title, color: color, textSize: 16)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
