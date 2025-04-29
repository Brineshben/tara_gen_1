import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Model/login_model.dart';
import '../../Service/sharedPreference.dart';
import '../../Utils/colors.dart';
import '../../Utils/popups.dart';
import 'settings.dart';

class otp extends StatefulWidget {
  const otp({Key? key}) : super(key: key);

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {
  final List<TextEditingController> otpControllers =
      List.generate(4, (index) => TextEditingController());

  @override
  void initState() {
    _hideSystemUI();
    super.initState();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive); // Hide status bar again
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
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
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 40, right: 20).h,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                                borderRadius: BorderRadius.circular(15).r),
                            child: Icon(
                              Icons.arrow_back_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ENTER PASSWORD",
                          style: GoogleFonts.oxygen(
                              color: Colors.white,
                              fontSize: 25.h,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                    SizedBox(height: 100.h),
                    Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                        (index) => Container(
                          width: 80.h,
                          height: 70.h,
                          decoration: BoxDecoration(
                            color: ColorUtils.otpContainerColor,
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.3,
                            ),
                            borderRadius: BorderRadius.circular(10).r,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 1.0,
                                sigmaY: 1.0,
                              ),
                              child: Center(
                                child: TextField(
                                  controller: otpControllers[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18.h),
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  decoration: const InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty && index < 3) {
                                      FocusScope.of(context).nextFocus();
                                    } else if (value.isEmpty && index > 0) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 200.h),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.white,
                        highlightColor: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(
                            20.r), // Match container shape

                        onTap: () async {
                          // Navigator.push(context, MaterialPageRoute(
                          String otp = otpControllers.map((e) => e.text).join();
                          print("benenen$otp");
                          LoginModel? loginApi =
                              await SharedPrefs().getLoginData();

                          print("login${loginApi?.user?.secretKey.toString()}");
                          print("otp${otp}");

                          if (loginApi?.user?.secretKey != null &&
                              loginApi?.user?.secretKey.toString() == otp) {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 300),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        Maintanance(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                      opacity: animation, child: child);
                                },
                              ),
                            );
                          } else {
                            ProductAppPopUps.submit(
                                message: "Incorrect Password",
                                actionName: "Try Again",
                                iconData: Icons.error_outline,
                                iconColor: Colors.red);
                          }

                          // if (otp.isNotEmpty && otp.length == 4) {
                          //   await Get.find<Passwordcontroller>().fetchpassword(
                          //       Get.find<UserAuthController>()
                          //               .loginData
                          //               .value
                          //               ?.user
                          //               ?.id ??
                          //           0,
                          //       otp);
                          //   print(
                          //       "skjdjdhjhj${Get.find<Passwordcontroller>().passwordApi.value?.message}");
                          //   if (Get.find<Passwordcontroller>()
                          //           .passwordApi
                          //           .value
                          //           ?.message ==
                          //       "Password is correct") {
                          //     Navigator.pushReplacement(
                          //       context,
                          //       PageRouteBuilder(
                          //         transitionDuration: Duration(milliseconds: 300),
                          //         pageBuilder:
                          //             (context, animation, secondaryAnimation) =>
                          //                 Maintanance(),
                          //         transitionsBuilder: (context, animation,
                          //             secondaryAnimation, child) {
                          //           return FadeTransition(
                          //               opacity: animation, child: child);
                          //         },
                          //       ),
                          //     );
                          //   } else {
                          //     ProductAppPopUps.submit(
                          //         message: "Incorrect Password",
                          //         actionName: "Try Again",
                          //         iconData: Icons.error_outline,
                          //         iconColor: Colors.red);
                          //   }
                          // } else {
                          //   ProductAppPopUps.submit(
                          //       message: "Incorrect Password",
                          //       actionName: "Try Again",
                          //       iconData: Icons.error_outline,
                          //       iconColor: Colors.red);
                          // }
                        },
                        child: buildInfoCard(size, 'SUBMIT'),
                      ),
                    ),
                    // Padding(
                    //   padding:
                    //       EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       InkWell(
                    //         onTap: () {},
                    //         child: Text(
                    //           "Forgot Password?",
                    //           style: TextStyle(
                    //             fontSize: 15.h,
                    //             color: Colors.white,
                    //             fontStyle: FontStyle.italic,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // GestureDetector(
                    //   onTap: () {
                    //
                    //   },
                    //   child: Container(
                    //     width: 200.w,
                    //     height: 50.h,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10).r,
                    //         color: ColorUtils.userdetailcolor),
                    //     child: Center(
                    //       child: Text(
                    //         'Submit',
                    //         style: GoogleFonts.oxygen(
                    //             color: Colors.white,
                    //             fontSize: 16.h,
                    //             fontWeight: FontWeight.w700),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
