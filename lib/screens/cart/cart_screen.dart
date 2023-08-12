import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/controllers/cart_controller.dart';
import 'package:tokobuah/services/checkout_services.dart';
import 'package:uuid/uuid.dart';
import '../../consts/firebase_auth.dart';
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
    final cartItemsList = Get.find<CartController>().cartItems;
    return GetBuilder<CartController>(
      builder: (controller) {
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
                                await Get.find<CartController>()
                                    .clearOnlineCart();
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
                      child: Obx(
                        () => ListView.builder(
                          itemCount: cartItemsList.length,
                          itemBuilder: (ctx, index) {
                            return CartWidget(
                              q: cartItemsList[index].quantity,
                              cartItem: cartItemsList[index],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget _checkout({required BuildContext ctx}) {
    final Color color = Utils(ctx).color;
    Size size = Utils(ctx).screenSize;
    final productProvider = Provider.of<ProductsProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(ctx);
    double total = 0.0;
    for (var cartItem in Get.find<CartController>().cartItems) {
      final getCurrProduct = productProvider.findProdById(cartItem.productId);
      total += (getCurrProduct.isOnSale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          cartItem.quantity;
    }
    List<String> paymentMethod = [];
    String payment = '';

    void getPaymentMethod(int id) {
      switch (id) {
        case 1:
          paymentMethod.clear();
          payment = 'E-Wallet';
          paymentMethod.addAll(
            [
              "OVO",
              "DANA",
              "SHOPEEPAY",
            ],
          );
          break;
        case 2:
          paymentMethod.clear();
          payment = 'Transfer Bank';
          paymentMethod.addAll(
            [
              "BCA",
              "BNI",
              "BRI",
              "MANDIRI",
              "PERMATA",
            ],
          );
          break;
        default:
          paymentMethod.clear();
          payment = 'Minimarket';
          paymentMethod.addAll(
            [
              "ALFAMART",
              "INDOMARET",
            ],
          );
      }
    }

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
                final productProvider =
                    Provider.of<ProductsProvider>(ctx, listen: false);
                showBottomSheet(
                  context: ctx,
                  builder: (context) => Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0)),
                      color: Colors.green,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          onTap: () {
                            getPaymentMethod(0);
                            CheckoutService().payOrder(
                                Get.find<CartController>().discount > 0
                                    ? Get.find<CartController>()
                                        .grandTotal
                                        .value
                                    : total,
                                paymentMethod,
                                payment,
                                Get.find<CartController>().cartItems,
                                orderId,
                                context);
                          },
                          title: DefaultTextStyle.merge(
                            child: const Text(
                              'Minimarket',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.keyboard_arrow_right_outlined,
                            size: 24.0,
                            color: Colors.white,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            getPaymentMethod(1);
                            CheckoutService().payOrder(
                                Get.find<CartController>().discount > 0
                                    ? Get.find<CartController>()
                                        .grandTotal
                                        .value
                                    : total,
                                paymentMethod,
                                payment,
                                Get.find<CartController>().cartItems,
                                orderId,
                                context);
                          },
                          title: DefaultTextStyle.merge(
                            child: const Text(
                              'E-Wallet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.keyboard_arrow_right_outlined,
                            size: 24.0,
                            color: Colors.white,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            getPaymentMethod(2);
                            CheckoutService().payOrder(
                                Get.find<CartController>().discount > 0
                                    ? Get.find<CartController>()
                                        .grandTotal
                                        .value
                                    : total,
                                paymentMethod,
                                payment,
                                Get.find<CartController>().cartItems,
                                orderId,
                                context);
                          },
                          title: DefaultTextStyle.merge(
                            child: const Text(
                              'Transfer Bank',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.keyboard_arrow_right_outlined,
                            size: 24.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                // showDialog(
                //   context: ctx,
                //   builder: (BuildContext context) {
                //     return AlertDialog(
                //       title: const Text('Konfirmasi'),
                //       content: const Text(
                //           'Anda yakin ingin memesan?. Pesanan anda berada di alamat ini silahkan klik OK untuk menuju lokasi dan lakukan pembayaran'),
                //       actions: <Widget>[
                //         TextButton(
                //           child: const Text('Batal'),
                //           onPressed: () {
                //             Navigator.of(context).pop();
                //           },
                //         ),
                //         TextButton(
                //           child: const Text('OK'),
                //           onPressed: () async {
                //             Navigator.of(context).pop();
                //             cartProvider.getCartItems.forEach(
                //               (key, value) async {
                //                 final getCurrProduct =
                //                     productProvider.findProdById(
                //                   value.productId,
                //                 );
                //                 try {
                //                   await FirebaseFirestore.instance
                //                       .collection('orders')
                //                       .doc(orderId)
                //                       .set({
                //                     'orderId': orderId,
                //                     'userId': user!.uid,
                //                     'productId': value.productId,
                //                     'price': (getCurrProduct.isOnSale
                //                             ? getCurrProduct.salePrice
                //                             : getCurrProduct.price) *
                //                         value.quantity,
                //                     'totalPrice': total,
                //                     'quantity': value.quantity,
                //                     'imageUrl': getCurrProduct.imageUrl,
                //                     'userName': user.displayName,
                //                     'orderDate': Timestamp.now(),
                //                   });
                //                   await cartProvider.clearOnlineCart();
                //                   cartProvider.clearCart();
                //                   ordersProvider.fetchOrders();
                //                   Fluttertoast.showToast(
                //                     msg:
                //                         'Pesanan Anda telah ditempatkan Silahkan Ambil dan Bayar di tempat.Terima Kasih ;)',
                //                     toastLength: Toast.LENGTH_SHORT,
                //                     gravity: ToastGravity.CENTER,
                //                   );
                //                   const address =
                //                       'Jl. Pemuda, Krndal Growong, Pucungrejo, Kec. Muntilan, Kabupaten Magelang, Jawa Tengah 56413'; // Replace with the actual address
                //                   const title = 'Weins Fresh';

                //                   try {
                //                     final availableMaps =
                //                         await MapLauncher.installedMaps;

                //                     if (availableMaps.isNotEmpty) {
                //                       await availableMaps.first.showMarker(
                //                         coords: Coords(-7.578500,
                //                             110.279083), // Set your desired coordinates
                //                         title: title,
                //                         description: address,
                //                       );
                //                     } else {
                //                       Fluttertoast.showToast(
                //                         msg: 'No maps app found!',
                //                         toastLength: Toast.LENGTH_SHORT,
                //                         gravity: ToastGravity.CENTER,
                //                       );
                //                     }
                //                   } catch (error) {
                //                     Fluttertoast.showToast(
                //                       msg: 'Error launching maps app!',
                //                       toastLength: Toast.LENGTH_SHORT,
                //                       gravity: ToastGravity.CENTER,
                //                     );
                //                   }
                //                 } catch (error) {
                //                   GlobalMethods.errorDialog(
                //                       subtitle: error.toString(), context: ctx);
                //                 }
                //               },
                //             );
                //           },
                //         ),
                //       ],
                //     );
                //   },
                // );
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
          GetBuilder<CartController>(builder: (controller) {
            return FittedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      TextWidget(
                        text: 'Total: ',
                        color: color,
                        textSize: 18,
                        isTile: true,
                      ),
                      TextWidget(
                        text: NumberFormat.currency(
                          locale: 'id-ID',
                          name: 'Rp ',
                          decimalDigits: 0,
                        ).format(Get.find<CartController>().totalAmount.value),
                        color: color,
                        textSize: 18,
                        isTile: true,
                        decoration: controller.discount > 0
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      controller.discount > 0
                          ? Row(
                              children: [
                                const SizedBox(
                                  width: 6,
                                ),
                                TextWidget(
                                  text: NumberFormat.currency(
                                    locale: 'id-ID',
                                    name: '',
                                    decimalDigits: 0,
                                  ).format(Get.find<CartController>()
                                      .grandTotal
                                      .value),
                                  color: color,
                                  textSize: 18,
                                  isTile: true,
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                  controller.discount > 0
                      ? TextWidget(
                          text:
                              'Anda mendapatkan diskon sebesar ${controller.discount}% !',
                          color: color,
                          textSize: 14,
                          isTile: false,
                        )
                      : const SizedBox(),
                ],
              ),
            );
          }),
        ]),
      ),
    );
  }
}
