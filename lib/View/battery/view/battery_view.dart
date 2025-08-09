import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/View/battery/view/battery_config.dart';
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
    return Scaffold(
      body: GetX<BatteryController>(
        builder: (controller) {
          return Stack(
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

              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BatteryConfig(),
                              ),
                            );
                          },
                          child: ChildGlasmorphism(
                            margin: EdgeInsets.only(right: 20),
                            borderRadius: 30,
                            child: SizedBox(
                              width: 150,
                              height: 50,
                              // color: Colors.amber,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                child: Center(
                                  child: Text(
                                    "Battery Config",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Main content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20,
                          left: 30,
                          right: 30,
                        ),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                    fontSize: MediaQuery.sizeOf(context).width*0.02,
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,

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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,

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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,

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
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
