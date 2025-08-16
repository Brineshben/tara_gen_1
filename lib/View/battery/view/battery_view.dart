import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/View/battery/widgets/charging_circle.dart';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({super.key});

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetX<BatteryController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 50),
            child: Row(
              children: [
                Expanded(
                  child: CharginDock(
                    onDock: controller.onDock.value,
                    percentage: controller.batteryStatus.toString(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: BaseGlassmorphism(
                                borderRadius: 10,
                                padding: EdgeInsetsGeometry.all(10),
                                child: Column(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Status",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      controller.onDock.value
                                          ? "On Dock"
                                          : "Not On Dock",
                                      style: TextStyle(
                                        color: Color(0xff96FFBB),
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          spacing: 15,
                          children: [
                            Expanded(
                              child: BaseGlassmorphism(
                                borderRadius: 10,
                                padding: EdgeInsetsGeometry.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Current",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "${controller.batteryModel.value?.data?.first.robot?.current ?? 0}A",
                                      style: TextStyle(
                                        color: Color(0xff96FFBB),
                                        fontSize:
                                            MediaQuery.sizeOf(context).width * 0.02,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: BaseGlassmorphism(
                                borderRadius: 10,
                                padding: EdgeInsetsGeometry.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Battery",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "${controller.batteryStatus}%",
                                      style: TextStyle(
                                        color: Color(0xff96FFBB),
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          spacing: 15,
                          children: [
                            Expanded(
                              child: BaseGlassmorphism(
                                borderRadius: 10,
                                padding: EdgeInsetsGeometry.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Energy",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "65 wh",
                                      style: TextStyle(
                                        color: Color(0xff96FFBB),
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: BaseGlassmorphism(
                                borderRadius: 10,
                                padding: EdgeInsetsGeometry.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Time to drop",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "05 hr",
                                      style: TextStyle(
                                        color: Color(0xff96FFBB),
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: controller.onDock.value
                      ? Image.asset("assets/on_dock.png")
                      : Image.asset("assets/not_on_dock.png"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
