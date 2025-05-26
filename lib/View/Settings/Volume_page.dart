import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Utils/header.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/Volume_Controller.dart';

class VolumeControl extends StatefulWidget {
  final String robotid;

  const VolumeControl({super.key, required this.robotid});

  @override
  _VolumeControlState createState() => _VolumeControlState();
}

class _VolumeControlState extends State<VolumeControl> {
  @override
  void initState() {
    _hideSystemUI();
    Get.find<VolumeController>().fetchinitialvolume(widget.robotid);
    super.initState();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive); // Hide status bar again
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: GetX<VolumeController>(
                  builder: (VolumeController controller) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GetX<BatteryController>(
                          builder: (BatteryController batteryController) {
                            return Column(
                              children: [
                                Icon(Icons.volume_up,
                                    size: 50,
                                    color: batteryController
                                        .foregroundColor.value),
                                Text(
                                  "Volume: ${controller.roboVolume.value}%",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: batteryController
                                          .foregroundColor.value),
                                ),
                              ],
                            );
                          },
                        ),

                        SizedBox(
                          width: 300.w, // Adjust width as needed
                          child: Slider(
                            value: controller.roboVolume.value.toDouble(),
                            activeColor: Colors.green,
                            min: 0,
                            max: 100,
                            divisions: 10,
                            label: "${controller.roboVolume.value}%",
                            onChanged: (value) {
                              controller.roboVolume.value = value.toInt();
                            },
                            onChangeEnd: (value) {
                              Get.find<VolumeController>()
                                  .fetchvolume(widget.robotid, value.toInt());
                            },
                          ),
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     ElevatedButton(
                        //       onPressed: _decreaseVolume,
                        //       child: const Icon(Icons.remove),
                        //     ),
                        //     const SizedBox(width: 20),
                        //     ElevatedButton(
                        //       onPressed: _increaseVolume,
                        //       child: const Icon(Icons.add),
                        //     ),
                        //   ],
                        // ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Column(
            children: [
              Header(
                isBack: true,
                screenName: "VOLUME CONTROLLER",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
