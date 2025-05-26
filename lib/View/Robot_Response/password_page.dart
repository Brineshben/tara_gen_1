import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Utils/header.dart';

import 'package:ihub/View/Settings/settings.dart';
import 'package:pinput/pinput.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  bool isError = false;
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Colors.black),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: isError ? Colors.red : Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
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
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(top: 30, left: 20),
                    //       child: Row(
                    //         children: [
                    //           GestureDetector(
                    //             onTap: () {
                    //               Navigator.pop(context);
                    //             },
                    //             child: Container(
                    //               height: 60.h,
                    //               width: 60.h,
                    //               decoration: BoxDecoration(
                    //                 color: Colors.black.withOpacity(0.2),
                    //                 borderRadius: BorderRadius.circular(15).r,
                    //               ),
                    //               child: const Icon(Icons.arrow_back_outlined,
                    //                   color: Colors.black),
                    //             ),
                    //           ),
                    //           SizedBox(width: 10),
                    //           Text(
                    //             "PASSWORD",
                    //             style: GoogleFonts.oxygen(
                    //               color: Colors.black,
                    //               fontSize: 25.h,
                    //               fontWeight: FontWeight.w700,
                    //             ),
                    //           ),
                    //           // SizedBox(width: 20),
                    //           // IconButton(
                    //           //   icon: Icon(
                    //           //     Icons.password,
                    //           //     size: 30,
                    //           //   ),
                    //           //   onPressed: () {
                    //           //     Navigator.pop(context);
                    //           //     Navigator.push(
                    //           //       context,
                    //           //       MaterialPageRoute(
                    //           //           builder: (_) => const ChangePasswordPage()),
                    //           //     );
                    //           //   },
                    //           // ),
                    //         ],
                    //       ),
                    //     ),
                    //     GetX<BatteryController>(
                    //       builder: (batteryController) {
                    //         int batteryLevel = int.tryParse(
                    //               batteryController.background.value?.data?.first
                    //                       .robot?.batteryStatus ??
                    //                   "0",
                    //             ) ??
                    //             0;
                    //         return BatteryIcon(batteryLevel: batteryLevel);
                    //       },
                    //     ),
                  ],
                ),
              ],
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Pinput(
                      controller: _pinController,
                      length: 4,
                      obscureText: true,
                      autofocus: true,
                      defaultPinTheme: defaultPinTheme.copyWith(
                        textStyle: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      keyboardType: TextInputType.number,
                      closeKeyboardWhenCompleted: true,
                      onCompleted: (pin) {
                        if (pin == '5678') {
                          setState(() => isError = false);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Maintanance()),
                          );
                        } else {
                          setState(() => isError = true);
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Header(
                  isBack: true,
                  screenName: "PASSWORD",
                ),
              ],
            ),
            Column(
              children: [
                Header(
                  isBack: true,
                  screenName: "PASSWORD",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
