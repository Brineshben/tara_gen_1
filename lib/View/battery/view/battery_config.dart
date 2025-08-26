import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Model/batteryModel.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/Utils/helper_function.dart';
import 'package:ihub/View/battery/controller/battery_config_controller.dart';
import 'package:ihub/View/battery/widgets/input.dart';

class BatteryConfig extends StatefulWidget {
  const BatteryConfig({super.key});

  @override
  State<BatteryConfig> createState() => _BatteryConfigState();
}

class _BatteryConfigState extends State<BatteryConfig> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    final provider = Get.find<BatteryConfigController>();
    provider.fetchChargeValues(context).then((_) {
      _batteryController.text = provider.lowBatteryEntry.value;
      _backHomeEntryController.text = provider.backToHomeEntry.value;
    });
  }

  final TextEditingController _batteryController = TextEditingController();
  final TextEditingController _backHomeEntryController =
      TextEditingController();

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
                  Color(0xFF608878).withOpacity(0.2),
                  Color(0xFF18221E).withOpacity(0.2),
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.transparent),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ChildGlasmorphism(
                      borderRadius: 10,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => Navigator.of(context).pop(),
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
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
                          child: GlassmorphismModal(
                            backHomeEntryController: _backHomeEntryController,
                            lowBatteryController: _batteryController,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 90),
                            child: Column(
                              spacing: 15,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GetX<BatteryController>(
                                          builder: (provider) {
                                            return BaseGlassmorphism(
                                              borderRadius: 10,
                                              padding: EdgeInsetsGeometry.all(
                                                10,
                                              ),
                                              child: Column(
                                                spacing: 10,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Status",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    provider.onDock.value
                                                        ? "On Dock"
                                                        : "Not On Dock",
                                                    style: TextStyle(
                                                      color: Color(
                                                        0xff96FFBB,
                                                      ),
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
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
                                        child: GetX<BatteryConfigController>(
                                          builder: (provider) {
                                            return BaseGlassmorphism(
                                              borderRadius: 10,
                                              padding: EdgeInsetsGeometry.all(
                                                15,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Low battery entry",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${provider.lowBatteryEntry}%",
                                                    style: TextStyle(
                                                      color: Color(
                                                        0xff96FFBB,
                                                      ),
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: GetX<BatteryConfigController>(
                                          builder: (provider) {
                                            return BaseGlassmorphism(
                                              borderRadius: 10,
                                              padding: EdgeInsetsGeometry.all(
                                                15,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Home entry",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${provider.backToHomeEntry}%",
                                                    style: TextStyle(
                                                      color: Color(
                                                        0xff96FFBB,
                                                      ),
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
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
                                        child: GetX<BatteryController>(
                                            builder: (controller) {
                                          return BaseGlassmorphism(
                                            borderRadius: 10,
                                            padding: EdgeInsetsGeometry.all(15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "Current Percentage",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Text(
                                                  "${controller.batteryStatus.value} %",
                                                  style: const TextStyle(
                                                    color: Color(0xff96FFBB),
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                      Expanded(
                                        child: GetX<BatteryController>(
                                            builder: (controller) {
                                          return BaseGlassmorphism(
                                              borderRadius: 10,
                                              padding:
                                                  EdgeInsetsGeometry.all(15),
                                              child: controller.onDock.value
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          "Time to Full Charge",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${estimateTimeToFullCharge(
                                                            currentPercent:
                                                                controller
                                                                    .batteryStatus
                                                                    .toDouble(),
                                                          ).toStringAsFixed(0)} m",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xff96FFBB),
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          "Time to Drop",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${estimateTimeToEmpty(
                                                            currentPercent:
                                                                controller
                                                                    .batteryStatus
                                                                    .toDouble(),
                                                          ).toStringAsFixed(0)} m",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .redAccent,
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ));
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GetX<BatteryController>(
                          builder: (provider) {
                            return Expanded(
                              child: provider.onDock.value
                                  ? Image.asset(
                                      "assets/on_dock.png",
                                      width: MediaQuery.sizeOf(context).height *
                                          0.8,
                                    )
                                  : Image.asset("assets/not_on_dock.png"),
                            );
                          },
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
    );
  }
}
