import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/View/Login_Page/login.dart';
import 'package:lottie/lottie.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/Login_api_controller.dart';
import '../../Controller/battery_Controller.dart';
import '../../Controller/update_status_controller.dart';
import '../../Service/Api_Service.dart';
import '../../Utils/button.dart';
import '../../Utils/colors.dart';
import '../../Utils/popups.dart';
import '../Face_detection/face.dart';
import '../Robot_Response/robot_response.dart';
import '../Settings/maintanance.dart';
import 'SplashScreen.dart';
import 'battery_Widget.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  Timer? messageTimer;

  @override
  void initState() {
    _hideSystemUI();
    Get.find<BackgroudController>().fetchBackground(
        Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);
    Get.find<BatteryController>().fetchBattery(
        Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        messageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
          // Get.find<BatteryController>().fetchBattery(
          //     Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);
          print("------isDialogOpen--------${Get.isDialogOpen}");
          if (!(Get.isDialogOpen ?? true)) {
            checkUnknown();
          }
        });
      },
    );

    // TODO: implement initState
    super.initState();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive); // Hide status bar again
  }

  void stopTimer() {
    messageTimer?.cancel(); // Stop timer when navigating away
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
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
          Container(
            child: GetX<BackgroudController>(
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
          ),

          /// Main Content
          Column(
            children: [
              GetX<BatteryController>(
                builder: (BatteryController controller) {
                  Color? roboColor = controller
                              .background.value?.data?.first.robot?.map !=
                          null
                      ? (controller.background.value?.data?.first.robot?.map ??
                              false)
                          ? Colors.green
                          : Colors.red
                      : null;

                  print(
                      "nsnsnsnn${controller.background.value?.data?.first.robot?.batteryStatus}");
                  int batteryLevel = int.tryParse(controller.background.value
                              ?.data?.first.robot?.batteryStatus
                              .toString() ??
                          '0') ??
                      0;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 300),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      Splash(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 10.w, top: 40.h, right: 10.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),

                            // gradient: LinearGradient(
                            //   colors: [Colors.blue, Colors.purple], // Define gradient colors
                            //   begin: Alignment.topLeft,
                            //   end: Alignment.bottomRight,
                            // ),
                            borderRadius: BorderRadius.circular(20.r),
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
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 20.w, top: 40.h, right: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                BatteryIcon(
                                  batteryLevel: batteryLevel,
                                ), // Updated widget

                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${controller.background.value?.data?.first.robot?.batteryStatus}%",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.h),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ), // Container(
              //   margin: EdgeInsets.only(
              //       left: 20.w, top: 60.h, right: 20.w, bottom: 10.h),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //
              //       MyWidget(Iamge: "",Name: "i hub ",)
              //
              //     ],
              //   ),
              // ),
              // Center(
              //   child: RhomboidContainer(
              //     width: 200,
              //     height: 50,
              //     color: Colors.blue,
              //     child: const Text(
              //       "Rhomboid",
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 50,
              ),

              Center(
                  child: SizedBox(
                width: size.width * 0.8,
                height: size.width * 0.3,
                child: Lottie.asset(
                  "assets/Animation - 1739429937775.json",
                  fit: BoxFit.fitHeight,
                ),
              )),
            ],
          ),
        ],
      ),
      // floatingActionButton: Container(
      //   margin:
      //       EdgeInsets.only(left: 30.w, top: 120.h, right: 20.w, bottom: 10.h),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       FloatingActionButton.extended(
      //         backgroundColor: Colors.red,
      //         onPressed: () {
      //           checkInternet2(
      //               context: context,
      //               function: () async {
      //                 try {
      //                   Map<String, dynamic> resp = await ApiServices.logout();
      //                   if (resp['status'] == "OFF") {
      //                     FocusManager.instance.primaryFocus?.unfocus();
      //                     ProductAppPopUps.submitLogOut(
      //                       title: "SUCCESS",
      //                       message: resp['message'].toString(),
      //                       actionName: "Close",
      //                       iconData: Icons.done,
      //                       iconColor: Colors.green,
      //                       context: context,
      //                     );
      //                   } else {
      //                     ProductAppPopUps.submit(
      //                       title: "FAILED",
      //                       message: "Something went wrong.",
      //                       actionName: "Close",
      //                       iconData: Icons.info_outline,
      //                       iconColor: Colors.red,
      //                     );
      //                   }
      //                   print("------forgot resp-----------$resp");
      //                 } catch (e) {
      //                   print("------forgot error-----------${e.toString()}");
      //                 }
      //               });
      //         },
      //         icon: Icon(Icons.power_settings_new, color: Colors.white),
      //         label: Text("POWER OFF",
      //             style: GoogleFonts.orbitron(
      //               color: Colors.white,
      //               fontSize: 18.h,
      //               fontWeight: FontWeight.bold,
      //             )),
      //       ),
      //       // FloatingActionButton.extended(
      //       //   backgroundColor: Colors.grey,
      //       //   onPressed: () {
      //       //     Navigator.of(context).pushReplacement(MaterialPageRoute(
      //       //       builder: (context) {
      //       //         return Maintanance();
      //       //       },
      //       //     ));
      //       //     // Navigator.push(
      //       //     //     context,
      //       //     //     MaterialPageRoute(
      //       //     //       builder: (context) => Maintanance(),
      //       //     //     ));
      //       //   },
      //       //   icon: Icon(Icons.settings, color: Colors.white),
      //       //   label: Text("SETTINGS",
      //       //       style: GoogleFonts.orbitron(
      //       //         color: Colors.white,
      //       //         fontSize: 18.h,
      //       //         fontWeight: FontWeight.bold,
      //       //       )),
      //       // ),
      //     ],
      //   ),
      // ),
    );
  }

  Future<void> checkUnknown() async {
    print("Checking status...");
    try {
      Map<String, dynamic> resp = await ApiServices.checkUnknown();

      print("Response: $resp");

      if (resp['status'] == "UNKNOWN") {
        // Get
        //     .find<PopupController>()
        //     .isDialogShown
        //     .value = true;

        Get.dialog(
          AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close_outlined,
                          color: Colors.grey,
                        ))
                  ],
                ),
                Center(
                  child: SizedBox(
                    width: 120.w,
                    height: 120.h,
                    child: Lottie.asset(
                      "assets/popup.json",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Text(
                  "NEW USER FOUND",
                  style: GoogleFonts.oxygen(
                    color: Colors.black,
                    fontSize: 18.h,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              "Click on Continue button to Register Your Details!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.h),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    onPressed: () {
                      // Get
                      //     .find<PopupController>()
                      //     .isDialogShown
                      //     .value = false;
                      // Get
                      //     .find<PopupController>()
                      //     .isHomepage
                      //     .value = false;
                      messageTimer?.cancel();
                      Get.back();
                      ApiServices.updateStatus(status: false);
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //   builder: (context) {
                      //     return RobotResponse();
                      //   },
                      // ));
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 300),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  RobotResponse(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                                opacity: animation, child: child);
                          },
                        ),
                      );
                      // controller.updatedata(false);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(ColorUtils.userdetailcolor),
                    ),
                    child: Text(
                      "CANCEL",
                      style: TextStyle(color: Colors.white, fontSize: 16.h),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      // Get
                      //     .find<PopupController>()
                      //     .isDialogShown
                      //     .value = false;
                      // Get
                      //     .find<PopupController>()
                      //     .isHomepage
                      //     .value = false;
                      // controller.updatedata(true);
                      messageTimer?.cancel();
                      Get.back();
                      ApiServices.updateStatus(status: true);
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //   builder: (context) {
                      //     return Face();
                      //   },
                      // ));
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 300),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  Face(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                                opacity: animation, child: child);
                          },
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(ColorUtils.userdetailcolor),
                    ),
                    child: Text(
                      "CONTINUE",
                      style: TextStyle(color: Colors.white, fontSize: 16.h),
                    ),
                  ),
                ],
              )
            ],
          ),
        ).then((_) {
          // The flag remains true until manually reset
        });
      } else if (resp['status'] == "KNOWN") {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) =>
                RobotResponse(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      } else if (resp['status'] == "NO_FACE") {
        print("----NO_FACE--------$resp");
      }
    } catch (e) {
      print("------errorfromapiii-----------${e.toString()}");
    }
  }
}

class PopupController extends GetxController {
  var isDialogShown = false.obs;
}
