import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/inner_screen/product_details.dart';
import 'package:tokobuah/model/cart_model.dart';
import 'package:tokobuah/model/model_product.dart';
import 'package:tokobuah/providers/product_providers.dart';
import 'package:tokobuah/services/global_method.dart';
import 'package:tokobuah/widgets/heart_btn.dart';
import 'package:tokobuah/widgets/text_widget.dart';

import '../../providers/cart_providers.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/utils.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key, required this.q }) : super(key: key);
  final int q;
  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _quantityTextController = TextEditingController();


  @override
  void initState() {
    _quantityTextController.text = widget.q.toString();
    super.initState();
  }
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
    final cartModel = Provider.of<CartModel>(context);
    final getCurrentProduct = productProvider.findProdById(cartModel.productId);
    double usedPriced = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInWishlist = cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, ProductDetails.routeName, arguments: cartModel.productId);
        
      },
      child: Row(
        children: [
          Expanded(
          child :Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              children: [
                Container(
                  height: size.width * 0.25,
                  width: size.width * 0.25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: Image.network(
                    getCurrentProduct.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                        text: getCurrentProduct.title,
                        color: color,
                        textSize: 20,
                    isTile: true,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      width: size.width*0.3,
                      child: Row(
                        children: [
                         _quantityController(fct: 
                             (){
                           if (_quantityTextController.text == '1'){
                             return;
                           }else {
                             cartProvider.reduceQuantityByOne(cartModel.productId);
                             setState(() {
                               _quantityTextController.text = (int.parse(
                                   _quantityTextController
                                       .text) -1
                               ).toString();
                             });
                           }
                         },
                         icon: CupertinoIcons.minus,
                             color: Colors.red
                         ),
                          Flexible(
                            flex: 1,
                            child: TextField(
                              controller: _quantityTextController,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide()
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')
                                )
                              ],
                              onChanged: (v){
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  if(v.isEmpty){
                                    _quantityTextController.text='1';
                                  }else{
                                    return;
                                  }
                                });
                              },
                            ),
                          ),
                          _quantityController(
                              fct: (){
                                cartProvider.increaseQuantityByOne(cartModel.productId);
                                setState(() {

                                  _quantityTextController.text = (int.parse(_quantityTextController.text)+1).toString();
                                });
                              },
                              icon: CupertinoIcons.plus,
                              color: Colors.green)
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: ()async{
                          await cartProvider.removeOneItem(
                            cartId: cartModel.id,
                            productId: cartModel.productId,
                            quantity: cartModel.quantity,
                          );
                        },
                        child: Icon(
                            CupertinoIcons.cart_badge_minus,
                        color: Colors.red,
                        size: 20,),
                      ),
                      const SizedBox(height: 5),
                      HeartButton(
                          productId: getCurrentProduct.id,
                          isInWishlist : _isInWishlist
                      ),
                      TextWidget(
                          text: '\Rp${(usedPriced * int.parse(_quantityTextController.text)).toStringAsFixed(0)}',
                          color: color,
                          textSize: 18,
                      maxLines: 1,)
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                )
              ],
            )
          ),
          )
        ],
      ),
    );
  }

  Widget _quantityController({
  required Function fct,
    required IconData icon,
    required Color color}){
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: (){
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Colors.white,),
            ),
          ),
        ),
      ),
    );
  }
}
