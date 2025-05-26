import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Utils/header.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Service/Api_Service.dart';
import '../../Utils/popups.dart';
import 'settings.dart';

class ApiKey extends StatefulWidget {
  const ApiKey({Key? key}) : super(key: key);

  @override
  State<ApiKey> createState() => _ApiKeyState();
}

class _ApiKeyState extends State<ApiKey> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController NewIp = TextEditingController();

  @override
  void initState() {
    super.initState();
    _hideSystemUI();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive); // Hide status bar again
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 30),
                    child: Row(
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
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15).r),
                            child: Icon(
                              Icons.arrow_back_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Center(
                          child: Text(
                            "ADD API KEY",
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 25.h,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GetX<BatteryController>(
                            builder: (controller) {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: 40.w,
                                    bottom: 15,
                                    right: 40.w,
                                    top: 50.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'NEW API KEY',
                                      style: TextStyle(
                                        fontSize: 25.h,
                                        fontWeight: FontWeight.bold,
                                        color: controller.foregroundColor.value,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40.w, right: 40.w),
                            height: size.height * 0.2,
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              controller: NewIp,
                              validator: (val) => val!.trim().isEmpty
                                  ? 'Please Enter New API key'
                                  : null,
                              decoration: InputDecoration(
                                  hintStyle:
                                      const TextStyle(color: Colors.white38),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 10.w),
                                  hintText: "Enter New API key",
                                  labelStyle: TextStyle(
                                      color: Colors.white, fontSize: 16.h),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0),
                                    ).r,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                            Radius.circular(10))
                                        .r,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0))
                                        .r,
                                  ),
                                  fillColor: Colors.blueGrey[900],
                                  filled: true),
                              maxLines: 5,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.white,
                              highlightColor: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20.r),
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (NewIp.text.isNotEmpty) {
                                    Map<String, dynamic> resp =
                                        await ApiServices.ApiKey(
                                            Data: NewIp.text);

                                    if (resp['status'] == "ok") {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      ProductAppPopUps.submit2back(
                                        title: "SUCCESS",
                                        message: resp['message'].toString(),
                                        actionName: "Close",
                                        iconData: Icons.done,
                                        iconColor: Colors.green,
                                      );
                                    } else {
                                      ProductAppPopUps.submit(
                                        title: "FAILED",
                                        message: "Something went wrong.",
                                        actionName: "Close",
                                        iconData: Icons.info_outline,
                                        iconColor: Colors.red,
                                      );
                                    }
                                  }
                                }
                              },
                              child: buildInfoCard(
                                  MediaQuery.of(context).size, 'SUBMIT'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Header(
                  isBack: true,
                  screenName: "ADD API KEY",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
