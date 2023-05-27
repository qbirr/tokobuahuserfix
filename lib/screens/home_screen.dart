import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/consts/constss.dart';
import 'package:tokobuah/inner_screen/feeds_screen.dart';
import 'package:tokobuah/inner_screen/on_sale_screen.dart';
import 'package:tokobuah/provider/dark_theme_provider.dart';
import 'package:tokobuah/services/global_method.dart';
import 'package:tokobuah/services/utils.dart';
import 'package:tokobuah/widgets/feed_items.dart';
import 'package:tokobuah/widgets/on_sale_widget.dart';
import 'package:tokobuah/widgets/text_widget.dart';

import '../model/model_product.dart';
import '../providers/product_providers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<String> _offerImages = [
    "assets/images/offres/Offer1.jpg",
    "assets/images/offres/Offer2.jpg",
    "assets/images/offres/Offer3.jpg",
    "assets/images/offres/Offer4.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    Size size = Utils(context).screenSize;
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProduct = productProviders.getProduct;
    List<ProductModel> productOnSale = productProviders.getOnSaleProduct;


    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.35,
              child: Swiper(
                autoplay: true,
                itemBuilder: (BuildContext context, int index){
                  return Image.asset(_offerImages[index], fit: BoxFit.fill,);
                },
                itemCount: _offerImages.length,
                pagination: SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(color: Colors.white, activeColor: Colors.red)
                ),
              )
            ),
            const SizedBox(
              height: 6,
            ),
            TextButton(onPressed: (){
              GlobalMethods.navigateTo(ctx: context, routeName: OnSaleScreen.routeName);
            },
                child: TextWidget(
                  text: 'Lihat Semua',
                  maxLines: 1,
                  color: Colors.blue,
                  textSize: 20,
                )
            ),const SizedBox(
              height: 6,
            ),
            Row(
              children: [

                Flexible(
                  child: SizedBox(
                    height: size.height * 0.24,
                    child: ListView.builder(
                        itemCount: productOnSale.length < 10
                            ? productOnSale.length
                            : 10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return ChangeNotifierProvider.value(
                              value: productOnSale[index],
                              child: const OnSaleWidget());
                        }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(text: "Produk Kami", color: color, textSize: 22, isTile: true,),
                  Spacer(),
                  TextButton(onPressed: (){
                    GlobalMethods.navigateTo(ctx: context, routeName: FeedsScreen.routeName);
                  },
                      child: TextWidget(
                        text: 'Cari Semua',
                        maxLines: 1,
                        color: Colors.blue,
                        textSize: 20,
                      )
                  ),
                ],
              ),
            ),
            GridView.count(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
            childAspectRatio: size.width / (size.height * 0.69),
              children: 
                List.generate(
                    allProduct.length < 4
                    ? allProduct.length
                      : 4,(index){
                  return ChangeNotifierProvider.value(
                    value: allProduct[index],
                    child: const FeedsWidgets(
                    ),
                  );
                })
            ),
            
          ],
        ),
      ),
    );
  }
}