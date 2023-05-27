import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/screens/orders/order_widgets.dart';
import 'package:tokobuah/screens/viewed_recently/viewed_recently_widget.dart';
import 'package:tokobuah/screens/wishlist/wishlist_widget.dart';
import 'package:tokobuah/services/utils.dart';
import 'package:tokobuah/widgets/back_widget.dart';
import 'package:tokobuah/widgets/text_widget.dart';

import '../../providers/viewed_providers.dart';
import '../../services/global_method.dart';
import '../../widgets/empty_screen.dart';
import '../cart/cart_widget.dart';

class ViewedRecentlyScreen extends StatefulWidget {
  const ViewedRecentlyScreen({super.key});
  static const routeName = "/ViewedRecentlyScreen";

  @override
  State<ViewedRecentlyScreen> createState() => _ViewedRecentlyScreenState();
}

class _ViewedRecentlyScreenState extends State<ViewedRecentlyScreen> {
  bool check = true;

  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;

    // Size size = Utils(context).getScreenSize;
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    final viewedProdItemsList = viewedProdProvider.getViewedProdlistItems.values
        .toList()
        .reversed
        .toList();
    if (viewedProdItemsList.isEmpty) {
      return const EmptyScreen(
        title: 'Your history is empty',
        subtitle: 'No products has been viewed yet!',
        buttonText: 'Shop now',
        imagePath: 'assets/images/history.png',
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                GlobalMethods.warningDialog(
                    title: 'Empty your history?',
                    subtitle: 'Are you sure?',
                    fct: () {},
                    context: context);
              },
              icon: Icon(
                IconlyBroken.delete,
                color: color,
              ),
            )
          ],
          leading: const BackWidget(),
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          title: TextWidget(
            text: 'History',
            color: color,
            textSize: 24.0,
          ),
          backgroundColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        ),
        body: ListView.builder(
            itemCount: viewedProdItemsList.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: ChangeNotifierProvider.value(
                    value: viewedProdItemsList[index],
                    child: const ViewedRecentlyWidget()),
              );
            }),
      );
    }
  }
}
