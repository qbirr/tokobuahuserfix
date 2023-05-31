import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tokobuah/services/checkout_services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({
    required this.invoiceUrl,
    required this.orderId,
    required this.total,
    required this.paymentMethod,
    super.key,
  });

  final String invoiceUrl;
  final String orderId;
  final double total;
  final String paymentMethod;

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            double prog = progress / 100;
            if (progress < 100) {
              EasyLoading.showProgress(prog.toDouble(),
                  maskType: EasyLoadingMaskType.black,
                  status: 'Memproses Data');
            } else {
              EasyLoading.dismiss();
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            log(request.url.toString(), name: 'Current URL');
            if (request.url.startsWith('https://www.youtube.com/')) {
              Fluttertoast.showToast(
                msg:
                    'Pesanan Anda telah ditempatkan Silahkan Ambil di tempat. Terima Kasih ;)',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
              );
              await CheckoutService()
                  .onPaymentSuccess(orderId, total, context, paymentMethod);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(invoiceUrl));
    return Scaffold(
      body: WillPopScope(
          onWillPop: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Batalkan Transaksi'),
                content:
                    const Text('Anda yakin ingin membatalkan transaksi ini?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Tidak')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ya')),
                ],
              ),
            );
            return Future.value(true);
          },
          child: SafeArea(child: WebViewWidget(controller: controller))),
    );
  }
}
