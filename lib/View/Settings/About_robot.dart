// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class aboutRobot extends StatefulWidget {
//   @override
//   State<aboutRobot> createState() => aboutRobotState();
// }
//
// class aboutRobotState extends State<aboutRobot> {
//   late final WebViewController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(Uri.parse(
//           "https://collaborate.shapr3d.com/v/0OrA1xudAFZqM8qlACoW3"));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.only(top: 30),
//           child: WebViewWidget(controller: _controller),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';


class AboutRobot extends StatelessWidget {
  const AboutRobot({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 30.w, vertical: 5.h),
              child: Text(
                'TARA',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 30.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ModelViewer(
                backgroundColor:Colors.black,
                src: 'assets/mold.glb',
                alt: 'A 3D model of an astronaut',
                ar: true,
                autoRotate: true,
                // iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
                disableZoom: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

