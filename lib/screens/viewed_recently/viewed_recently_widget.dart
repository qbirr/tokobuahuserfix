import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/controllers/cart_controller.dart';
import 'package:tokobuah/services/utils.dart';
import 'package:tokobuah/widgets/text_widget.dart';

import '../../model/viewed_model.dart';
import '../../providers/product_providers.dart';

class ViewedRecentlyWidget extends StatefulWidget {
  const ViewedRecentlyWidget({Key? key}) : super(key: key);

  @override
  State<ViewedRecentlyWidget> createState() => _ViewedRecentlyWidgetState();
}

class _ViewedRecentlyWidgetState extends State<ViewedRecentlyWidget> {
  @override
  Widget build(BuildContext context) {
    print('object');
    final productProvider = Provider.of<ProductsProvider>(context);

    final viewedProdModel = Provider.of<ViewedProdModel>(context);

    final getCurrProduct =
        productProvider.findProdById(viewedProdModel.productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    bool? isInCart = Get.find<CartController>()
        .cartItems
        .toString()
        .contains(getCurrProduct.id);
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
            CachedNetworkImage(
              imageUrl: getCurrProduct.imageUrl,
              imageBuilder: (context, imageProvider) {
                return Container(
                  width: size.width * 0.2,
                  height: size.width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                );
              },
              placeholder: (context, url) => Container(
                width: size.width * 0.2,
                height: size.width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/placeholder.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
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
                  text: NumberFormat.currency(
                    locale: 'id-ID',
                    name: 'Rp ',
                    decimalDigits: 0,
                  ).format(usedPrice),
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
                    onTap: isInCart
                        ? null
                        : () {
                            Get.find<CartController>().addProductToCart(
                                productId: getCurrProduct.id,
                                price: getCurrProduct.isOnSale
                                    ? getCurrProduct.salePrice
                                    : getCurrProduct.price,
                                quantity: 1,
                                context: context);
                            // final User? user = authInstance.currentUser;
                            // if (user == null) {
                            //   GlobalMethods.errorDialog(
                            //       subtitle: "No User Found, Please Login First",
                            //       context: context);
                            //   return;
                            // }
                            // GlobalMethods.addToCart(
                            //     productId: getCurrProduct.id,
                            //     quantity: 1,
                            //     context: context);
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        isInCart ? Icons.check : IconlyBold.plus,
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
