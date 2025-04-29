import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  void initState() {
    messageTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      print("Timer");
      bool? chargeStatus = await Get.find<BatteryController>().fetchCharging(
          Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);
      if (!(chargeStatus ?? true)) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const Homepage();
          },
        ));
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
                      data = controller.background.value?.data?.first.robot
                              ?.batteryStatus ??
                          "";
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${data ?? ""}%",
                          style: TextStyle(color: Colors.white, fontSize: 30.h),
                        )
                      ],
                    );
                  },
                ),
                Center(
                  child: Transform.rotate(
                    angle: 3 * pi / 2,
                    child: SizedBox(
                      width: size.width * 0.35,
                      height: size.width * 0.35,
                      child: Lottie.asset(
                        "assets/battery.json",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                  width: 280.w,
                  child: DefaultTextStyle(
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 30.h,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black.withOpacity(0.7),
                            offset: Offset(2, 2),
                          ),
                        ]),
                    child: Center(
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'CHARGING....',
                            speed: Duration(milliseconds: 50),
                            // Adjust typing speed
                            cursor: '|', // Optional cursor
                          ),
                        ],
                        repeatForever: true,
                        // Ensures continuous looping
                        isRepeatingAnimation: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
