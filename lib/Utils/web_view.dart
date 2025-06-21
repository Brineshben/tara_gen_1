// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class InAppWebViewScreen extends StatelessWidget {
//   final String url;

//   const InAppWebViewScreen({Key? key, required this.url}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(Uri.parse(url));

//     return SafeArea(
//       child: Scaffold(
//         body: WebViewWidget(
//           controller: controller,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class InAppWebViewScreen extends StatelessWidget {
  final String url;

  const InAppWebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
