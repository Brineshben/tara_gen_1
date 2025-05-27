import 'dart:async';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/RobotresponseApi_controller.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/View/Robot_Response/homepage.dart';
import 'package:lottie/lottie.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/Navigate_Controller.dart';
import '../../Controller/Response_Nav_Controller.dart';
import '../../Service/Api_Service.dart';
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
    messageTimer?.cancel();
    messageTimer = Timer.periodic(Duration(seconds: 5), (timer) {
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
            SingleChildScrollView(
              child: GetX<NavigateController>(
                builder: (NavigateController controller) {
                  return Column(
                    children: [
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
                          : controller.dataList.isNotEmpty
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
                                            // bool? waiting = controller
                                            //     .responseData.value.waiting;
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
                                                                            0.2),
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
                                                    )
                                                  else if (speaking == true)
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
                                                        // Align(
                                                        //   alignment: Alignment.bottomCenter,
                                                        //   child: Padding(
                                                        //     padding: EdgeInsets.only(bottom: 20.h),
                                                        //     child: GestureDetector(
                                                        //       onTap: () async {
                                                        //         try {
                                                        //           Map<String, dynamic> resp =
                                                        //               await ApiServices.stopTalk(
                                                        //                   status: true);
                                                        //
                                                        //           ProductAppPopUps.submit(
                                                        //             title: "Update",
                                                        //             message: resp['message'] ??
                                                        //                 "Something went wrong.",
                                                        //             actionName: "Close",
                                                        //             iconData: Icons.done,
                                                        //             iconColor: Colors.green,
                                                        //           );
                                                        //         } catch (e) {}
                                                        //       },
                                                        //       child: Container(
                                                        //         decoration: BoxDecoration(
                                                        //           color: Colors.red,
                                                        //           borderRadius:
                                                        //               BorderRadius.circular(20.r),
                                                        //           boxShadow: [
                                                        //             BoxShadow(
                                                        //               color: Colors.black
                                                        //                   .withOpacity(0.2),
                                                        //               spreadRadius: 1,
                                                        //               blurRadius: 6,
                                                        //             ),
                                                        //           ],
                                                        //         ),
                                                        //         width: 100.w,
                                                        //         height: 50.h,
                                                        //         child: Center(
                                                        //           child: Text(
                                                        //             "STOP",
                                                        //             style: GoogleFonts.orbitron(
                                                        //               color: Colors.white,
                                                        //               fontSize: 18.h,
                                                        //               fontWeight: FontWeight.bold,
                                                        //             ),
                                                        //           ),
                                                        //         ),
                                                        //       ),
                                                        //     ),
                                                        //   ),
                                                        // )
                                                      ],
                                                    )
                                                  else
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
                                                                            80),
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
                                                        color: Colors.black
                                                            .withOpacity(0.4),
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
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        Wrap(
                                          children: List.generate(
                                            controller.dataList.length,
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
                                                                      .dataList[
                                                                          index]
                                                                      ?.id ??
                                                                  0);

                                                          print(
                                                              'ididididididi ${controller.dataList[index]?.id}');

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
                                                                  "Heading to the ${controller.dataList[index]?.name}"
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
                                                        "${controller.dataList[index]?.name}")),
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
            Column(
              children: [
                Header(
                  isBack: true,
                  screenName: "NAVIGATIONS",
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      highlightColor: Colors.blue,
                      onTap: () async {
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
                            );

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
                      child: Ink(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.blueGrey.shade200, width: 1),
                        ),
                        // child: Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     Row(
                        //       children: [
                        //         Image.asset("assets/destination11.png",
                        //             width: 30),
                        //         SizedBox(width: 20),
                        //         Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Text(
                        //               "FULL TOUR",
                        //               style: TextStyle(
                        //                 fontSize: 16.h,
                        //                 fontWeight: FontWeight.bold,
                        //                 color: Colors.black,
                        //               ),
                        //             ),
                        //             Text(
                        //               'Robot Navigate to places',
                        //               style: TextStyle(
                        //                   fontSize: 16.h,
                        //                   // fontStyle: FontStyle.italic,
                        //                   color: Colors.black54,
                        //                   fontWeight: FontWeight.bold),
                        //             ),
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        child: Center(
                          child: Text(
                            "FULL TOUR",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    spacing: 20,
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
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  width: 300,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Lottie.asset(
                                        "assets/home.json",
                                        width: 100,
                                        height: 100,
                                        repeat: true,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Navigate Home?",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Do you want to send the robot to the home location now?",
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
                                              navigateToLocationByName('home');
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                            ),
                                            child: const Text(
                                              "Yes, Start",
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                Lottie.asset("assets/home.json"),
                                Text(
                                  "HOME",
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
                                              final responce = await ApiServices
                                                  .setChargingStatus(true);
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
                                              style: TextStyle(
                                                  color: Colors.white),
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
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  void navigateToLocationByName(String name) async {
    try {
      final controller = Get.find<NavigateController>();

      final item = controller.dataList.firstWhere(
        (e) => e?.name?.toLowerCase() == name.toLowerCase(),
        orElse: () => null,
      );

      if (item == null) {
        ProductAppPopUps.submit(
          title: "NOT FOUND",
          message: "$name location not found.",
          actionName: "Close",
          iconData: Icons.info_outline,
          iconColor: Colors.orange,
        );
        return;
      }

      await ApiServices.destination(id: item.id ?? 0);
      await Future.delayed(Duration(seconds: 2));

      final resp = await ApiServices.robotbasestatus();
      final bool status = resp['status'] == true;
      final String message =
          status ? "Heading to ${item.name}" : "Command already received";

      Get.dialog(
        AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            children: [
              Center(
                child: SizedBox(
                  width: 180.w,
                  height: 180.h,
                  child: Lottie.asset("assets/navigate.json"),
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
            message.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.oxygen(
              color: Colors.black,
              fontSize: 15.h,
            ),
          ),
        ),
      );

      Future.delayed(Duration(seconds: 3), () {
        if (Get.isDialogOpen ?? false) Get.back();
        if (Get.isDialogOpen ?? false) Get.back();
      });
    } catch (e) {
      ProductAppPopUps.submit(
        title: "FAILED",
        message: "Something went wrong.",
        actionName: "Close",
        iconData: Icons.info_outline,
        iconColor: Colors.red,
      );
      print("Error: ${e.toString()}");
    }
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
              style: GoogleFonts.poppins(
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
