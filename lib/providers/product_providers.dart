import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/model_product.dart';

class ProductsProvider with ChangeNotifier{
  static List<ProductModel> _productsList = [];
  List<ProductModel> get getProduct {
    return _productsList;
  }
  List<ProductModel> get getOnSaleProduct{
    return _productsList.where((element) => element.isOnSale).toList();
  }

  Future<void> fetchProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productSnapshot) {
          _productsList = [];
          ///_productsList.clear();
      productSnapshot.docs.forEach((element) {
        _productsList.insert(
            0,
            ProductModel(
              id: element.get('id'),
              title: element.get('title'),
              imageUrl: element.get('imageUrl'),
              productCategoryName: element.get('productCategoryName'),
              price:double.parse(element.get('price')),
              salePrice: element.get('salePrice').toDouble(),
              isOnSale: element.get('isOnSale'),
              isPiece: element.get('isPiece'),
            ));
      });
    });
    notifyListeners();
  }
  ProductModel findProdById(String productId){
    return _productsList.firstWhere((element) => element.id == productId);
  }

  List<ProductModel> findByCategory(String categoryName){
    List<ProductModel> _categoryList = _productsList.where((element) =>
        element.productCategoryName.toLowerCase().contains(
            categoryName.toLowerCase())).toList();
    return _categoryList;
  }
  List<ProductModel> searchQuery(String searchText) {
    List<ProductModel> _searchList = _productsList
        .where(
          (element) => element.title.toLowerCase().contains(
        searchText.toLowerCase(),
      ),
    )
        .toList();
    return _searchList;
  }

///static final List<ProductModel> _productsList = [
    ///ProductModel(
      ///id: 'Apricot',
      ///title: 'Aprikot',
      ///price: 14000,
      ///salePrice: 12000,
      ///imageUrl: 'https://i.ibb.co/F0s3FHQ/Apricots.png',
      ///productCategoryName: 'Buah-buahan',
      ///isOnSale: true,
      ///isPiece: false,
    ///),
  ///ProductModel(
  ///id: 'Avocado',
  ///title: 'Alpukat',
  ///price: 8000,
  ///salePrice: 6000,
  ///imageUrl: 'https://i.ibb.co/9VKXw5L/Avocat.png',
  ///productCategoryName: 'Buah-buahan',
  ///isOnSale: false,
  ///isPiece: true,
  ///),
  ///ProductModel(
  ///id: 'Black grapes',
  ///title: 'Anggur Hitam',
  ///price: 40000,
  ///salePrice: 37000,
  ///imageUrl: 'https://i.ibb.co/c6w5zrC/Black-Grapes-PNG-Photos.png',
  ///productCategoryName: 'Buah-buahan',
  ///isOnSale: true,
  ///isPiece: false,
  ///),
  ///ProductModel(
  ///id: 'Fresh_green_grape',
  ///title: 'Anggur Hijau Segar',
  ///price: 38000,
  ///salePrice: 34000,
  ///imageUrl: 'https://i.ibb.co/HKx2bsp/Fresh-green-grape.png',
  ///productCategoryName: 'Buah-buahan',
  ///isOnSale: true,
  ///isPiece: false,
  ///),
  ///ProductModel(
  ///id: 'Green grape',
  ///title: 'Anggur Hijau',
  ///price: 30000,
  ///salePrice: 28000,
  ///imageUrl: 'https://i.ibb.co/bHKtc33/grape-green.png',
  ///productCategoryName: 'Buah-buahan',
  ///isOnSale: false,
  ///isPiece: false,
  ///),
    ///ProductModel(
  ///id: 'Red apple',
  ///title: 'Apel Merah',
  ///price: 27000,
  ///salePrice: 25000,
  ///imageUrl: 'https://i.ibb.co/crwwSG2/red-apple.png',
  ///productCategoryName: 'Buah-buahan',
  ///isOnSale: true,
  ///isPiece: false,
  ///),
    // Vegi
  ///ProductModel(
  ///id: 'Carottes',
  ///title: 'Wortel',
  ///price: 6000,
  ///salePrice: 5500,
  ///imageUrl: 'https://i.ibb.co/TRbNL3c/Carottes.png',
  ///productCategoryName: 'Sayuran',
  ///isOnSale: true,
  ///isPiece: false,
  ///),
  ///ProductModel(
  ///id: 'Cauliflower',
  ///title: 'Kol Bunga',
  ///price: 10000,
  ///salePrice: 9000,
  /// imageUrl: 'https://i.ibb.co/xGWf2rH/Cauliflower.png',
  ///productCategoryName: 'Sayuran',
  /// isOnSale: false,
  /// isPiece: true,
  ///),
  ///ProductModel(
  /// id: 'Cucumber',
  /// title: 'Mentimun',
  /// price: 6000,
  /// salePrice: 5000,
  /// imageUrl: 'https://i.ibb.co/kDL5GKg/cucumbers.png',
  ///productCategoryName: 'Sayuran',
  /// isOnSale: false,
  /// isPiece: false,
  ///),
  ///ProductModel(
  /// id: 'Jalape',
  /// title: 'Cabai',
  /// price: 50000,
  ///salePrice: 47000,
  ///imageUrl: 'https://i.ibb.co/Dtk1YP8/Jalape-o.png',
  /// productCategoryName: 'Sayuran',
  /// isOnSale: false,
  /// isPiece: false,
  ///),
  ///ProductModel(
  /// id: 'Long yam',
  /// title: 'Ubi Panjang',
  /// price: 9000,
  /// salePrice: 8000,
  /// imageUrl: 'https://i.ibb.co/V3MbcST/Long-yam.png',
  /// productCategoryName: 'Sayuran',
  /// isOnSale: false,
  /// isPiece: false,
  ///),
  ///ProductModel(
  /// id: 'Onions',
  /// title: 'Bawang Merah',
  /// price: 4000,
  /// salePrice: 3500,
  /// imageUrl: 'https://i.ibb.co/GFvm1Zd/Onions.png',
  /// productCategoryName: 'Sayuran',
  /// isOnSale: false,
  /// isPiece: false,
  ///),
  ///ProductModel(
  /// id: 'Plantain-flower',
  /// title: 'Bunga Pisang',
  /// price: 10000,
  /// salePrice: 9500,
  /// imageUrl: 'https://i.ibb.co/RBdq0PD/Plantain-flower.png',
  /// productCategoryName: 'Sayuran',
  /// isOnSale: false,
  /// isPiece: true,
  ///),
  ///ProductModel(
  /// id: 'Potato',
  /// title: 'Kentang',
  /// price: 8000,
  /// salePrice: 7000,
  /// imageUrl: 'https://i.ibb.co/wRgtW55/Potato.png',
  /// productCategoryName: 'Sayuran',
  /// isOnSale: true,
  /// isPiece: false,
  ///),
  ///ProductModel(
  /// id: 'Radish',
  /// title: 'Lobak',
  /// price: 11000,
  /// salePrice: 10000,
  /// imageUrl: 'https://i.ibb.co/YcN4ZsD/Radish.png',
  ///productCategoryName: 'Sayuran',
  /// isOnSale: false,
  /// isPiece: false,
  ///),
  ///ProductModel(
  /// id: 'Red peppers',
  /// title: 'Cabai Merah',
  /// price: 45000,
  /// salePrice: 44000,
  /// imageUrl: 'https://i.ibb.co/JthGdkh/Red-peppers.png',
  /// productCategoryName: 'Sayuran',
  /// isOnSale: false,
  /// isPiece: false,
  ///),
  ///ProductModel(
  /// id: 'Squash',
  /// title: 'Labu',
  /// price: 15000,
  /// salePrice: 14000,
  /// imageUrl: 'https://i.ibb.co/p1V8sq9/Squash.png',
  /// productCategoryName: 'Sayuran',
  /// isOnSale: true,
  /// isPiece: true,
  ///),
  ///ProductModel(
///
}