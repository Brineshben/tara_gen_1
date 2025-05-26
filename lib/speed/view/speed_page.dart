import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/speed/controller/speed_controller.dart';

class SpeedControllerPage extends StatefulWidget {
  const SpeedControllerPage({super.key});

  @override
  _SpeedControllerPageState createState() => _SpeedControllerPageState();
}

class _SpeedControllerPageState extends State<SpeedControllerPage> {
  @override
  void initState() {
    _hideSystemUI();
    Get.find<SpeedController>().fetchSpeed();
    super.initState();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
          ),
          GetX<BackgroudController>(
            builder: (BackgroudController controller) {
              return Positioned.fill(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          controller.backgroundModel.value?.backgroundImage ??
                              "",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                          controller.defaultIMage,
                          fit: BoxFit.cover),
                      errorWidget: (context, url, error) => Image.asset(
                          controller.defaultIMage,
                          fit: BoxFit.cover),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 10.0, sigmaY: 10.0), // Adjust blur strength
                      child: Container(
                        color: Colors.black.withOpacity(
                            0), // Required for BackdropFilter to work
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Center(
            child: GetX<SpeedController>(
              builder: (SpeedController controller) {
                if (controller.isLoading.value) {
                  return CircularProgressIndicator(color: Colors.black);
                }
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // controller.speed.value <= 0.3
                      //     ? Lottie.asset('assets/slow-speed.json', width: 265)
                      //     : controller.speed.value <= 0.5
                      //     ? Lottie.asset('assets/modarate.json', width: 200)
                      //     : Lottie.asset('assets/fastspeed.json', width: 200),
                      Container(
                        width: MediaQuery.of(context).size.height * 0.3,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: controller.speed.value <= 0.3
                                ? Colors.green
                                : controller.speed.value <= 0.5
                                    ? Colors.orange
                                    : Colors.red,
                            width: 4,
                          ),
                        ),
                        child: Icon(
                          Icons.speed_outlined,
                          size: MediaQuery.of(context).size.height * 0.2,
                          color: controller.speed.value <= 0.3
                              ? Colors.green
                              : controller.speed.value <= 0.5
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                      SizedBox(height: 30),

                      Text(
                        "Speed: ${controller.speed.value.toStringAsFixed(1)}",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: controller.speed.value <= 0.3
                              ? Colors.green
                              : controller.speed.value <= 0.5
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Plus and Minus buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                double newSpeed = controller.speed.value - 0.1;
                                if (newSpeed >= 0.1) {
                                  controller.speed.value = newSpeed;
                                  controller.updateSpeed(newSpeed);
                                  HapticFeedback.mediumImpact();
                                }
                              },
                              child: Ink(
                                width: 200,
                                decoration: BoxDecoration(
                                  color: controller.speed.value <= 0.3
                                      ? Colors.green
                                      : controller.speed.value <= 0.5
                                          ? Colors.orange
                                          : Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: const Icon(
                                  Icons.remove,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                double newSpeed = controller.speed.value + 0.1;
                                if (newSpeed <= 0.7) {
                                  controller.speed.value = newSpeed;
                                  controller.updateSpeed(newSpeed);
                                  HapticFeedback.mediumImpact();
                                }
                              },
                              child: Ink(
                                width: 200,
                                decoration: BoxDecoration(
                                  color: controller.speed.value <= 0.3
                                      ? Colors.green
                                      : controller.speed.value <= 0.5
                                          ? Colors.orange
                                          : Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: const Icon(
                                  Icons.add,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Column(
            children: [
              Header(
                isBack: true,
                screenName: "SPEED CONTROLLER",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
