import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return MaterialApp(initialRoute: '/', routes: {
        '/': (context) => webViewPage(),
      });
    }
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
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
        ),
        onProgressChanged: (controller, progress) {},
        onPermissionRequest: (controller, permissionRequest) async {
          if (permissionRequest.resources
              .contains(PermissionResourceType.MICROPHONE)) {
            final PermissionStatus permissionStatus =
                await Permission.microphone.request();
            if (permissionStatus.isGranted) {
              return PermissionResponse(
                resources: permissionRequest.resources,
                action: PermissionResponseAction.GRANT,
              );
            } else if (permissionStatus.isDenied) {
              return PermissionResponse(
                resources: permissionRequest.resources,
                action: PermissionResponseAction.DENY,
              );
            }
          }
          return null;
        },
      ),
    );
  }
}
