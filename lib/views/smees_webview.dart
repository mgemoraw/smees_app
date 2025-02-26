import 'package:flutter/material.dart';
import 'package:smees/views/common/appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';


class SmeesWebView extends StatefulWidget {
  const SmeesWebView({super.key});

  @override
  State<SmeesWebView> createState() => _SmeesWebViewState();
}

class _SmeesWebViewState extends State<SmeesWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();



    // controller = WebViewController()
    // ..setJavaScriptMode(JavaScriptMode.unrestricted)
    // ..loadRequest(Uri.parse("https://www.google.com"));

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.google.com'));

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: SmeesAppbar(title: "SMEES - Web"),
      body: WebViewWidget(controller: controller,),
    );
  }
}
