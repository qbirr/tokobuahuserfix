import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tokobuah/inner_screen/feeds_screen.dart';
import 'package:tokobuah/services/global_method.dart';
import 'package:tokobuah/services/utils.dart';
import 'package:tokobuah/widgets/text_widget.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({Key? key,
   required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText

  }) : super(key: key);
  final String imagePath, title, subtitle, buttonText;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).screenSize;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox( height: 50,),
              Image.asset(imagePath,
              width: double.infinity,
              height: size.height * 0.4,
              ),
              SizedBox(
                height: 10,
              ),
              Text("Whoopss!", style: TextStyle(
                color: Colors.red,
                fontSize: 40,
                fontWeight: FontWeight.w700
              ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                  text: title,
                  color: Colors.cyan,
                  textSize: 18),
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                  text: subtitle,
                  color: Colors.cyan,
                  textSize: 18),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary
                    )
                  ),
                  primary: Theme.of(context).colorScheme.secondary,
                  onPrimary: color,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 20
                  )
                ),
                  onPressed: (){
                    GlobalMethods.navigateTo(
                        ctx: context,
                        routeName: FeedsScreen.routeName);
                  },

                  child: TextWidget(
              text: buttonText,
                  color: Colors.grey.shade800,
                  textSize: 20)
              )
            ]
          ),
        ),
      ),
    );
  }
}
