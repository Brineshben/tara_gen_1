import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Utils/api_constant.dart';
import 'package:ihub/View/Robot_Response/password_page.dart';
import 'package:ihub/View/Settings/About_robot.dart';
import 'package:ihub/View/Settings/settings.dart';
import 'package:ihub/View/Splash/Battery_Splash.dart';
import 'package:lottie/lottie.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/EnquiryListController.dart';
import '../../Controller/Login_api_controller.dart';
import '../../Controller/RobotresponseApi_controller.dart';
import '../../Controller/batteryOfflineController.dart';
import '../../Controller/battery_Controller.dart';
import '../../Utils/colors.dart';
import '../Home_Screen/battery_Widget.dart';
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

    Get.find<BackgroudController>().fetchBackground(
        Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);

    messageTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      print("Timer");
      Get.find<BatteryController>().fetchBattery(
          Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);

      Get.find<BatteryOfflineController>().fetchOfflineBattery();

      Get.find<BackgroudController>().fetchBackground(
          Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);

      bool? isBatteryscreen = await Get.find<BatteryController>().fetchCharging(
          Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);

      if (isBatteryscreen ?? false) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const BatterySplash();
          },
        ));
        timer.cancel();
      }
      fetchAndUpdateBaseUrl();
      Get.find<RobotresponseapiController>().fetchObsResultList();
    });
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
                      placeholder: (context, url) =>
                          Image.asset("assets/images.jpg", fit: BoxFit.cover),
                      errorWidget: (context, url, error) =>
                          Image.asset("assets/images.jpg", fit: BoxFit.cover),
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
                      GetX<BatteryController>(
                        builder: (BatteryController controller) {
                          Color? roboColor;
                          // int? batteryLevel;
                          // String? data;
                          String? quality;
                          bool? brake;
                          bool? EmergencyStop;
                          if (controller.background.value?.data!.isNotEmpty ??
                              false) {
                            roboColor = controller.background.value?.data?.first
                                        .robot?.map !=
                                    null
                                ? (controller.background.value?.data?.first
                                            .robot?.map ??
                                        false)
                                    ? Colors.green
                                    : Colors.red
                                : null;

                            quality = controller.background.value?.data?.first
                                    .robot?.quality ??
                                "";
                            brake = controller.background.value?.data?.first
                                .robot?.motorBrakeReleased;

                            EmergencyStop = controller.background.value?.data
                                ?.first.robot?.emergencyStop;
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 10.w,
                                      top: 40.h,
                                      right: 10.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    width: size.width * 0.15,
                                    height: size.height * 0.070,
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, top: 8, bottom: 8),
                                            child: Container(
                                              height: size.height * 0.060,
                                              width: size.width * 0.060,
                                              child: SvgPicture.asset(
                                                  "assets/reshot-icon-map-marker-KS456ZT2P3.svg",
                                                  color: roboColor),
                                            ),
                                          ),
                                          Text(
                                            "Q: ${quality ?? 0}",
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 15.h,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (EmergencyStop ?? false)
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 1.w, top: 40.h, right: 1.w),
                                      child: Center(
                                        child: Container(
                                          height: size.height * 0.060,
                                          width: size.width * 0.060,
                                          child: SvgPicture.asset(
                                            "assets/alert-icon-orange.svg",
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (brake ?? false)
                                    Center(
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: 10.w,
                                              top: 40.h,
                                              right: 10.w),
                                          height: size.height * 0.060,
                                          width: size.width * 0.060,
                                          child: Image.asset("assets/brake.png",
                                              fit: BoxFit.contain)),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: InkWell(
                                      onTap: () async {
                                        final Uri url = Uri.parse(
                                          'http://192.168.11.2/admin/index.html#/functions/wifi/client?freq=5GHz',
                                        );
                                        await launchUrl(
                                          url,
                                          mode: LaunchMode.inAppWebView,
                                        );
                                      },
                                      child: Center(
                                        child: Icon(
                                          Icons.router,
                                          size: 40,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              GetX<BatteryController>(
                                builder: (BatteryController controller) {
                                  int? batteryLevel;

                                  batteryLevel = int.tryParse(controller
                                              .background
                                              .value
                                              ?.data
                                              ?.first
                                              .robot
                                              ?.batteryStatus ??
                                          "0") ??
                                      0;

                                  print("batettegdshgfcdshuf$batteryLevel");

                                  return BatteryIcon(
                                    batteryLevel: batteryLevel,
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 100).h,
                        child: Align(
                          alignment: Alignment.center,
                          child: GetX<RobotresponseapiController>(
                            builder: (controller) {
                              bool? listening =
                                  controller.responseData.value.listening;
                              bool? waiting =
                                  controller.responseData.value.waiting;
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
                                              style: GoogleFonts.orbitron(
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
                                      ),
                                    if (waiting == true)
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
                                              style: GoogleFonts.orbitron(
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
                                              child: Center(
                                                child: AnimatedTextKit(
                                                  animatedTexts: [
                                                    TypewriterAnimatedText(
                                                      'THINKING....',
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
                                      ),
                                    if (speaking == true)
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
                                              style: GoogleFonts.orbitron(
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
                                              child: Center(
                                                child: AnimatedTextKit(
                                                  animatedTexts: [
                                                    TypewriterAnimatedText(
                                                      'SPEAKING....',
                                                      speed: Duration(
                                                          milliseconds: 50),
                                                      // Adjust typing speed
                                                      cursor:
                                                          '|', // Optional cursor
                                                    ),
                                                  ],
                                                  repeatForever: true,
                                                  isRepeatingAnimation: true,
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
          floatingActionButton: Container(
            margin: EdgeInsets.only(
                left: 30.w, top: 120.h, right: 20.w, bottom: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final controller = Get.find<RobotresponseapiController>();
                      return controller.link.value != ''
                          ? Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    ColorUtils.userdetailcolor,
                                    ColorUtils.userdetailcolor,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                child: FloatingActionButton.extended(
                                  heroTag: "link_btn",
                                  backgroundColor: Colors.transparent,
                                  onPressed: () async {
                                    final Uri url =
                                        Uri.parse(controller.link.value);
                                    await launchUrl(
                                      url,
                                      mode: LaunchMode.inAppWebView,
                                    );
                                  },
                                  icon:
                                      Icon(Icons.language, color: Colors.white),
                                  label: Text(
                                    controller.name.value,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18.h,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(); // Use SizedBox() instead of Text("") for better UI handling
                    }),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        highlightColor: Colors.blue,
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
                        child: Ink(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.blueGrey.shade200, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/navigatioin.png",
                                      width: 30),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "NAVIGATIONS",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Control robot movement',
                                        style: TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     gradient: const LinearGradient(
                //       colors: [
                //         ColorUtils.userdetailcolor,
                //         ColorUtils.userdetailcolor
                //       ],
                //       begin: Alignment.topLeft,
                //       end: Alignment.bottomRight,
                //     ),
                //     borderRadius: BorderRadius.circular(
                //         10), // Ensure proper border radius
                //   ),
                //   child: Material(
                //     color: Colors.transparent, // Ensure the gradient is visible
                //     borderRadius: BorderRadius.circular(10),
                //     child: FloatingActionButton.extended(
                //       heroTag: "settings_btn",
                //       backgroundColor: Colors.transparent,
                //       onPressed: () {
                //         Navigator.push(
                //           context,
                //           PageRouteBuilder(
                //             transitionDuration: Duration(milliseconds: 300),
                //             pageBuilder:
                //                 (context, animation, secondaryAnimation) =>
                //                     PasswordPage(),
                //             transitionsBuilder: (context, animation,
                //                 secondaryAnimation, child) {
                //               return FadeTransition(
                //                   opacity: animation, child: child);
                //             },
                //           ),
                //         );
                //         // Navigator.push(context, MaterialPageRoute(
                //         //   builder: (context) {
                //         //     return otp();
                //         //   },
                //         // ));
                //       },
                //       icon: Icon(Icons.settings, color: Colors.white),
                //       label: Text("SETTINGS ",
                //           style: GoogleFonts.poppins(
                //             color: Colors.white,
                //             fontSize: 18.h,
                //             fontWeight: FontWeight.bold,
                //           )),
                //     ),
                //   ),
                // ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        highlightColor: Colors.blue,
                        onTap: () {
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
                        child: Ink(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.blueGrey.shade200, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/setting.png", width: 30),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "SETTINGS",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Manage robot preferences',
                                        style: TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
