import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:tokobuah/consts/firebase_auth.dart';
import 'package:tokobuah/screens/auth/forget_password.dart';
import 'package:tokobuah/screens/auth/login.dart';
import 'package:tokobuah/screens/loading_manager.dart';
import 'package:tokobuah/screens/orders/order_screen.dart';
import 'package:tokobuah/screens/viewed_recently/viewed_recenty_screen.dart';
import 'package:tokobuah/screens/wishlist/wishlist_screen.dart';
import 'package:tokobuah/services/global_method.dart';

import '../provider/dark_theme_provider.dart';
import '../widgets/text_widget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController =
      TextEditingController(text: "");

  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  ///fetch data user
  String? _email;
  String? _name;
  String? address;
  bool _isLoading = false;
  final User? user = authInstance.currentUser;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String uid = user!.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        address = userDoc.get('shipping-address');
        _addressTextController.text = userDoc.get('shipping-address');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
        body: LoadingManager(
      isLoading: _isLoading,
      child: Center(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 5,
              ),
              RichText(
                  text: TextSpan(
                      text: 'Hi, ',
                      style: const TextStyle(
                          color: Colors.cyan,
                          fontSize: 27,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                    TextSpan(

                        ///fetch name user
                        text: _name ?? 'users',

                        ///
                        style: TextStyle(
                            color: color,
                            fontSize: 27,
                            fontWeight: FontWeight.normal),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("My Name is pressed");
                          })
                  ])),
              const SizedBox(
                height: 5,
              ),
              TextWidget(
                ///fetch email user
                text: _email == null ? 'email' : _email!,
                color: color,
                textSize: 18,

                ///

                ///isTile: true,
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                thickness: 2,
              ),
              _listTiles(
                  title: "Alamat",
                  subtitle: address,
                  icon: IconlyLight.profile,
                  onPressed: () async {
                    await _showAddresDialog();
                  },
                  color: color),
              _listTiles(
                  title: "Pesanan",
                  icon: IconlyLight.bag,
                  onPressed: () {
                    GlobalMethods.navigateTo(
                        ctx: context, routeName: OrdersScreen.routeName);
                  },
                  color: color),
              _listTiles(
                  title: "Favorit",
                  icon: IconlyLight.heart,
                  onPressed: () {
                    GlobalMethods.navigateTo(
                        ctx: context, routeName: WishlistScreen.routeName);
                  },
                  color: color),
              _listTiles(
                  title: "Dilihat",
                  icon: IconlyLight.show,
                  onPressed: () {
                    GlobalMethods.navigateTo(
                        ctx: context,
                        routeName: ViewedRecentlyScreen.routeName);
                  },
                  color: color),
              _listTiles(
                  title: "Lupa Password",
                  icon: IconlyLight.unlock,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ForgetPasswordScreen()));
                  },
                  color: color),
              SwitchListTile(
                title: TextWidget(
                  text: themeState.getDarkTheme ? "Dark Mode" : "Light Mode",
                  color: color,
                  textSize: 22,
                ),
                secondary: Icon(themeState.getDarkTheme
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined),
                onChanged: (bool value) {
                  themeState.setDarkTheme = value;
                },
                value: themeState.getDarkTheme,
              ),
              _listTiles(
                  title: user == null ? "Login" : "Keluar",
                  icon: user == null ? IconlyLight.login : IconlyLight.logout,
                  onPressed: () {
                    if (user == null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                      return;
                    }

                    GlobalMethods.warningDialog(
                        title: "Sign Out",
                        subtitle: "Apakah anda ingin keluar ?",
                        fct: () async {
                          await authInstance.signOut().then((_) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                          });
                        },
                        context: context);
                  },
                  color: color),
            ],
          ),
        ),
      )),
    ));
  }

  Future<void> _showAddresDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update"),
            content: TextField(
              ///onChanged: (value) {
              ///print("_addressTextController.text ${_addressTextController.text}");
              ///},
              controller: _addressTextController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: "Alamat Anda"),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    String uid = user!.uid;
                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .update({
                        'shipping-address': _addressTextController.text
                      });
                      Navigator.pop(context);
                    } catch (err) {
                      GlobalMethods.errorDialog(
                          subtitle: err.toString(), context: context);
                    }
                  },
                  child: const Text("Update"))
            ],
          );
        });
  }
}

Widget _listTiles(
    {required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color}) {
  return ListTile(
    title: TextWidget(
      text: title,
      color: color,
      textSize: 22,

      ///isTile: true,
    ),
    subtitle: TextWidget(
      text: subtitle ?? "",
      color: color,
      textSize: 18,
    ),
    leading: Icon(icon),
    trailing: const Icon(IconlyLight.arrowRight2),
    onTap: () {
      onPressed();
    },
  );
}
