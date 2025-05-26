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
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/View/Home_Screen/battery_Widget.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class AboutRobot extends StatelessWidget {
  const AboutRobot({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 30),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 60.h,
                        width: 60.h,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15).r),
                        child: Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Center(
                      child: Text(
                        "TARA",
                        style: GoogleFonts.oxygen(
                            color: Colors.white,
                            fontSize: 25.h,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  "Version: 1.0.1",
                  style: GoogleFonts.podkova(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Column(
                children: [
                  Header(
                    isBack: true,
                    screenName: "",
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: ModelViewer(
              backgroundColor: Colors.black,
              src: 'assets/mold.glb',
              alt: 'A 3D model of an astronaut',
              ar: true,
              autoRotate: true,
              disableZoom: false,
            ),
          ),
        ],
      ),
    );
  }
}
