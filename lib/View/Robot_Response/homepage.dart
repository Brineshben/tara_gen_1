import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/api_constant.dart';
import 'package:ihub/Utils/communication_status.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/Utils/web_view.dart';
import 'package:ihub/View/Robot_Response/Navigation.dart';
import 'package:ihub/View/Robot_Response/password_page.dart';
import 'package:ihub/View/Robot_Response/robotinfo.dart';
import 'package:ihub/View/Splash/Battery_Splash.dart';
import 'package:ihub/View/Splash/Loading_Splash.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/Login_api_controller.dart';
import '../../Controller/RobotresponseApi_controller.dart';
import '../../Controller/battery_Controller.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with WidgetsBindingObserver {
  bool canExit = false;
  Timer? fiveSecTimer;
  Timer? oneSecTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _hideSystemUI();

    Get.find<RobotresponseapiController>().getUrl();

    fiveSecTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      // get robot wifi ip
      // fetchAndUpdateBaseUrl();

      // fetch robot battery data
      // Get.find<BatteryController>().fetchBattery(
      //   Get.find<UserAuthController>().loginData.value?.user?.id ?? 0,
      // );

      // check robot on or off
      // Map<String, dynamic> resp = await ApiServices.loading();
      // if (resp['status'] != "ON") {
      //   fiveSecTimer?.cancel();
      //   Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => LoadingSplash()),
      //     (route) => false,
      //   );
      // }
    });

    // oneSecTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
    //   // get communication status
    //   Get.find<RobotresponseapiController>().fetchObsResultList();

    //   Map<String, dynamic> resp = await ApiServices.getBatteryStatus();
    //   if (resp['status'] == true) {
    //     oneSecTimer?.cancel();

    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (context) => BatterySplash()),
    //       (route) => false,
    //     );
    //   }
    // });
  }

  Timer? _debounceTimer;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _debounceTimer?.cancel();

    final robotresponce = Get.find<RobotresponseapiController>();
    robotresponce.robotResponseModel.value = null;

    // Start new timer to delay fetchBackground
    _debounceTimer = Timer(Duration(seconds: 5), () {
      if (mounted) {
        Get.find<BackgroudController>().fetchBackground(
          Get.find<UserAuthController>().loginData.value?.user?.id ?? 0,
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    fiveSecTimer?.cancel();
    _debounceTimer?.cancel();
    oneSecTimer?.cancel();
    super.dispose();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
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
                                GestureDetector(
                                  onLongPress: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RobotInfo(),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 30.r,
                                    backgroundColor: Colors.black,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/taraLogo.png",
                                        width: 100.w,
                                        height: 100.h,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Stack(
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
                    //           spacing: 10.w,
                    //           runSpacing: 10.h,
                    //           children: List.generate(
                    //             4,
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
                    //           spacing: 10.w,
                    //           runSpacing: 10.h,
                    //           children: List.generate(
                    //             controller.enquiryData.length,
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
              GetX<RobotresponseapiController>(
                builder: (controller) {
                  bool? listening = controller.responseData.value.listening;
                  bool? speaking = controller.responseData.value.speaking;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controller.robotResponseModel.value?.text != null &&
                              controller.robotResponseModel.value?.text != ''
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    controller.robotResponseModel.value?.text ??
                                        '',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                      if (listening == true)
                        RobotCommunicationStatus(
                          text: "LISTENING...",
                        )
                      else if (speaking == true)
                        RobotCommunicationStatus(
                          text: "SPEAKING...",
                        )
                      else
                        RobotCommunicationStatus(
                          text: "THINKING...",
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: Obx(() {
                      final controller = Get.find<RobotresponseapiController>();
                      if (controller.link.value != '') {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InAppWebViewScreen(
                                    url: controller.link.value,
                                  ),
                                ),
                              );
                            },
                            child: Ink(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.blueGrey.shade100, width: 1),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.language,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    controller.name.value,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // child: buildInfoCard(
                            //   size,
                            //   controller.name.value,
                            //   color: Colors.black,
                            // ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 40, bottom: 20),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Navigation(
                                  robotid: Get.find<BatteryController>()
                                          .batteryModel
                                          .value
                                          ?.data
                                          ?.first
                                          .robot
                                          ?.roboId ??
                                      "");
                            },
                          ));
                        },
                        child: Ink(
                          width: 330.h,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.asset("assets/arrow.png", width: 35),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "NAVIGATIONS",
                                    style: TextStyle(
                                      fontSize: 19.h,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Control robot movement',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // child: buildInfoCard(
                        //   size,
                        //   'NAVIGATIONS',
                        //   color: Colors.black,
                        // ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, bottom: 20),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
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
                        child: Ink(
                          width: 330.h,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/management.png",
                                      width: 35),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "SETTINGS",
                                        style: TextStyle(
                                          fontSize: 19.h,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Manage robot preferences',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
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
                        // child: buildInfoCard(
                        //   size,
                        //   "SETTINGS",
                        //   color: Colors.black,
                        // ),
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
