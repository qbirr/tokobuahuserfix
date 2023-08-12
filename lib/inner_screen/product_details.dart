import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/controllers/cart_controller.dart';
import 'package:tokobuah/providers/product_providers.dart';
import 'package:tokobuah/providers/viewed_providers.dart';
import 'package:tokobuah/services/utils.dart';
import 'package:tokobuah/widgets/heart_btn.dart';
import 'package:tokobuah/widgets/text_widget.dart';

import '../providers/wishlist_provider.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';
  const ProductDetails({Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _quantityTextController = TextEditingController(text: '1');

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).screenSize;
    final Color color = Utils(context).color;
    final productProvider = Provider.of<ProductsProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrentProduct = productProvider.findProdById(productId);
    double usedPriced = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    double totalPrice = usedPriced * int.parse(_quantityTextController.text);
    bool? isInWishlist = Get.find<CartController>()
        .cartItems
        .toString()
        .contains(getCurrentProduct.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        ///viewedProdProvider.addProductToHistory(productId: productId);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () =>
                Navigator.canPop(context) ? Navigator.pop(context) : null,
            child: Icon(
              IconlyLight.arrowLeft2,
              color: color,
              size: 24,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: CachedNetworkImage(
                imageUrl: getCurrentProduct.imageUrl,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  );
                },
                placeholder: (context, url) => Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/placeholder.png'),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: TextWidget(
                              text: getCurrentProduct.title,
                              color: color,
                              textSize: 25,
                              isTile: true,
                            )),
                            HeartButton(
                                productId: getCurrentProduct.id,
                                isInWishlist: isInWishlist)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 30,
                          right: 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextWidget(
                              text: NumberFormat.currency(
                                locale: 'id-ID',
                                name: '',
                                decimalDigits: 0,
                              ).format(usedPriced),
                              color: Colors.green,
                              textSize: 22,
                              isTile: true,
                            ),
                            TextWidget(
                                text:
                                    getCurrentProduct.isPiece ? "Piece" : "/kg",
                                color: color,
                                textSize: 12,
                                isTile: true),
                            Visibility(
                                visible:
                                    getCurrentProduct.isOnSale ? true : false,
                                child: Text(
                                  NumberFormat.currency(
                                    locale: 'id-ID',
                                    name: '',
                                    decimalDigits: 0,
                                  ).format(getCurrentProduct.price),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: color,
                                      decoration: TextDecoration.lineThrough),
                                )),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(63, 200, 101, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextWidget(
                                text: "Gratis Ongkir",
                                color: Colors.white,
                                textSize: 20,
                                isTile: true,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _quantityController(
                              fct: () {
                                setState(() {
                                  if (_quantityTextController.text == '1') {
                                    return;
                                  } else {
                                    _quantityTextController.text = (int.parse(
                                                _quantityTextController.text) -
                                            1)
                                        .toString();
                                  }
                                });
                              },
                              icon: CupertinoIcons.minus,
                              color: Colors.red),
                          Flexible(
                              flex: 1,
                              child: TextField(
                                controller: _quantityTextController,
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder()),
                                textAlign: TextAlign.center,
                                cursorColor: Colors.green,
                                enabled: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]'))
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    if (value.isEmpty) {
                                      _quantityTextController.text = '1';
                                    } else {}
                                  });
                                },
                              )),
                          _quantityController(
                              fct: () {
                                setState(() {
                                  _quantityTextController.text =
                                      (int.parse(_quantityTextController.text) +
                                              1)
                                          .toString();
                                });
                              },
                              icon: CupertinoIcons.plus,
                              color: Colors.green)
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 30),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: "Total",
                                  color: Colors.red.shade300,
                                  textSize: 20,
                                  isTile: true,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                FittedBox(
                                  child: Row(
                                    children: [
                                      TextWidget(
                                        text: "${NumberFormat.currency(
                                          locale: 'id-ID',
                                          name: '',
                                          decimalDigits: 0,
                                        ).format(totalPrice)} /",
                                        color: color,
                                        textSize: 20,
                                        isTile: true,
                                      ),
                                      TextWidget(
                                        text:
                                            "${_quantityTextController.text}kg",
                                        color: color,
                                        textSize: 20,
                                        isTile: true,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                                child: Material(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                              child: GetBuilder<CartController>(
                                  builder: (controller) {
                                bool? isInCart = Get.find<CartController>()
                                    .cartItems
                                    .toString()
                                    .contains(getCurrentProduct.id);
                                return InkWell(
                                  onTap: isInCart
                                      ? null
                                      : () async {
                                          Get.find<CartController>()
                                              .addProductToCart(
                                                  productId:
                                                      getCurrentProduct.id,
                                                  price:
                                                      getCurrentProduct.isOnSale
                                                          ? getCurrentProduct
                                                              .salePrice
                                                          : getCurrentProduct
                                                              .price,
                                                  quantity: int.parse(
                                                      _quantityTextController
                                                          .text),
                                                  context: context);
                                        },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(11.0),
                                    child: TextWidget(
                                      text: isInCart
                                          ? "Dikeranjang"
                                          : "Masukkan Keranjang",
                                      color: Colors.white,
                                      textSize: 18,
                                    ),
                                  ),
                                );
                              }),
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _quantityController(
      {required Function fct, required IconData icon, required Color color}) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
