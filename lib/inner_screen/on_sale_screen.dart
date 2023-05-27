

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/widgets/back_widget.dart';
import 'package:tokobuah/widgets/empty_product_widget.dart';
import 'package:tokobuah/widgets/on_sale_widget.dart';
import 'package:tokobuah/widgets/text_widget.dart';

import '../model/model_product.dart';
import '../providers/product_providers.dart';
import '../services/utils.dart';

class OnSaleScreen extends StatelessWidget {
  const OnSaleScreen({Key? key}) : super(key: key);
  static const routeName = "/OnSaleScreen";

  @override
  Widget build(BuildContext context) {
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> productOnSale = productProviders.getOnSaleProduct;
    final Color color = Utils(context).color;
    Size size = Utils(context).screenSize;
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: "Produk yang dijual",
          color: color,
          textSize: 24.0,
          isTile: true,
        ),
      ),
      body: productOnSale.isEmpty
          ? EmptyProdWidget(text: "Tidak Ada Produk")
          : GridView.count(
          padding: EdgeInsets.zero,
          crossAxisCount: 2,
          childAspectRatio: size.width / (size.height * 0.59),
          children:
          List.generate(productOnSale.length, (index){
            return ChangeNotifierProvider.value(
                value: productOnSale[index],
            child: const OnSaleWidget(),);
          })
      ),
    );
  }
}
