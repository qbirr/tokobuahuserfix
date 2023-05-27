import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/screens/wishlist/wishlist_widget.dart';
import 'package:tokobuah/services/utils.dart';
import 'package:tokobuah/widgets/back_widget.dart';
import 'package:tokobuah/widgets/text_widget.dart';

import '../../providers/wishlist_provider.dart';
import '../../services/global_method.dart';
import '../../widgets/empty_screen.dart';
import '../cart/cart_widget.dart';


class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});
  static const routeName = "/WishlistScreen";

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).screenSize;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemsList =
    wishlistProvider.getWishlistItems.values.toList().reversed.toList();

    return wishlistItemsList.isEmpty ?
    const EmptyScreen(
      title: 'Tidak ada produk favorit',
      subtitle: 'Ayo klik love dan langsung checkout :)',
      buttonText: 'Belanja Sekarang',
      imagePath: 'assets/images/wishlist.png',
    )


    :
    Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        title: TextWidget(
          text: "Wishlist (${wishlistItemsList.length})",
          color: color,
          textSize: 22,
          isTile: true,
        ),
        actions: [
          IconButton(onPressed: () {
            GlobalMethods.warningDialog(title: "Hapus Daftar Favorit", subtitle: "Yakin ?",
                fct: ()async{
              await wishlistProvider.clearOnlineWishlist();
              wishlistProvider.clearWishlist();
            }
                , context: context);
          },
              icon: Icon(
                IconlyLight.delete,
                color: color,
              ))
        ],
      ),
      body: MasonryGridView.count(
        itemCount: wishlistItemsList.length,
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
              value: wishlistItemsList[index],
              child: const WishlistWidget());
        },
      )
      );
  }
  }