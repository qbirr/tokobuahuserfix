import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/consts/theme_data.dart';
import 'package:tokobuah/controllers/cart_controller.dart';
import 'package:tokobuah/fetch_screen.dart';
import 'package:tokobuah/inner_screen/feeds_screen.dart';
import 'package:tokobuah/inner_screen/on_sale_screen.dart';
import 'package:tokobuah/inner_screen/product_details.dart';
import 'package:tokobuah/provider/dark_theme_provider.dart';
import 'package:tokobuah/providers/oders_provider.dart';
import 'package:tokobuah/providers/product_providers.dart';
import 'package:tokobuah/providers/viewed_providers.dart';
import 'package:tokobuah/providers/wishlist_provider.dart';
import 'package:tokobuah/screens/auth/forget_password.dart';
import 'package:tokobuah/screens/auth/login.dart';
import 'package:tokobuah/screens/auth/register.dart';
import 'package:tokobuah/screens/orders/order_screen.dart';
import 'package:tokobuah/screens/viewed_recently/viewed_recenty_screen.dart';
import 'package:tokobuah/screens/wishlist/wishlist_screen.dart';

import 'inner_screen/cat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(CartController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('Program Error'),
                ),
              ),
            );
          }
          return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) {
                  return themeChangeProvider;
                }),
                ChangeNotifierProvider(create: (_) => ProductsProvider()),
                ChangeNotifierProvider(create: (_) => WishlistProvider()),
                ChangeNotifierProvider(create: (_) => ViewedProdProvider()),
                ChangeNotifierProvider(
                  create: (_) => OrdersProvider(),
                ),
              ],
              child: Consumer<DarkThemeProvider>(
                  builder: (context, themeProvider, child) {
                return GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  theme: Styles.themeData(themeProvider.getDarkTheme, context),
                  home: const FetchScreen(),
                  routes: {
                    OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                    FeedsScreen.routeName: (ctx) => const FeedsScreen(),
                    ProductDetails.routeName: (ctx) => const ProductDetails(),
                    WishlistScreen.routeName: (ctx) => const WishlistScreen(),
                    OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                    ViewedRecentlyScreen.routeName: (ctx) =>
                        const ViewedRecentlyScreen(),
                    RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                    LoginScreen.routeName: (ctx) => const LoginScreen(),
                    ForgetPasswordScreen.routeName: (ctx) =>
                        const ForgetPasswordScreen(),
                    CategoryScreen.routeName: (ctx) => const CategoryScreen(),
                  },
                  builder: EasyLoading.init(),
                );
              }));
        });
  }
}
