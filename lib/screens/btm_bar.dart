import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/providers/cart_providers.dart';
import 'package:tokobuah/screens/categories.dart';
import 'package:tokobuah/screens/home_screen.dart';
import 'package:tokobuah/screens/user.dart';
import 'package:badges/badges.dart' as badges;
import 'package:tokobuah/widgets/text_widget.dart';

import 'cart/cart_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {"page": HomeScreen(), 'title': "Home Screen"},
    {"page": CategoriesScreen(), 'title': "Category Screen"},
    {"page": CartScreen(), 'title': "Cart Screen"},
    {"page": UserScreen(), 'title': "User Screen"}
  ];

  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///appBar: AppBar(
      ///title: Text(_pages[_selectedIndex]['title'])
      ///),
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _selectedPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1
                  ? IconlyBold.category
                  : IconlyLight.category),
            label: "Categories",
          ),
          BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (_, myCart, ch) {
                  return badges.Badge(
                      badgeAnimation: const badges.BadgeAnimation.slide(),
                      badgeStyle: badges.BadgeStyle(
                          shape: badges.BadgeShape.circle,
                          badgeColor: Colors.blue,
                          borderRadius: BorderRadius.circular(8)),
                      position: badges.BadgePosition.topEnd(top: -7, end: -7),
                      badgeContent: FittedBox(
                        child: TextWidget(
                            text: myCart.getCartItems.length.toString(),
                            color: Colors.white, textSize: 15),
                      ),
                      child: Icon(_selectedIndex == 1
                          ? IconlyBold.buy
                          : IconlyLight.buy));
                }
              ),
              label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2),
              label: "User"),
        ],
      ),
    );
  }
}
