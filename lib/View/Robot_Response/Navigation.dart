import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/RobotresponseApi_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/View/Home_Screen/battery_Widget.dart';
import 'package:lottie/lottie.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/Navigate_Controller.dart';
import '../../Controller/Response_Nav_Controller.dart';
import '../../Service/Api_Service.dart';
import '../../Utils/colors.dart';
import '../../Utils/popups.dart';

class Navigation extends StatefulWidget {
  final String robotid;

  const Navigation({
    super.key,
    required this.robotid,
  });

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  Timer? messageTimer;

  void startMessageTimer() {
    messageTimer
        ?.cancel(); // Cancel any existing timer before starting a new one

    messageTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      print("------isDialogOpen--------${Get.isDialogOpen}");

      if (!(Get.isDialogOpen ?? false) &&
          !Get.find<ResponseNavController>().isLoading.value) {
        Get.find<ResponseNavController>().fetchresponsenav(widget.robotid);
      }
    });
  }

  void stopMessageTimer() {
    messageTimer?.cancel();
  }

  @override
  void initState() {
    _hideSystemUI();
    startMessageTimer();
    Get.find<NavigateController>().navigateData();
    // Get.find<NavigateController>().NavigateData(
    //     Get
    //         .find<UserAuthController>()
    //         .loginData
    //         .value
    //         ?.user
    //         ?.id ?? 0);

    // messageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
    //
    //   print("------isDialogOpen--------${Get.isDialogOpen}");
    //   messageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
    //
    //     if (!(Get.isDialogOpen ?? true)) {
    //       Get.find<ResponseNavController>().fetchresponsenav("RB3");                }
    //   });
    //
    // }
    // WidgetsBinding.instance.addPostFrameCallback(
    //       (timeStamp) {
    //     messageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
    //
    //       print("------isDialogOpen--------${Get.isDialogOpen}");
    //       if (!(Get.isDialogOpen ?? true)) {
    //         Get.find<ResponseNavController>().fetchresponsenav("RB3");                }
    //     });
    //   },
    // );
    // if (!(Get.isDialogOpen ?? true)) {
    // }

    super.initState();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive); // Hide status bar again
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
                  child: CachedNetworkImage(
                    imageUrl:
                        controller.backgroundModel.value?.backgroundImage ?? "",
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Image.asset(controller.defaultIMage, fit: BoxFit.cover),
                    errorWidget: (context, url, error) =>
                        Image.asset(controller.defaultIMage, fit: BoxFit.cover),
                  ),
                );
              },
            ),
            SingleChildScrollView(
              child: GetX<NavigateController>(
                builder: (NavigateController controller) {
                  return Column(
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.only(left: 20),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.end,
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: [
                      //           GestureDetector(
                      //             onTap: () {
                      //               Navigator.pop(context);
                      //             },
                      //             child: Container(
                      //               height: 60.h,
                      //               width: 60.h,
                      //               decoration: BoxDecoration(
                      //                   color: Colors.black.withOpacity(0.2),
                      //                   borderRadius:
                      //                       BorderRadius.circular(15).r),
                      //               child: Icon(
                      //                 Icons.arrow_back_outlined,
                      //                 color: Colors.black,
                      //               ),
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             width: 10,
                      //           ),
                      //           Center(
                      //             child: Text(
                      //               "NAVIGATION",
                      //               style: GoogleFonts.oxygen(
                      //                   color: Colors.black,
                      //                   fontSize: 25.h,
                      //                   fontWeight: FontWeight.w700),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       Spacer(),
                      //       GetX<BatteryController>(
                      //         builder: (BatteryController controller) {
                      //           Color? roboColor = controller.background.value
                      //                       ?.data?.first.robot?.map !=
                      //                   null
                      //               ? (controller.background.value?.data?.first
                      //                           .robot?.map ??
                      //                       false)
                      //                   ? Colors.green
                      //                   : Colors.red
                      //               : null;
                      //           return Row(
                      //             children: [
                      //               // Container(
                      //               //   margin: EdgeInsets.only(
                      //               //       left: 10.w, top: 40.h, right: 10.w),
                      //               //   decoration: BoxDecoration(
                      //               //     color: Colors.white.withOpacity(0.2),
                      //               //     borderRadius:
                      //               //         BorderRadius.circular(20.r),
                      //               //   ),
                      //               //   width: size.height * 0.1,
                      //               //   height: size.height * 0.070,
                      //               //   child: Center(
                      //               //     child: SizedBox(
                      //               //       child: Padding(
                      //               //         padding: const EdgeInsets.all(8.0),
                      //               //         child: Lottie.asset(
                      //               //           "assets/emergency.json",
                      //               //           fit: BoxFit.fitHeight,
                      //               //         ),
                      //               //       ),
                      //               //     ),
                      //               //   ),
                      //               // ),
                      //               if (controller.background.value?.data?.first
                      //                       .robot?.motorBrakeReleased ??
                      //                   false)
                      //                 Center(
                      //                   child: Container(
                      //                       margin: EdgeInsets.only(
                      //                           left: 10.w,
                      //                           top: 40.h,
                      //                           right: 10.w),
                      //                       height: size.height * 0.060,
                      //                       width: size.width * 0.060,
                      //                       child: Image.asset(
                      //                           "assets/brake.png",
                      //                           fit: BoxFit.contain)),
                      //                 ),
                      //               if (controller.background.value?.data?.first
                      //                       .robot?.emergencyStop ??
                      //                   false)
                      //                 Container(
                      //                   margin: EdgeInsets.only(
                      //                       left: 1.w, top: 40.h, right: 1.w),
                      //                   child: Center(
                      //                     child: Container(
                      //                       height: size.height * 0.060,
                      //                       width: size.width * 0.060,
                      //                       child: SvgPicture.asset(
                      //                         "assets/alert-icon-orange.svg",
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               Container(
                      //                 margin:
                      //                     EdgeInsets.only(top: 35, right: 150),
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.black.withOpacity(0.2),

                      //                   // gradient: LinearGradient(
                      //                   //   colors: [Colors.blue, Colors.purple], // Define gradient colors
                      //                   //   begin: Alignment.topLeft,
                      //                   //   end: Alignment.bottomRight,
                      //                   // ),
                      //                   borderRadius:
                      //                       BorderRadius.circular(30.r),
                      //                   // boxShadow: [
                      //                   //   BoxShadow(
                      //                   //     color: Colors.white,
                      //                   //     spreadRadius: 0.01,
                      //                   //     offset: Offset(0, 0),
                      //                   //   ),
                      //                   // ],
                      //                 ),
                      //                 width: size.width * 0.15,
                      //                 height: size.height * 0.060,
                      //                 child: Center(
                      //                   child: Row(
                      //                     children: [
                      //                       Padding(
                      //                         padding:
                      //                             const EdgeInsets.all(8.0),
                      //                         child: Container(
                      //                           height: size.height * 0.060,
                      //                           width: size.width * 0.060,
                      //                           child: SvgPicture.asset(
                      //                             "assets/reshot-icon-map-marker-KS456ZT2P3.svg",
                      //                             color: roboColor,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       Text(
                      //                         "Q: ${controller.background.value?.data?.first.robot?.quality} ",
                      //                         style: GoogleFonts.roboto(
                      //                           color: Colors.white,
                      //                           fontSize: 15.h,
                      //                           fontWeight: FontWeight.bold,
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           );
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      controller.isLoading.value
                          ? Center(
                              child: SizedBox(
                                height: 500,
                                width: 200,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            )
                          : controller.DataList.isNotEmpty
                              ? SingleChildScrollView(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 100),
                                        GetX<RobotresponseapiController>(
                                          builder: (controller) {
                                            bool? listening = controller
                                                .responseData.value.listening;
                                            bool? waiting = controller
                                                .responseData.value.waiting;
                                            bool? speaking = controller
                                                .responseData.value.speaking;
                                            return SizedBox(
                                              // height: size.width * 0.25,
                                              width: size.width * 0.3,
                                              child: Column(
                                                children: [
                                                  if (listening == true)
                                                    Column(
                                                      children: [
                                                        Center(
                                                          child: Lottie.asset(
                                                            "assets/Animation - 1739525563341.json",
                                                            fit: BoxFit
                                                                .fitHeight,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 100.h,
                                                          width: 280.w,
                                                          child:
                                                              DefaultTextStyle(
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        30.h,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    shadows: [
                                                                  Shadow(
                                                                    blurRadius:
                                                                        5.0,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.7),
                                                                    offset:
                                                                        Offset(
                                                                            2,
                                                                            2),
                                                                  ),
                                                                ]),
                                                            child: Center(
                                                              child:
                                                                  AnimatedTextKit(
                                                                animatedTexts: [
                                                                  TypewriterAnimatedText(
                                                                    'LISTENING....',
                                                                    speed: Duration(
                                                                        milliseconds:
                                                                            50),
                                                                    cursor: '|',
                                                                  ),
                                                                ],
                                                                repeatForever:
                                                                    true,
                                                                isRepeatingAnimation:
                                                                    true,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (waiting == true)
                                                    Column(
                                                      children: [
                                                        Center(
                                                          child: Lottie.asset(
                                                            "assets/Animation - 1739525563341.json",
                                                            fit: BoxFit
                                                                .fitHeight,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 100.h,
                                                          width: 280.w,
                                                          child:
                                                              DefaultTextStyle(
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        30.h,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    shadows: [
                                                                  Shadow(
                                                                    blurRadius:
                                                                        5.0,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.7),
                                                                    offset:
                                                                        Offset(
                                                                            2,
                                                                            2),
                                                                  ),
                                                                ]),
                                                            child: Center(
                                                              child:
                                                                  AnimatedTextKit(
                                                                animatedTexts: [
                                                                  TypewriterAnimatedText(
                                                                    'THINKING....',
                                                                    speed: Duration(
                                                                        milliseconds:
                                                                            50),
                                                                    cursor: '|',
                                                                  ),
                                                                ],
                                                                repeatForever:
                                                                    true,
                                                                isRepeatingAnimation:
                                                                    true,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (speaking == true)
                                                    Column(
                                                      children: [
                                                        Center(
                                                          child: Lottie.asset(
                                                            "assets/Animation - 1739525563341.json",
                                                            fit: BoxFit
                                                                .fitHeight,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 100.h,
                                                          width:
                                                              double.infinity,
                                                          child:
                                                              DefaultTextStyle(
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        30.h,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    shadows: [
                                                                  Shadow(
                                                                    blurRadius:
                                                                        5.0,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.7),
                                                                    offset:
                                                                        Offset(
                                                                            2,
                                                                            2),
                                                                  ),
                                                                ]),
                                                            child: Center(
                                                              child:
                                                                  AnimatedTextKit(
                                                                animatedTexts: [
                                                                  TypewriterAnimatedText(
                                                                    'SPEAKING....',
                                                                    speed: Duration(
                                                                        milliseconds:
                                                                            50),
                                                                    // Adjust typing speed
                                                                    cursor:
                                                                        '|', // Optional cursor
                                                                  ),
                                                                ],
                                                                repeatForever:
                                                                    true,
                                                                isRepeatingAnimation:
                                                                    true,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  if (controller
                                                              .robotResponseModel
                                                              .value
                                                              ?.text !=
                                                          "" &&
                                                      listening == true)
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        color: Colors.blueGrey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          controller
                                                                  .robotResponseModel
                                                                  .value
                                                                  ?.text ??
                                                              "",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    )
                                                  else if (speaking == true ||
                                                      waiting == true)
                                                    SizedBox(),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        Wrap(
                                          children: List.generate(
                                            controller.DataList.length,
                                            (index) => Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                    splashColor: Colors.white,
                                                    highlightColor: Colors.white
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r),
                                                    onTap: () async {
                                                      {
                                                        try {
                                                          await ApiServices.destination(
                                                              id: controller
                                                                      .DataList[
                                                                          index]
                                                                      ?.id ??
                                                                  0);

                                                          print(
                                                              'ididididididi ${controller.DataList[index]?.id}');

                                                          await Future.delayed(
                                                              Duration(
                                                                  seconds: 2));

                                                          Map<String, dynamic>
                                                              resp =
                                                              await ApiServices
                                                                  .robotbasestatus();

                                                          if (resp['status'] ==
                                                              true) {
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();

                                                            Get.dialog(
                                                              AlertDialog(
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20.0)),
                                                                ),
                                                                title: Column(
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            180.w,
                                                                        height:
                                                                            180.h,
                                                                        child: Lottie
                                                                            .asset(
                                                                          "assets/navigate.json",
                                                                          fit: BoxFit
                                                                              .fitHeight,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "COMMAND RECEIVED",
                                                                      style: GoogleFonts
                                                                          .orbitron(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            20.h,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                content: Text(
                                                                  "Heading to the ${controller.DataList[index]?.name}"
                                                                      .toUpperCase(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      GoogleFonts
                                                                          .oxygen(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15.h,
                                                                  ),
                                                                ),
                                                              ),
                                                            );

                                                            Future.delayed(
                                                                const Duration(
                                                                    seconds: 3),
                                                                () {
                                                              if (Get.isDialogOpen ??
                                                                  false) {
                                                                Get.back();
                                                                Get.back();
                                                              }
                                                            });
                                                          } else {
                                                            Get.dialog(
                                                              AlertDialog(
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20.0)),
                                                                ),
                                                                title: Column(
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            180.w,
                                                                        height:
                                                                            180.h,
                                                                        child: Lottie
                                                                            .asset(
                                                                          "assets/navigate.json",
                                                                          fit: BoxFit
                                                                              .fitHeight,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "COMMAND RECEIVED",
                                                                      style: GoogleFonts
                                                                          .orbitron(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            20.h,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                content: Text(
                                                                  "COMMAND ALREADY RECEIVED"
                                                                      .toUpperCase(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      GoogleFonts
                                                                          .oxygen(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15.h,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                            Future.delayed(
                                                                const Duration(
                                                                    seconds: 3),
                                                                () {
                                                              if (Get.isDialogOpen ??
                                                                  false) {
                                                                Get.back();
                                                                Get.back();
                                                              }
                                                            });
                                                          }
                                                        } catch (e) {
                                                          ProductAppPopUps
                                                              .submit(
                                                            title: "FAILED",
                                                            message:
                                                                "Something went wrong.",
                                                            actionName: "Close",
                                                            iconData: Icons
                                                                .info_outline,
                                                            iconColor:
                                                                Colors.red,
                                                          );
                                                          print(
                                                              "------forgot error-----------${e.toString()}");
                                                        }
                                                      }
                                                    },
                                                    child: buildInfoCard2(
                                                        "${controller.DataList[index]?.name}")),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 500,
                                      ),
                                      Text(
                                        "Oops..No Data Found in Destination List..",
                                        style: GoogleFonts.poppins(
                                            color: Colors.red,
                                            fontSize: 20.h,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                ),
                    ],
                  );
                },
              ),
            ),
            // Positioned(
            //   right: 0,
            //   child: GetX<BatteryController>(
            //     builder: (BatteryController controller) {
            //       int? batteryLevel;

            //       batteryLevel = int.tryParse(controller.background.value?.data
            //                   ?.first.robot?.batteryStatus ??
            //               "0") ??
            //           0;

            //       print("batettegdshgfcdshuf$batteryLevel");

            //       return BatteryIcon(
            //         batteryLevel: batteryLevel,
            //       );
            //     },
            //   ),
            // ),
            Column(
              children: [
                Header(
                  isBack: true,
                  screenName: "Navigations",
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15.r),
                  onTap: () async {
                    Get.dialog(
                      Dialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: 300,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Lottie.asset(
                                'assets/char.json',
                                width: 100,
                                height: 100,
                                repeat: true,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Start Charging Dock?",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Do you want to send the robot to the charging dock now?",
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
                                      final responce =
                                          await ApiServices.setChargingStatus(
                                              true);
                                      if (responce['status'] == true) {
                                        Get.back();
                                        Get.back();
                                      }
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
                        Lottie.asset("assets/char.json"),
                        Text(
                          "CHARGE",
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
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorUtils.userdetailcolor,
                        ColorUtils.userdetailcolor
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(
                        10), // Ensure proper border radius
                  ),
                  child: Material(
                    color: Colors.transparent, // Ensure the gradient is visible
                    borderRadius: BorderRadius.circular(10),
                    child: FloatingActionButton.extended(
                      backgroundColor: Colors.transparent,
                      onPressed: () async {
                        try {
                          Map<String, dynamic> resp =
                              await ApiServices.FulltourNavigation(Data: true);

                          if (resp['status'] == "ok") {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Get.dialog(
                              AlertDialog(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                title: Column(
                                  children: [
                                    Center(
                                      child: SizedBox(
                                        width: 180.w,
                                        height: 180.h,
                                        child: Lottie.asset(
                                          "assets/navigate.json",
                                          fit: BoxFit.fitHeight,
                                        ),
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
                                  "Full Tour Mode Activated ".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.oxygen(
                                    color: Colors.black,
                                    fontSize: 15.h,
                                  ),
                                ),
                              ),
                            ).then((_) {});

                            Future.delayed(const Duration(seconds: 3), () {
                              if (Get.isDialogOpen ?? false) {
                                Get.back();
                              }
                            });
                          } else {
                            ProductAppPopUps.submit(
                              title: "FAILED",
                              message: "Something went wrong.",
                              actionName: "Close",
                              iconData: Icons.info_outline,
                              iconColor: Colors.red,
                            );
                          }
                        } catch (e) {
                          ProductAppPopUps.submit(
                            title: "FAILED",
                            message: "Response Not recived From Robot",
                            actionName: "Close",
                            iconData: Icons.info_outline,
                            iconColor: Colors.red,
                          );
                        }
                      },
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                      label: Text("FULL TOUR",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18.h,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildInfoCard2(String title) {
    final Size size = MediaQuery.of(context).size;
    return Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.blueGrey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 0.01,
            offset: Offset(0, 0),
          ),
        ],
      ),
      width: size.width * 0.28,
      height: size.height * 0.080,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              title.toUpperCase(),
              style: GoogleFonts.orbitron(
                color: Colors.black,
                fontSize: 18.h,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
