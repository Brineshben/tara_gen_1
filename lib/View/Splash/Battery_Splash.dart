import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/Navigate_Controller.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/popups.dart';
import 'package:ihub/View/Robot_Response/homepage.dart';
import 'package:ihub/View/Robot_Response/password_page.dart';
import 'package:ihub/View/Settings/settings.dart';
import 'package:lottie/lottie.dart';

import '../../Controller/Login_api_controller.dart';
import '../../Controller/battery_Controller.dart';

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
    Get.find<NavigateController>().navigateData();

    messageTimer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) async {
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () async {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            PasswordPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                      ),
                    );
                  },
                  child: buildInfoCard(
                    size,
                    "SETTINGS",
                    color: Colors.black,
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15.r),
                  onTap: () async {
                    Get.dialog(
                      Dialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: 300,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Lottie.asset(
                                "assets/home.json",
                                width: 100,
                                height: 100,
                                repeat: true,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Navigate Home?",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Do you want to send the robot to the home location now?",
                                style: TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => Get.back(),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      backgroundColor: Colors.white,
                                    ),
                                    child: const Text("No"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      Get.back();
                                      navigateToLocationByName('home');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Text(
                                      "Yes, Start",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Ink(
                    width: 100,
                    height: 120,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Lottie.asset("assets/home.json"),
                        Text(
                          "HOME",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void navigateToLocationByName(String name) async {
    try {
      final controller = Get.find<NavigateController>();

      final item = controller.dataList.firstWhere(
        (e) => e?.name?.toLowerCase() == name.toLowerCase(),
        orElse: () => null,
      );

      if (item == null) {
        ProductAppPopUps.submit(
          title: "NOT FOUND",
          message: "$name location not found.",
          actionName: "Close",
          iconData: Icons.info_outline,
          iconColor: Colors.orange,
        );
        return;
      }

      await ApiServices.destination(id: item.id ?? 0);
      await Future.delayed(Duration(seconds: 2));

      final resp = await ApiServices.robotbasestatus();
      final bool status = resp['status'] == true;
      final String message =
          status ? "Heading to ${item.name}" : "Command already received";

      Get.dialog(
        AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            children: [
              Center(
                child: SizedBox(
                  width: 180.w,
                  height: 180.h,
                  child: Lottie.asset("assets/navigate.json"),
                ),
              ),
              Text(
                "COMMAND RECEIVED",
                style: GoogleFonts.orbitron(
                  color: Colors.black,
                  fontSize: 20.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            message.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.oxygen(
              color: Colors.black,
              fontSize: 15.h,
            ),
          ),
        ),
      );

      Future.delayed(Duration(seconds: 3), () {
        if (Get.isDialogOpen ?? false) Get.back();
        if (Get.isDialogOpen ?? false) Get.back();
      });
    } catch (e) {
      ProductAppPopUps.submit(
        title: "FAILED",
        message: "Something went wrong.",
        actionName: "Close",
        iconData: Icons.info_outline,
        iconColor: Colors.red,
      );
      print("Error: ${e.toString()}");
    }
  }
}
