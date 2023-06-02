import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/consts/firebase_auth.dart';
import 'package:tokobuah/inner_screen/product_details.dart';
import 'package:tokobuah/model/model_product.dart';
import 'package:tokobuah/providers/cart_providers.dart';
import 'package:tokobuah/providers/product_providers.dart';
import 'package:tokobuah/providers/viewed_providers.dart';
import 'package:tokobuah/providers/wishlist_provider.dart';
import 'package:tokobuah/services/global_method.dart';
import 'package:tokobuah/widgets/back_widget.dart';
import 'package:tokobuah/widgets/heart_btn.dart';
import 'package:tokobuah/widgets/price_widget.dart';

import '../services/utils.dart';
import '../widgets/text_widget.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);
  static const routeName = "/FeedsScreenState";

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  final _quantityTextController = TextEditingController();
  List<ProductModel> searchResults = [];
  bool _isSearching = false;
  @override
  void dispose() {
    _searchTextController.dispose();
    _searchTextFocusNode.dispose();
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _quantityTextController.text = "1";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).screenSize;
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProduct = productProviders.getProduct;
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            leading: const BackWidget(),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            centerTitle: true,
            title: TextWidget(
              text: 'Semua Produk',
              color: color,
              textSize: 20.0,
              isTile: true,
            ),
          ),
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  focusNode: _searchTextFocusNode,
                  controller: _searchTextController,
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        _isSearching = true;
                        searchResults = allProduct.where((product) {
                          return product.title
                              .toLowerCase()
                              .contains(value.toLowerCase());
                        }).toList();
                      } else {
                        _isSearching = false;
                      }
                    });
                  },
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.greenAccent, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.greenAccent, width: 1),
                      ),
                      hintText: "Cari Produk",
                      suffixIcon: IconButton(
                        onPressed: () {
                          _searchTextController.clear();
                          _searchTextFocusNode.unfocus();
                          _isSearching = false;
                        },
                        icon: Icon(
                          Icons.close,
                          color: _searchTextFocusNode.hasFocus
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.search)),
                ),
                GridView.count(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: size.width / (size.height * 0.69),
                    children: List.generate(
                        _isSearching ? searchResults.length : allProduct.length,
                        (index) {
                      return ChangeNotifierProvider.value(
                        value: _isSearching
                            ? searchResults[index]
                            : allProduct[index],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(22),
                            color: Theme.of(context).cardColor,
                            child: InkWell(
                              onTap: () {
                                viewedProdProvider.addProductToHistory(
                                    productId: _isSearching
                                        ? searchResults[index].id
                                        : allProduct[index].id);
                                Navigator.pushNamed(
                                    context, ProductDetails.routeName,
                                    arguments: _isSearching
                                        ? searchResults[index].id
                                        : allProduct[index].id);
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                children: [
                                  Image.network(
                                    _isSearching
                                        ? searchResults[index].imageUrl
                                        : allProduct[index].imageUrl,
                                    height: size.width * 0.21,
                                    width: size.width * 0.2,
                                    fit: BoxFit.fill,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                            flex: 3,
                                            child: TextWidget(
                                              text: _isSearching
                                                  ? searchResults[index].title
                                                  : allProduct[index].title,
                                              color: color,
                                              maxLines: 1,
                                              textSize: 18,
                                              isTile: true,
                                            )),
                                        Flexible(
                                            flex: 1,
                                            child: HeartButton(
                                                productId: _isSearching
                                                    ? searchResults[index].id
                                                    : allProduct[index].id,
                                                isInWishlist: wishlistProvider
                                                    .getWishlistItems
                                                    .containsKey(_isSearching
                                                        ? searchResults[index]
                                                            .id
                                                        : allProduct[index]
                                                            .id)))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          child: PriceWidget(
                                            textPrice:
                                                _quantityTextController.text,
                                            salePrice: _isSearching
                                                ? searchResults[index].salePrice
                                                : allProduct[index].salePrice,
                                            price: _isSearching
                                                ? searchResults[index].price
                                                : allProduct[index].price,
                                            isOnSale: _isSearching
                                                ? searchResults[index].isOnSale
                                                : allProduct[index].isOnSale,
                                          ),
                                        ),
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Flexible(
                                                flex: 6,
                                                child: FittedBox(
                                                    child: TextWidget(
                                                  text: _isSearching
                                                      ? searchResults[index]
                                                              .isPiece
                                                          ? 'Piece'
                                                          : 'kg'
                                                      : allProduct[index]
                                                              .isPiece
                                                          ? 'Piece'
                                                          : 'kg',
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
                                                    controller:
                                                        _quantityTextController,
                                                    key: const ValueKey('10'),
                                                    style: TextStyle(
                                                        color: color,
                                                        fontSize: 18),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    maxLines: 1,
                                                    enabled: true,
                                                    onChanged: (valueee) {
                                                      setState(() {});
                                                    },
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(
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
                                      onPressed: cartProvider.getCartItems
                                              .containsKey(_isSearching
                                                  ? searchResults[index].id
                                                  : allProduct[index].id)
                                          ? null
                                          : () async {
                                              final User? user =
                                                  authInstance.currentUser;

                                              if (user == null) {
                                                GlobalMethods.errorDialog(
                                                    subtitle:
                                                        'No user found, Please login first',
                                                    context: context);
                                                return;
                                              }
                                              await GlobalMethods.addToCart(
                                                  productId: _isSearching
                                                      ? searchResults[index].id
                                                      : allProduct[index].id,
                                                  quantity: int.parse(
                                                      _quantityTextController
                                                          .text),
                                                  context: context);
                                              await cartProvider.fetchCart();
                                            },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Theme.of(context).cardColor),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(12.0),
                                                      bottomRight:
                                                          Radius.circular(
                                                              12.0))))),
                                      child: TextWidget(
                                        text: cartProvider.getCartItems
                                                .containsKey(_isSearching
                                                    ? searchResults[index].id
                                                    : allProduct[index].id)
                                            ? 'in cart'
                                            : "Masukkan Keranjang",
                                        maxLines: 1,
                                        color: color,
                                        textSize: 17,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })),
              ],
            ),
          ))),
    );
  }
}
