
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../consts/firebase_auth.dart';
import '../../providers/cart_providers.dart';
import '../../providers/oders_provider.dart';
import '../../providers/product_providers.dart';
import '../../services/global_method.dart';
import '../../services/utils.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import 'cart_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).screenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
    cartProvider.getCartItems.values.toList().reversed.toList();
    return cartItemsList.isEmpty
        ? const EmptyScreen(
      title: 'Your cart is empty',
      subtitle: 'Add something and make me happy :)',
      buttonText: 'Shop now',
      imagePath: 'assets/images/cart.png',
    )
        : Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: 'Cart (${cartItemsList.length})',
            color: color,
            isTile: true,
            textSize: 22,
          ),
          actions: [
            IconButton(
              onPressed: () {
                GlobalMethods.warningDialog(
                    title: 'Empty your cart?',
                    subtitle: 'Are you sure?',
                    fct: () async {
                      await cartProvider.clearOnlineCart();
                      cartProvider.clearCart();
                    },
                    context: context);
              },
              icon: Icon(
                IconlyBroken.delete,
                color: color,
              ),
            ),
          ]),
      body: Column(
        children: [
          _checkout(ctx: context),
          Expanded(
            child: ListView.builder(
              itemCount: cartItemsList.length,
              itemBuilder: (ctx, index) {
                return ChangeNotifierProvider.value(
                    value: cartItemsList[index],
                    child: CartWidget(
                      q: cartItemsList[index].quantity,
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkout({required BuildContext ctx}) {
    final Color color = Utils(ctx).color;
    Size size = Utils(ctx).screenSize;
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productProvider = Provider.of<ProductsProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(ctx);
    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);
      total += (getCurrProduct.isOnSale
          ? getCurrProduct.salePrice
          : getCurrProduct.price) *
          value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      // color: ,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(children: [
          Material(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                User? user = authInstance.currentUser;
                final orderId = const Uuid().v4();
                final productProvider = Provider.of<ProductsProvider>(ctx, listen: false);
                showDialog(
                  context: ctx,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Konfirmasi'),
                      content: Text('Anda yakin ingin memesan?. Pesanan anda berada di alamat ini silahkan klik OK untuk menuju lokasi dan lakukan pembayaran'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Batal'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('OK'),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            cartProvider.getCartItems.forEach((key, value) async {
                              final getCurrProduct = productProvider.findProdById(
                                value.productId,
                              );
                              try {
                                await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
                                  'orderId': orderId,
                                  'userId': user!.uid,
                                  'productId': value.productId,
                                  'price': (getCurrProduct.isOnSale ? getCurrProduct.salePrice : getCurrProduct.price) * value.quantity,
                                  'totalPrice': total,
                                  'quantity': value.quantity,
                                  'imageUrl': getCurrProduct.imageUrl,
                                  'userName': user.displayName,
                                  'orderDate': Timestamp.now(),
                                });
                                await cartProvider.clearOnlineCart();
                                cartProvider.clearCart();
                                ordersProvider.fetchOrders();
                                Fluttertoast.showToast(
                                  msg: 'Pesanan Anda telah ditempatkan Silahkan Ambil dan Bayar di tempat.Terima Kasih ;)',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                );
                                final address = 'Jl. Pemuda, Krndal Growong, Pucungrejo, Kec. Muntilan, Kabupaten Magelang, Jawa Tengah 56413'; // Replace with the actual address
                                final title = 'Weins Fresh';

                                try {
                                  final availableMaps =
                                  await MapLauncher.installedMaps;

                                  if (availableMaps.isNotEmpty) {
                                    await availableMaps.first.showMarker(
                                      coords: Coords(-7.578500, 110.279083), // Set your desired coordinates
                                      title: title,
                                      description: address,
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: 'No maps app found!',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                    );
                                  }
                                } catch (error) {
                                  Fluttertoast.showToast(
                                    msg: 'Error launching maps app!',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                  );
                                }
                              } catch (error) {
                                GlobalMethods.errorDialog(subtitle: error.toString(), context: ctx);
                              }
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextWidget(
                  text: 'Pesan',
                  textSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Spacer(),
          FittedBox(
            child: TextWidget(
              text: 'Total: \Rp${total.toStringAsFixed(2)}',
              color: color,
              textSize: 18,
              isTile: true,
            ),
          ),
        ]),
      ),
    );
  }
}
