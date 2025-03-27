import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        final controller = webViewController;
        if (controller != null) {
          if (await controller.canGoBack()) {
            controller.goBack();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("In App Web View"),
          centerTitle: true,
        ),
        body: Container(child: webViewPage()),
      ),
    );
  }

  Widget webViewPage() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: InAppWebView(
        initialUrlRequest:
            URLRequest(url: WebUri("https://www.ekika.co/web/login")),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        initialSettings: InAppWebViewSettings(),
      ),
    );
  }
}
