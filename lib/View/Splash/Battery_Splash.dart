import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Utils/colors.dart';
import 'package:ihub/View/Robot_Response/password_page.dart';
import 'package:ihub/View/homepagee.dart';
import 'package:lottie/lottie.dart';

import '../../Controller/Login_api_controller.dart';
import '../../Controller/battery_Controller.dart';
import '../Robot_Response/homepage.dart';

class BatterySplash extends StatefulWidget {
  const BatterySplash({super.key});

  @override
  State<BatterySplash> createState() => _BatterySplashState();
}

class _BatterySplashState extends State<BatterySplash> {
  Timer? messageTimer;
  bool isRotale = false;

  @override
  void initState() {
    messageTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      print("Timer in battery screen");
      bool? chargeStatus = await Get.find<BatteryController>().fetchCharging(
          Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);

      if (!(chargeStatus ?? true)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
        );

        timer.cancel();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            isRotale = !isRotale;
            setState(() {});
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      GetX<BatteryController>(
                        builder: (BatteryController controller) {
                          String? data;

                          if (controller.background.value?.data!.isNotEmpty ??
                              false) {
                            data = controller.background.value?.data?.first
                                    .robot?.batteryStatus ??
                                "";
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${data ?? "0"}%",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                      // Center(
                      //   child: Transform.rotate(
                      //     angle: 3 * pi / 2,
                      //     child: SizedBox(
                      //       width: size.width * 0.35,
                      //       height: size.width * 0.35,
                      //       child: Lottie.asset(
                      //         "assets/battery.json",
                      //         fit: BoxFit.fitHeight,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      isRotale
                          ? Center(
                              child: SizedBox(
                                height: size.width * 0.45,
                                child: Lottie.asset(
                                  "assets/rotate.json",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          : Center(
                              child: SizedBox(
                                height: size.width * 0.45,
                                child: Lottie.asset(
                                  "assets/still.json",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                      // SizedBox(
                      //   height: 50.h,
                      //   width: 280.w,
                      //   child: DefaultTextStyle(
                      //     style: GoogleFonts.inter(
                      //         color: Colors.white,
                      //         fontSize: 30.h,
                      //         fontWeight: FontWeight.bold,
                      //         shadows: [
                      //           Shadow(
                      //             blurRadius: 5.0,
                      //             color: Colors.black.withOpacity(0.7),
                      //             offset: Offset(2, 2),
                      //           ),
                      //         ]),
                      //     child: Center(
                      //       child: AnimatedTextKit(
                      //         animatedTexts: [
                      //           TypewriterAnimatedText(
                      //             'CHARGING....',
                      //             speed: Duration(milliseconds: 150),
                      //             cursor: '|',
                      //           ),
                      //         ],
                      //         repeatForever: true,
                      //         isRepeatingAnimation: true,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Positioned(
                  top: 180,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Icon(
                    Icons.bolt,
                    color: Colors.white,
                    size: 50,
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(
              left: 30.w, top: 120.h, right: 20.w, bottom: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      ColorUtils.userdetailcolor,
                      ColorUtils.userdetailcolor
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.circular(10), // Ensure proper border radius
                ),
                child: Material(
                  color: Colors.transparent, // Ensure the gradient is visible
                  borderRadius: BorderRadius.circular(10),
                  child: FloatingActionButton.extended(
                    heroTag: "settings_btn",
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 300),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  PasswordPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                                opacity: animation, child: child);
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.settings, color: Colors.white),
                    label: Text("SETTINGS ",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18.h,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
