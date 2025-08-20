import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/speed_controller.dart';

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
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF608878).withOpacity(0.2), // light green
                  Color(0xFF18221E).withOpacity(0.2), // dark green
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.transparent),
            ),
          ),
          Center(
            child: GetX<SpeedController>(
              builder: (SpeedController controller) {
                if (controller.isLoading.value) {
                  return CircularProgressIndicator(color: Colors.white);
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
                    "Speed: ${(controller.speed.value * 10).toInt()}",

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
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 30),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 10),
                const Text(
                  'SPEED CONTROLLER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
