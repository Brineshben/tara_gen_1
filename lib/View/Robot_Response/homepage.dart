import 'dart:async';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ihub/Model/background_model.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/api_constant.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/Utils/web_view.dart';
import 'package:ihub/View/Robot_Response/password_page.dart';
import 'package:ihub/View/Settings/settings.dart';
import 'package:lottie/lottie.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/EnquiryListController.dart';
import '../../Controller/Login_api_controller.dart';
import '../../Controller/RobotresponseApi_controller.dart';
import '../../Controller/batteryOfflineController.dart';
import '../../Controller/battery_Controller.dart';
import 'Navigation.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with WidgetsBindingObserver {
  Timer? messageTimer;
  bool canExit = false;
  bool isForegroundTaskRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Get.find<RobotresponseapiController>().getUrl();

    _hideSystemUI();

    Get.find<Enquirylistcontroller>().fetchEnquiryList(
        Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);

    messageTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      Get.find<BatteryController>().fetchBattery(
          Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);

      Get.find<BatteryOfflineController>().fetchOfflineBattery();

      Get.find<BackgroudController>().fetchBackground(
          Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);

      bool? isBatteryscreen = await Get.find<BatteryController>().fetchCharging(
          Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);

      // if (isBatteryscreen ?? false) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => BatterySplash()),
      //   );

      //   timer.cancel();
      // }

      fetchAndUpdateBaseUrl();
      Get.find<RobotresponseapiController>().fetchObsResultList();
    });
  }

  Future<void> fetchBackground(int userID) async {
    Map<String, dynamic> resp = await ApiServices.background(userId: userID);
    if (resp['status'] == "ok") {
      BackgroundModel backgrounddata = BackgroundModel.fromJson(resp);
      final imagePath = backgrounddata.backgroundImage;

      if (imagePath != null) {
        await updateImageColor(imagePath);
      }
    }
  }

  Future<void> updateImageColor(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/temp_image.jpg');

        await tempFile.writeAsBytes(response.bodyBytes);

        final PaletteGenerator paletteGenerator =
            await PaletteGenerator.fromImageProvider(
          FileImage(tempFile),
          size: const Size(200, 200),
          maximumColorCount: 20,
        );

        final dominantColor =
            paletteGenerator.dominantColor?.color ?? Colors.black;
        final brightness = ThemeData.estimateBrightnessForColor(dominantColor);

        Get.find<BatteryController>().foregroundColor.value =
            brightness == Brightness.dark ? Colors.white : Colors.black;

        print("Updated color from URL image: $dominantColor");
      } else {
        print("Image download failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error processing image color: $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive); // Hide status bar again
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
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
                  );
                },
              ),
              GestureDetector(
                onDoubleTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => AboutRobot()),
                  // );
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30, left: 20),
                            child: Container(
                              width: 200,
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.blue),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 30.r,
                                    backgroundColor: Colors.black,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/taraprofile.jpg",
                                        width: 100.w,
                                        height: 100.h,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Stack(
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/logo1.png",
                                        width: 130,
                                      ),
                                      Positioned(
                                        top: 6,
                                        left: 7,
                                        child: Text(
                                          "POWERED BY",
                                          style: TextStyle(
                                            fontSize: 5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Header(
                            isBack: false,
                            screenName: '',
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 100).h,
                        child: Align(
                          alignment: Alignment.center,
                          child: GetX<RobotresponseapiController>(
                            builder: (controller) {
                              bool? listening =
                                  controller.responseData.value.listening;
                              // bool? waiting =  controller.responseData.value.waiting;
                              bool? speaking =
                                  controller.responseData.value.speaking;
                              return SizedBox(
                                height: size.width * 0.25,
                                width: size.width * 0.3,
                                child: Column(
                                  children: [
                                    if (listening == true)
                                      Column(
                                        children: [
                                          Center(
                                            child: Lottie.asset(
                                              "assets/Animation - 1739525563341.json",
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 100.h,
                                            width: 280.w,
                                            child: DefaultTextStyle(
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 30.h,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 5.0,
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      offset: Offset(2, 2),
                                                    ),
                                                  ]),
                                              child: Center(
                                                child: AnimatedTextKit(
                                                  animatedTexts: [
                                                    TypewriterAnimatedText(
                                                      'LISTENING....',
                                                      speed: Duration(
                                                          milliseconds: 50),
                                                      cursor: '|',
                                                    ),
                                                  ],
                                                  repeatForever: true,
                                                  isRepeatingAnimation: true,
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
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 100.h,
                                            width: double.infinity,
                                            child: DefaultTextStyle(
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 30.h,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 5.0,
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                      offset: Offset(2, 2),
                                                    ),
                                                  ]),
                                              // child: Center(
                                              //   child: AnimatedTextKit(
                                              //     animatedTexts: [
                                              //       TypewriterAnimatedText(
                                              //         'SPEAKING....',
                                              //         speed: Duration(
                                              //             milliseconds: 50),
                                              //         // Adjust typing speed
                                              //         cursor:
                                              //             '|', // Optional cursor
                                              //       ),
                                              //     ],
                                              //     repeatForever: true,
                                              //     isRepeatingAnimation: true,
                                              //   ),
                                              // ),

                                              child: Lottie.asset(
                                                  "assets/speaking.json"),
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
                                      // Column(
                                      //   children: [
                                      // Center(
                                      //   child: Lottie.asset(
                                      //     "assets/Animation - 1739525563341.json",
                                      //     fit: BoxFit.fitHeight,
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   height: 100.h,
                                      //   width: 280.w,
                                      //   child: DefaultTextStyle(
                                      //     style: GoogleFonts.poppins(
                                      //         color: Colors.white,
                                      //         fontSize: 30.h,
                                      //         fontWeight: FontWeight.bold,
                                      //         shadows: [
                                      //           Shadow(
                                      //             blurRadius: 5.0,
                                      //             color: Colors.black
                                      //                 .withOpacity(0.7),
                                      //             offset: Offset(2, 2),
                                      //           ),
                                      //         ]),
                                      //     //   child: Center(
                                      //     //     child: AnimatedTextKit(
                                      //     //       animatedTexts: [
                                      //     //         TypewriterAnimatedText(
                                      //     //           'THINKING....',
                                      //     //           speed: Duration(
                                      //     //               milliseconds: 80),
                                      //     //           cursor: '|',
                                      //     //         ),
                                      //     //       ],
                                      //     //       repeatForever: true,
                                      //     //       isRepeatingAnimation: true,
                                      //     //     ),
                                      //     //   ),
                                      //     // ),
                                      //     // ),

                                      //     child: Lottie.asset(
                                      //       "assets/speaking.json",
                                      //       width: 200,
                                      //     ),
                                      //   ),
                                      // )
                                      // ],
                                      // ),

                                      Lottie.asset(
                                        "assets/speaking.json",
                                        width: 200,
                                      ),
                                    controller.robotResponseModel.value?.text !=
                                                null &&
                                            controller.robotResponseModel.value
                                                    ?.text !=
                                                ''
                                        ? Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.black45,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Text(
                                                controller.robotResponseModel
                                                    .value!.text!,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // GetX<Enquirylistcontroller>(
                      //   builder: (Enquirylistcontroller controller) {
                      //     if (controller.isLoading.value) {
                      //       return Container(
                      //         margin: EdgeInsets.only(
                      //             left: 20.w,
                      //             top: 10.h,
                      //             right: 20.w,
                      //             bottom: 350.h),
                      //         child: Wrap(
                      //           spacing: 10.w, // Space between items
                      //           runSpacing: 10.h, // Space between rows
                      //           children: List.generate(
                      //             4, // Number of shimmer placeholders
                      //             (index) => Shimmer.fromColors(
                      //               baseColor: Colors.grey[400]!,
                      //               highlightColor: Colors.grey[200]!,
                      //               child: Column(
                      //                 children: [
                      //                   Container(
                      //                     height:
                      //                         MediaQuery.of(context).size.width *
                      //                             0.06,
                      //                     width:
                      //                         MediaQuery.of(context).size.width *
                      //                             0.06,
                      //                     decoration: BoxDecoration(
                      //                       color: Colors.white,
                      //                       borderRadius:
                      //                           BorderRadius.circular(25.r),
                      //                     ),
                      //                   ),
                      //                   SizedBox(height: 10),
                      //                   Container(
                      //                     width:
                      //                         MediaQuery.of(context).size.width *
                      //                             0.15,
                      //                     height:
                      //                         MediaQuery.of(context).size.height *
                      //                             0.060,
                      //                     decoration: BoxDecoration(
                      //                       color: Colors.white.withOpacity(0.2),
                      //                       borderRadius:
                      //                           BorderRadius.circular(30.r),
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     } else {
                      //       return Container(
                      //         margin: EdgeInsets.only(
                      //             left: 20.w,
                      //             top: 10.h,
                      //             right: 20.w,
                      //             bottom: 350.h),
                      //         child: Wrap(
                      //           spacing: 10.w, // Space between items
                      //           runSpacing: 10.h, // Space between rows
                      //           children: List.generate(
                      //             controller.enquiryData.length,
                      //             // items is your list of data
                      //             (index) => GestureDetector(
                      //               onTap: () {
                      //                 Navigator.push(context, MaterialPageRoute(
                      //                   builder: (context) {
                      //                     return Subcategory(
                      //                       enquiry: controller
                      //                               .enquiryData[index].id ??
                      //                           0,
                      //                       data: controller
                      //                               .enquiryData[index].heading ??
                      //                           "",
                      //                     );
                      //                   },
                      //                 ));
                      //               },
                      //               child: buildInfoCard2(
                      //                   "${controller.enquiryData[index].heading?.toUpperCase()}",
                      //                   "${controller.enquiryData[index].logo}"),
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     }
                      //   },
                      // )
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40, bottom: 20),
                    child: Column(
                      children: [
                        Obx(() {
                          final controller =
                              Get.find<RobotresponseapiController>();
                          return controller.link.value != ''
                              ? Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(40),
                                    onTap: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              InAppWebViewScreen(
                                            url: controller.link.value,
                                          ),
                                        ),
                                      );
                                    },
                                    // child: Ink(
                                    //   padding: const EdgeInsets.all(10),
                                    //   decoration: BoxDecoration(
                                    //     color: Colors.white,
                                    //     borderRadius: BorderRadius.circular(10),
                                    //     border: Border.all(
                                    //         color: Colors.blueGrey.shade200,
                                    //         width: 1),
                                    //   ),
                                    //   child: Column(
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.start,
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceAround,
                                    //     children: [
                                    //       Row(
                                    //         children: [
                                    //           Icon(
                                    //             Icons.language,
                                    //             color: Colors.black,
                                    //             size: 30,
                                    //           ),
                                    //           SizedBox(width: 10),
                                    //           Text(
                                    //             controller.name.value,
                                    //             style: TextStyle(
                                    //               fontSize: 18,
                                    //               fontWeight: FontWeight.bold,
                                    //               color: Colors.black,
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),

                                    child: buildInfoCard(
                                      size,
                                      controller.name.value,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : SizedBox();
                        }),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(40),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return Navigation(
                                    robotid: Get.find<BatteryController>()
                                            .background
                                            .value
                                            ?.data
                                            ?.first
                                            .robot
                                            ?.roboId ??
                                        "",
                                  );
                                },
                              ));
                            },
                            // child: Ink(
                            //   width: 330.h,
                            //   padding: EdgeInsets.all(16),
                            //   decoration: BoxDecoration(
                            //     color: const Color(0xFF0470C8),
                            //     borderRadius: BorderRadius.circular(15),
                            //     border: Border.all(
                            //       color: Colors.grey.shade200,
                            //     ),
                            //   ),
                            // child: Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   mainAxisAlignment:
                            //       MainAxisAlignment.spaceAround,
                            //   children: [
                            //     Row(
                            //       children: [
                            //         Image.asset("assets/arrow.png",
                            //             width: 35),
                            //         SizedBox(width: 20),
                            //         Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //               "NAVIGATIONS",
                            //               style: TextStyle(
                            //                 fontSize: 19.h,
                            //                 fontWeight: FontWeight.bold,
                            //                 color: Colors.black,
                            //               ),
                            //             ),
                            //             Text(
                            //               'Control robot movement',
                            //               style: TextStyle(
                            //                 fontSize: 17.h,
                            //                 color: Colors.black54,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // ),
                            //   child: Center(
                            //     child: Text(
                            //       "NAVIGATIONS",
                            //       style: TextStyle(
                            //         fontSize: 20,
                            //         color: Colors.white,
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //     ),
                            //   ),
                            // ),

                            child: buildInfoCard(
                              size,
                              'NAVIGATIONS',
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, bottom: 20),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () async {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 300),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      PasswordPage(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                        // child: Ink(
                        //   width: 330.h,
                        //   padding: const EdgeInsets.all(16),
                        //   decoration: BoxDecoration(
                        //     color: const Color(0xFF0470C8),
                        //     borderRadius: BorderRadius.circular(15),
                        //     border: Border.all(
                        //       color: Colors.grey.shade200,
                        //     ),
                        //   ),
                        // child: Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     Row(
                        //       children: [
                        //         Image.asset("assets/management.png",
                        //             width: 35),
                        //         SizedBox(width: 20),
                        //         Column(
                        //           crossAxisAlignment:
                        //               CrossAxisAlignment.start,
                        //           children: [
                        //             Text(
                        //               "SETTINGS",
                        //               style: TextStyle(
                        //                 fontSize: 19.h,
                        //                 fontWeight: FontWeight.bold,
                        //                 color: Colors.black,
                        //               ),
                        //             ),
                        //             Text(
                        //               'Manage robot preferences',
                        //               style: TextStyle(
                        //                 fontSize: 17.h,
                        //                 color: Colors.black54,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        // ),
                        child: buildInfoCard(
                          size,
                          "SETTINGS",
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget buildInfoCard2(String title, String image) {
    final Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
            height: size.width * 0.06,
            width: size.width * 0.06,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.r),
              child: CachedNetworkImage(
                width: double.infinity,
                height: double.infinity,
                imageUrl: image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Image.asset(
                  "assets/homelogo.jpg",
                  fit: BoxFit.fitWidth,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  "assets/homelogo.jpg",
                  fit: BoxFit.fitWidth,
                ),
              ),
            )),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30.r),
          ),
          width: size.width * 0.15,
          height: size.height * 0.060,
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 15.h,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
