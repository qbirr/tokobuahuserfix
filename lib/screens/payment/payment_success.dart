import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Expanded(
        child: Center(
          child: LoadingAnimationWidget.discreteCircle(
              color: Colors.green, size: 48),
        ),
      )),
    );
  }
}
