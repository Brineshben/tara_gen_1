import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/popups.dart';
import 'package:ihub/View/Robot_Response/homepage.dart';
import 'package:ihub/View/Robot_Response/password_page.dart';
import 'package:ihub/View/Settings/settings.dart';
import 'package:lottie/lottie.dart';

import '../../Controller/battery_Controller.dart';

class BatterySplash extends StatefulWidget {
  const BatterySplash({super.key});

  @override
  State<BatterySplash> createState() => _BatterySplashState();
}

class _BatterySplashState extends State<BatterySplash> {
  Timer? oneSecTimer;

  @override
  void initState() {
    oneSecTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      Map<String, dynamic> resp = await ApiServices.getBatteryStatus();
      if (resp['status'] != true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
          (route) => false,
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetX<BatteryController>(
              builder: (BatteryController controller) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${controller.batteryStatus.value}%",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                );
              },
            ),
            Center(
              child: SizedBox(
                height: size.width * 0.38,
                child: Lottie.asset(
                  "assets/charging.json",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildInfoCard(
                size,
                "SETTINGS",
                color: Colors.black,
                onTap: () async {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 300),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          PasswordPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15.r),
                  splashColor: Colors.blue,
                  highlightColor: Colors.green.withOpacity(0.3),
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
                                      navigateToLocationByName();
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

  void navigateToLocationByName() async {
    try {
      final resp = await ApiServices.setHOme();

      if (resp['status'] == true) {
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
              "Heading to the home location",
              textAlign: TextAlign.center,
              style: GoogleFonts.oxygen(
                color: Colors.black,
                fontSize: 15.h,
              ),
            ),
          ),
        );
      }
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
