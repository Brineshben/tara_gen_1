import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

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
    Get.find<VolumeController>().fetchinitialvolume("RB3");
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
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images.jpg',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          GetX<BackgroudController>(
            builder: (BackgroudController controller) {
              return Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl:
                      controller.backgroundModel.value?.backgroundImage ?? "",
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Image.asset("assets/images.jpg", fit: BoxFit.cover),
                  errorWidget: (context, url, error) =>
                      Image.asset("assets/images.jpg", fit: BoxFit.cover),
                ),
              );
            },
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 40, bottom: 30),
                child: Row(
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
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "VOLUME",
                      style: GoogleFonts.oxygen(
                          color: Colors.white,
                          fontSize: 25.h,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: GetX<VolumeController>(
                    builder: (VolumeController controller) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.volume_up,
                            size: 50,
                            color: Colors.white,
                          ),
                          Text("Volume: ${controller.roboVolume.value}%",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          SizedBox(
                            width: 300.w, // Adjust width as needed
                            child: Slider(
                              value: controller.roboVolume.value.toDouble(),
                              min: 0,
                              max: 150,
                              divisions: 10,
                              label: "${controller.roboVolume.value}%",
                              onChanged: (value) {
                                controller.roboVolume.value = value.toInt();
                              },
                              onChangeEnd: (value) {
                                Get.find<VolumeController>()
                                    .fetchvolume("RB3", value.toInt());
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
            ],
          )
        ],
      ),
      // floatingActionButton: Container(
      //   margin:
      //       EdgeInsets.only(left: 30.w, top: 120.h, right: 20.w, bottom: 20.h),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Container(
      //         decoration: BoxDecoration(
      //           color: Colors.red,
      //           borderRadius: BorderRadius.circular(20.r),
      //           boxShadow: [
      //             BoxShadow(
      //               color: Colors.black.withOpacity(0.2),
      //               spreadRadius: 1,
      //               blurRadius: 6,
      //             ),
      //           ],
      //         ),
      //         width: size.width * 0.28,
      //         height: 50.h,
      //         child: Center(
      //           child: Text(
      //             "Stop",
      //             style: GoogleFonts.inter(
      //               color: Colors.white,
      //               fontSize: 18.h,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //         ),
      //       )
      //       // FloatingActionButton(
      //       //   backgroundColor: Colors.red,
      //       //   onPressed: () {},
      //       //   child: TextButton(onPressed: () {  },
      //       //   child: Text("STOP"),),
      //       // ),
      //     ],
      //   ),
      // ),
    );
    // return Scaffold(
    //   appBar: AppBar(title: const Text("Volume Control")),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         const Icon(Icons.volume_up, size: 50),
    //         Text("Volume: ${_volume.toInt()}%",
    //             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    //         Slider(
    //           value: _volume,
    //           min: 0,
    //           max:50,
    //           divisions: 10,
    //           label: "${_volume.toInt()}%",
    //           onChanged: (value) {
    //             setState(() {
    //               _volume = value;
    //             });
    //           },
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             ElevatedButton(
    //               onPressed: _decreaseVolume,
    //               child: const Icon(Icons.remove),
    //             ),
    //             const SizedBox(width: 20),
    //             ElevatedButton(
    //               onPressed: _increaseVolume,
    //               child: const Icon(Icons.add),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
