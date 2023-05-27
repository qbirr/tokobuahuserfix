import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/consts/constss.dart';
import 'package:tokobuah/model/model_product.dart';
import 'package:tokobuah/providers/product_providers.dart';
import 'package:tokobuah/widgets/back_widget.dart';
import 'package:tokobuah/widgets/feed_items.dart';

import '../services/utils.dart';
import '../widgets/text_widget.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);
  static const routeName = "/FeedsScreenState";


  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final TextEditingController? _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }
  ///@override
  ///void initState(){
    ///final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    ///productsProvider.fetchProducts();
    ///super.initState();
  ///}
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).screenSize;
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProduct = productProviders.getProduct;
    return Scaffold(
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
      body :SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            TextField(
              focusNode: _searchTextFocusNode,
              controller: _searchTextController,
              onChanged: (value){
                setState(() {

                });
              },
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.greenAccent,
                    width: 1
                  ),
                ),
                enabledBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Colors.greenAccent,
                      width: 1
                  ),
                ),
                hintText: "Cari Produk",
                suffixIcon: IconButton(
                  onPressed: (){
                    _searchTextController!.clear();
                    _searchTextFocusNode.unfocus();
                  },
                  icon: Icon(Icons.close, color: _searchTextFocusNode.hasFocus ? Colors.red : Colors.white,),
                ),
                prefixIcon: Icon(Icons.search)
              ),
            ),
            GridView.count(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: size.width / (size.height * 0.69),
                children:
                List.generate(allProduct.length, (index){
                  return ChangeNotifierProvider.value(
                    value: allProduct[index],
                    child : const FeedsWidgets(
                    ),
                  );
                })
            ),
      ],
    ),
        )
      )
    );
  }
}
