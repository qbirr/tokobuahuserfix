

import 'package:flutter/material.dart';
import 'package:tokobuah/services/utils.dart';
import 'package:tokobuah/widgets/categories_widgets.dart';

import '../widgets/text_widget.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});
  List<Color> gridColors = [
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
  ];
  List<Map<String, dynamic>> catInfo = [
    {
      'imgPath': 'assets/images/cat/fruits.png',
      'catText': 'Buah-buahan',
    },
    {
      'imgPath': 'assets/images/cat/veg.png',
      'catText': 'Sayuran',
    },
    {
      'imgPath': 'assets/images/cat/Spinach.png',
      'catText': 'Herbal',
    },
    {
      'imgPath': 'assets/images/cat/nuts.png',
      'catText': 'Kacang-kacangan',
    },
    {
      'imgPath': 'assets/images/cat/spices.png',
      'catText': 'Rempah-rempah',
    },
    {
      'imgPath': 'assets/images/cat/grains.png',
      'catText': 'Biji-bijian',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    Color color = utils.color;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text : "Kategori",
          color: color,
          textSize: 24,
          isTile: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 240/250,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: List.generate(6, (index){
            return CategoriesWidget(
              catText: catInfo[index]['catText'],
              imgPath: catInfo[index]['imgPath'],
              passedColor: gridColors[index],
            );
          }),

        ),
      ),
    );
  }
}