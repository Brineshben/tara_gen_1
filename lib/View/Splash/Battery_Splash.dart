import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../Controller/Login_api_controller.dart';
import '../../Controller/battery_Controller.dart';
import '../Robot_Response/robot_response.dart';

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
    bool? chargeStatus =await  Get.find<BatteryController>().fetchCharging(
          Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);
      if(!(chargeStatus?? true )){
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const RobotResponse();
        },));
        timer.cancel();
      }
    });    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, top: 20),
            child: Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.3),
                            //     blurRadius: 10,
                            //     spreadRadius: 0,
                            //   ),
                            // ],
                            borderRadius: BorderRadius.circular(15).r),
                        child: Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    // Center(
                    //   child: Text(
                    //     "NAVIGATION",
                    //     style: GoogleFonts.oxygen(
                    //         color: Colors.white,
                    //         fontSize: 25.h,
                    //         fontWeight: FontWeight.w700),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              children: [
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
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 25.h, bottom: 25.h, left: 10.w, right: 10.w),
                    child: Text(
                      "BATTERY PERCENTAGE: 84%",
                      style: GoogleFonts.roboto(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w900,
                        fontSize: 20.h,
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
