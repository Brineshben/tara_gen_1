import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/Login_api_controller.dart';
import '../../Controller/Navigate_Controller.dart';
import '../../Controller/Response_Nav_Controller.dart';
import '../../Model/Navigate_model.dart';
import '../../Service/Api_Service.dart';
import '../../Utils/colors.dart';
import '../../Utils/popups.dart';
import '../Login_Page/login.dart';
import 'SubDetails2.dart';

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
    Get.find<NavigateController>().NavigateData();
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
                        Image.asset("assets/images.jpg", fit: BoxFit.cover),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/images.jpg", fit: BoxFit.cover),
                  ),
                );
              },
            ),
            SingleChildScrollView(
              child: GetX<NavigateController>(
                builder: (NavigateController controller) {
                  // NavigationListModel? data = controller.DataList ?? [];
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 20),
                        child: Row(
                          children: [
                            Row(
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
                                        borderRadius:
                                            BorderRadius.circular(15).r),
                                    child: Icon(
                                      Icons.arrow_back_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Center(
                                  child: Text(
                                    "NAVIGATION",
                                    style: GoogleFonts.oxygen(
                                        color: Colors.white,
                                        fontSize: 25.h,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            GetX<BatteryController>(
                              builder: (BatteryController controller) {
                                Color? roboColor = controller.background.value
                                            ?.data?.first.robot?.map !=
                                        null
                                    ? (controller.background.value?.data?.first
                                                .robot?.map ??
                                            false)
                                        ? Colors.green
                                        : Colors.red
                                    : null;
                                return Row(
                                  children: [
                                    // Container(
                                    //   margin: EdgeInsets.only(
                                    //       left: 10.w, top: 40.h, right: 10.w),
                                    //   decoration: BoxDecoration(
                                    //     color: Colors.white.withOpacity(0.2),
                                    //     borderRadius:
                                    //         BorderRadius.circular(20.r),
                                    //   ),
                                    //   width: size.height * 0.1,
                                    //   height: size.height * 0.070,
                                    //   child: Center(
                                    //     child: SizedBox(
                                    //       child: Padding(
                                    //         padding:
                                    //             const EdgeInsets.all(8.0),
                                    //         child: Lottie.asset(
                                    //           "assets/emergency.json",
                                    //           fit: BoxFit.fitHeight,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    if (controller.background.value?.data?.first
                                            .robot?.motorBrakeReleased ??
                                        false)
                                      Center(
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                left: 10.w,
                                                top: 40.h,
                                                right: 10.w),
                                            height: size.height * 0.060,
                                            width: size.width * 0.060,
                                            child: Image.asset(
                                                "assets/brake.png",
                                                fit: BoxFit.contain)),
                                      ),
                                    if (controller.background.value?.data?.first
                                            .robot?.emergencyStop ??
                                        false)
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
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10, top: 35, right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),

                                        // gradient: LinearGradient(
                                        //   colors: [Colors.blue, Colors.purple], // Define gradient colors
                                        //   begin: Alignment.topLeft,
                                        //   end: Alignment.bottomRight,
                                        // ),
                                        borderRadius:
                                            BorderRadius.circular(30.r),
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
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: size.height * 0.060,
                                                width: size.width * 0.060,
                                                child: SvgPicture.asset(
                                                  "assets/reshot-icon-map-marker-KS456ZT2P3.svg",
                                                  color: roboColor,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Q: ${controller.background.value?.data?.first.robot?.quality} ",
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
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "PLEASE SELECT YOUR DESTINATION",
                        style: GoogleFonts.oxygen(
                            color: Colors.white,
                            fontSize: 25.h,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      if (controller.DataList.isNotEmpty)
                        controller.isLoading.value
                            ? CircularProgressIndicator(
                                color: Colors.blue,
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                    controller.DataList.length,
                                    // Change this to your dynamic list length
                                    (index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                            splashColor: Colors.white,
                                            highlightColor:
                                                Colors.white.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                            onTap: () async {
                                              {
                                                try {
                                                  await ApiServices.destination(
                                                      id: controller
                                                              .DataList[index]
                                                              ?.id ??
                                                          0);
                                                  await Future.delayed(
                                                      Duration(seconds: 1));
                                                  Map<String, dynamic> resp =
                                                      await ApiServices
                                                          .robotbasestatus();

                                                  print(
                                                      "benbenbenbenben${controller.DataList[index]?.id ?? 0}");

                                                  if (resp['status'] == true) {
                                                    print("base status");
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    print(
                                                        "-----ben---------$resp");

                                                    Get.dialog(
                                                      AlertDialog(
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20.0)),
                                                        ),
                                                        title: Column(
                                                          children: [
                                                            Center(
                                                              child: SizedBox(
                                                                width: 180.w,
                                                                height: 180.h,
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
                                                                fontSize: 20.h,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        content: Text(
                                                          "Heading to the ${controller.DataList[index]?.name}"
                                                              .toUpperCase(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .oxygen(
                                                            color: Colors.black,
                                                            fontSize: 15.h,
                                                          ),
                                                        ),
                                                      ),
                                                    );

                                                    Future.delayed(
                                                        const Duration(
                                                            seconds: 3), () {
                                                      if (Get.isDialogOpen ??
                                                          false) {
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
                                                                  Radius
                                                                      .circular(
                                                                          20.0)),
                                                        ),
                                                        title: Column(
                                                          children: [
                                                            Center(
                                                              child: SizedBox(
                                                                width: 180.w,
                                                                height: 180.h,
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
                                                                fontSize: 20.h,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        content: Text(
                                                          "COMMAND ALREADY RECEIVED"
                                                              .toUpperCase(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .oxygen(
                                                            color: Colors.black,
                                                            fontSize: 15.h,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                    Future.delayed(
                                                        const Duration(
                                                            seconds: 3), () {
                                                      if (Get.isDialogOpen ??
                                                          false) {
                                                        Get.back();
                                                        Get.back();
                                                      }
                                                    });
                                                  }
                                                } catch (e) {
                                                  ProductAppPopUps.submit(
                                                    title: "FAILED",
                                                    message:
                                                        "Something went wrong.",
                                                    actionName: "Close",
                                                    iconData:
                                                        Icons.info_outline,
                                                    iconColor: Colors.red,
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
                              )
                      else
                        Center(
                          child: Row(
                            children: [
                              SizedBox(
                                height: 150,
                              ),
                              Text(
                                "Oops..No Data Found in Destination List..",
                                style: GoogleFonts.oxygen(
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
          ],
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(
              left: 30.w, top: 120.h, right: 20.w, bottom: 20.h),
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
              borderRadius:
                  BorderRadius.circular(10), // Ensure proper border radius
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
                    style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontSize: 18.h,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ),
        ));
  }

  Widget buildInfoCard2(String title) {
    final Size size = MediaQuery.of(context).size;
    return Ink(
      decoration: BoxDecoration(
        // color: Colors.white.withOpacity(0.2),

        gradient: LinearGradient(
          colors: [ColorUtils.userdetailcolor, ColorUtils.userdetailcolor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
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
                color: Colors.white,
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
