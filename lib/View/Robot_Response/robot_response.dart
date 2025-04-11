import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/View/Robot_Response/subcategory.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/EnquiryListController.dart';
import '../../Controller/EnquirySubListModel.dart';
import '../../Controller/Login_api_controller.dart';
import '../../Controller/RobotresponseApi_controller.dart';
import '../../Controller/battery_Controller.dart';
import '../../Utils/api_constant.dart';
import '../../Utils/colors.dart';
import '../../Utils/popups.dart';
import '../Home_Screen/SplashScreen.dart';
import '../Home_Screen/battery_Widget.dart';
import '../Home_Screen/home_page.dart';
import '../Settings/maintanance.dart';
import '../Settings/otp_page.dart';
import '../Splash/Battery_Splash.dart';
import '../Splash/Loading_Splash.dart';
import 'Navigation.dart';

class RobotResponse extends StatefulWidget {
  const RobotResponse({Key? key}) : super(key: key);

  @override
  State<RobotResponse> createState() => _RobotResponseState();
}

class _RobotResponseState extends State<RobotResponse>
    with WidgetsBindingObserver {
  Timer? messageTimer;
  bool canExit = false;
  bool isForegroundTaskRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _hideSystemUI();

    Get.find<Enquirylistcontroller>().fetchEnquiryList(
        Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);
    Get.find<BackgroudController>().fetchBackground(
        Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);
    messageTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      print("Timer");
      Get.find<BatteryController>().fetchBattery(
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
      // onWillPop: () async => canExit,

      // onWillPop: () async {
      //   if (allowExit) {
      //     return true;
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(content: Text("You cannot exit the app manually!")));
      //     return false; // Prevent app from closing
      //   }
      // },
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
                          controller.background.value?.backgroundImage ?? "",
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Image.asset("assets/images.jpg", fit: BoxFit.cover),
                      errorWidget: (context, url, error) =>
                          Image.asset("assets/images.jpg", fit: BoxFit.cover),
                    ),
                  );
                },
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GetX<BatteryController>(
                      builder: (BatteryController controller) {
                        Color? roboColor;
                        int? batteryLevel;
                        String? data;
                        String? quality;
                        bool? brake;
                        bool? EmergencyStop;
                        if (controller.background.value?.data!.isNotEmpty ??
                            false) {
                          roboColor = controller.background.value?.data?.first
                                      .robot?.map !=
                                  null
                              ? (controller.background.value?.data?.first.robot
                                          ?.map ??
                                      false)
                                  ? Colors.green
                                  : Colors.red
                              : null;

                          batteryLevel = int.tryParse(controller.background
                                      .value?.data?.first.robot?.batteryStatus
                                      .toString() ??
                                  '0') ??
                              0;
                          data = controller.background.value?.data?.first.robot
                                  ?.batteryStatus ??
                              "";
                          quality = controller.background.value?.data?.first
                                  .robot?.quality ??
                              "";
                          brake = controller.background.value?.data?.first.robot
                              ?.motorBrakeReleased;

                          EmergencyStop = controller.background.value?.data
                              ?.first.robot?.emergencyStop;
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return LoadingSplash();
                                      },
                                    ));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 10.w, top: 40.h, right: 10.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    width: size.width * 0.15,
                                    height: size.height * 0.060,
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
                                            "Q: $quality ",
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
                                            left: 10.w, top: 40.h, right: 10.w),
                                        height: size.height * 0.060,
                                        width: size.width * 0.060,
                                        child: Image.asset("assets/brake.png",
                                            fit: BoxFit.contain)),
                                  ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 20.w, top: 40.h, right: 10.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      BatteryIcon(
                                        batteryLevel: batteryLevel ?? 0,
                                      ), // Updated widget

                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        data ?? "",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.h),
                                      )
                                    ],
                                  )
                                ],
                              ),
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
                                                    // Adjust typing speed
                                                    cursor:
                                                        '|', // Optional cursor
                                                  ),
                                                ],
                                                repeatForever: true,
                                                // Ensures continuous looping
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
                                                    // Adjust typing speed
                                                    cursor:
                                                        '|', // Optional cursor
                                                  ),
                                                ],
                                                repeatForever: true,
                                                // Ensures continuous looping
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
                                                // Ensures continuous looping
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
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    GetX<Enquirylistcontroller>(
                      builder: (Enquirylistcontroller controller) {
                        if (controller.isLoading.value) {
                          return Container(
                            margin: EdgeInsets.only(
                                left: 20.w,
                                top: 10.h,
                                right: 20.w,
                                bottom: 350.h),
                            child: Wrap(
                              spacing: 10.w, // Space between items
                              runSpacing: 10.h, // Space between rows
                              children: List.generate(
                                4, // Number of shimmer placeholders
                                (index) => Shimmer.fromColors(
                                  baseColor: Colors.grey[400]!,
                                  highlightColor: Colors.grey[200]!,
                                  child: Column(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25.r),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.060,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(30.r),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.only(
                                left: 20.w,
                                top: 10.h,
                                right: 20.w,
                                bottom: 350.h),
                            child: Wrap(
                              spacing: 10.w, // Space between items
                              runSpacing: 10.h, // Space between rows
                              children: List.generate(
                                controller.enquiryData.length,
                                // items is your list of data
                                (index) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return Subcategory(
                                          enquiry: controller
                                                  .enquiryData[index].id ??
                                              0,
                                          data: controller
                                                  .enquiryData[index].heading ??
                                              "",
                                        );
                                      },
                                    ));
                                  },
                                  child: buildInfoCard2(
                                      "${controller.enquiryData[index].heading?.toUpperCase()}",
                                      "${controller.enquiryData[index].logo}"),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: Container(
            margin: EdgeInsets.only(
                left: 30.w, top: 120.h, right: 20.w, bottom: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
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
                      onPressed: () {
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
                            // robotId:controller.background.value?.data?.first.robot?.roboId ?? " ",
                          },
                        ));
                      },
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                      label: Text("NAVIGATE",
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 18.h,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 300),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    otp(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                  opacity: animation, child: child);
                            },
                          ),
                        );
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (context) {
                        //     return otp();
                        //   },
                        // ));
                      },
                      icon: Icon(Icons.settings, color: Colors.white),
                      label: Text("SETTINGS ",
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 18.h,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          )
          // GetX<BatteryController>(
          //   builder: (BatteryController controller) {
          //     return ;
          //   },
          // ),
          ),
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
              // Ensuring rounded corners
              child: CachedNetworkImage(
                width: double.infinity,
                height: double.infinity,
                imageUrl: image,
                fit: BoxFit.cover,
                // Makes sure the image fills the container properly
                placeholder: (context, url) => Image.asset(
                  "assets/homelogo.jpg",
                  fit: BoxFit.fitWidth,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  "assets/homelogo.jpg",
                  fit: BoxFit.fitWidth,
                ),
              ),
            )
            // Fallback if no image
            ),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),

            // gradient: LinearGradient(
            //   colors: [Colors.blue, Colors.purple], // Define gradient colors
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            borderRadius: BorderRadius.circular(30.r),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.white,
            //     spreadRadius: 0.01,
            //     offset: Offset(0, 0),
            //   ),
            // ],
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
