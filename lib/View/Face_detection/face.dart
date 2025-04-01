import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/View/Robot_Response/robot_response.dart';
import 'dart:math' as math;
import '../../Controller/Backgroud_controller.dart';
import '../../Controller/Session_Controller.dart';
import '../../Model/SessionUpdateModel.dart';
import '../../Utils/colors.dart';
import '../../Utils/popups.dart';
import '../../main.dart';
import '../Home_Screen/home_page.dart';
import 'add_user.dart';

class Face extends StatefulWidget {
  const Face({Key? key}) : super(key: key);

  @override
  State<Face> createState() => _FaceState();
}

class _FaceState extends State<Face> {
  late CameraController cameraController;
  int cameraIndex = 1;
  int currentMessageIndex = 0;
  Timer? messageTimer;
  List<String> messages = [
    "Let's Begin Face Detection.",
    "Please Look Straight at the Camera.",
    "Turn Your Head to the Left.",
    "Turn Your Head to the Right.",
    "Tilt Your Head Upward.",
    "Tilt Your Head Downward.",
  ];

  @override
  void initState() {
    super.initState();
    _hideSystemUI();
    // Get.find<PopupController>().isHomepage.value = false;

    cameraController =
        CameraController(cameras[cameraIndex], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
    messageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (currentMessageIndex < messages.length - 1) {
        setState(() {
          currentMessageIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          currentMessageIndex++;
        }); // Trigger a rebuild to display the new widget
      }
    });
  }
  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive); // Hide status bar again
  }
  @override
  void dispose() {
    // Get.find<PopupController>().isHomepage.value = true;

    cameraController.dispose();
    messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result)  {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
          return RobotResponse();
        },));
        },
      child: Scaffold(
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
            if (cameraController.value.isInitialized)
              Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000).r,
                  child: Container(
                    width: size.width * 0.42,
                    height: size.width * 0.42,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.srcOut,
                    ),
                    child: OverflowBox(
                      maxWidth: ScreenUtil().screenWidth,
                      maxHeight: double.infinity,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(
                            cameras[cameraIndex].lensDirection ==
                                    CameraLensDirection.front
                                ? math.pi
                                : 0),
                        child: Transform.rotate(
                          angle: math.pi / 2,
                          child: CameraPreview(
                            cameraController,
                            child: Stack(
                              children: [
                                ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withValues(alpha: 0.8),
                                      BlendMode.srcOut),
                                  // This one will create the magic
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.black,
                                            backgroundBlendMode:
                                                BlendMode.dstOut),
                                      ),
                                      Center(
                                        child: CircleAvatar(
                                          radius: 130.w,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    // margin:
                                    // EdgeInsets.only(top: 12.h),
                                    height: size.width * 0.42,
                                    width: size.width * 0.42,
                                    child: SvgPicture.asset(
                                        "assets/Ellipse 460.svg"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            currentMessageIndex < messages.length
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 50.h),
                      child: Text(
                        messages[currentMessageIndex],
                        style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 22.h,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 50.h),
                      child: GetX<SessionController>(
                        builder: (SessionController controller) {
                          SessionUpdateModel? sessionid =
                              controller.sessionDatas.value;
                          return GestureDetector(
                            onTap: () async {
                              await Get.find<SessionController>().sessionData();
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: Duration(milliseconds: 300),
                                  pageBuilder: (context, animation, secondaryAnimation) => AddUser(
                                      sessionId: sessionid?.sessionId ?? ""
                                  ),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(opacity: animation, child: child);
                                  },
                                ),
                              );

                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => AddUser(
                              //         sessionId: sessionid?.sessionId ?? "",
                              //       ),
                              //     ));
                              // if (sessionid?.status == "null") {
                              //   await Get.find<SessionController>().sessionData();
                              //   Navigator.pushReplacement(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) =>
                              //             AddUser(
                              //               sessionId:
                              //               sessionid?.sessionId ?? "",
                              //             ),
                              //       ));
                              // } else {
                              //   print("session id nuldddddl${sessionid?.status}");
                              //   submit(
                              //     title: "Failed",
                              //     message: "Face not detected properly. Please try again.",
                              //     actionName: "Try Again",
                              //     iconData: Icons.error_outline,
                              //     iconColor: Colors.red,
                              //   );
                              // }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              width: 150.w,
                              height: 60.h,
                              child: Center(
                                child: Text(
                                  "STOP",
                                  style: GoogleFonts.orbitron(
                                    color: Colors.white,
                                    fontSize: 18.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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
      ),
    );
  }
}

submit({
  String? title,
  required String message,
  required String actionName,
  required IconData iconData,
  required Color iconColor,
}) {
  return Get.dialog(
    AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      title: Column(
        children: [
          Icon(
            iconData,
            color: iconColor,
            size: 50.h,
          ),
          if (title != null) SizedBox(height: 10.w),
          if (title != null)
            Text(
              title,
              style: GoogleFonts.oxygen(
                  color: Colors.black,
                  fontSize: 18.h,
                  fontWeight: FontWeight.bold),
            ),
        ],
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16.h),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          onPressed: () {
            Get.to(
              () => Face(),
              preventDuplicates: false,
            );
          },
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all(ColorUtils.userdetailcolor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                actionName,
                style: TextStyle(color: Colors.white, fontSize: 16.h),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
