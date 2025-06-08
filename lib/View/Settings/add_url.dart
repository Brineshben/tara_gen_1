import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Controller/RobotresponseApi_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Service/url_service.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/View/Settings/settings.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/colors.dart';

class AddUrlPage extends StatefulWidget {
  const AddUrlPage({Key? key}) : super(key: key);

  @override
  State<AddUrlPage> createState() => _AddUrlPageState();
}

class _AddUrlPageState extends State<AddUrlPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    _hideSystemUI();
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _urlController.text = prefs.getString('url') ?? '';
    _nameController.text = prefs.getString('name') ?? '';
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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              GetX<BackgroudController>(
                builder: (BackgroudController controller) {
                  return Positioned.fill(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: controller
                                  .backgroundModel.value?.backgroundImage ??
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
                              sigmaX: 10.0,
                              sigmaY: 10.0), // Adjust blur strength
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
              GetX<BatteryController>(builder: (batteryController) {
                return Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.w, vertical: 2.h),
                              child: TextFormField(
                                maxLength: 30,
                                cursorColor: ColorUtils.userdetailcolor,
                                controller: _nameController,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                    color: batteryController
                                        .foregroundColor.value),
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorUtils.userdetailcolor,
                                        width: 2),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorUtils.userdetailcolor),
                                  ),
                                  labelText: 'NAME',
                                  labelStyle: TextStyle(
                                      color: ColorUtils.userdetailcolor,
                                      fontSize: 16.h),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.w, vertical: 2.h),
                              child: TextFormField(
                                cursorColor: ColorUtils.userdetailcolor,
                                controller: _urlController,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                    color: batteryController
                                        .foregroundColor.value),
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorUtils.userdetailcolor,
                                        width: 2),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorUtils.userdetailcolor),
                                  ),
                                  labelText: 'LINK',
                                  labelStyle: TextStyle(
                                      color: ColorUtils.userdetailcolor,
                                      fontSize: 16.h),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.white,
                                    highlightColor:
                                        Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20.r),
                                    onTap: () async {
                                      if (_nameController.text.isEmpty ||
                                          _urlController.text.isEmpty) {
                                        submit(
                                          title: "Validation Error",
                                          message:
                                              "Name and URL must not be empty.",
                                          actionName: "Close",
                                          iconData: Icons.warning,
                                          iconColor: Colors.orange,
                                        );
                                        return;
                                      }

                                      final Uri? parsedUrl =
                                          Uri.tryParse(_urlController.text);
                                      if (parsedUrl == null ||
                                          !(parsedUrl.isScheme("http") ||
                                              parsedUrl.isScheme("https"))) {
                                        submit(
                                          title: "Invalid URL",
                                          message:
                                              "Please enter a valid URL (must start with http or https).",
                                          actionName: "Close",
                                          iconData: Icons.link_off,
                                          iconColor: Colors.red,
                                        );
                                        return;
                                      }

                                      // Map<String, dynamic> response =
                                      //     await UrlService.addUrl(
                                      //         name: _nameController.text,
                                      //         urlpage: _urlController.text);

                                      // print('addurlresponse$response');

                                      // if (response['status'] == 'ok') {
                                      //   submit(
                                      //     title: "SUCCESS",
                                      //     message: "URL added successfully",
                                      //     actionName: "Close",
                                      //     iconData: Icons.done,
                                      //     iconColor: Colors.green,
                                      //   );
                                      // Get.find<RobotresponseapiController>()
                                      //     .getUrl();
                                      // } else {
                                      //   ProductAppPopUps.submit(
                                      //     title: "FAILED",
                                      //     message: "Failed to add URL",
                                      //     actionName: "Close",
                                      //     iconData: Icons.info,
                                      //     iconColor: Colors.red,
                                      //   );
                                      // }

                                      await UrlService.storeUrl(
                                          name: _nameController.text,
                                          urlpage: _urlController.text);

                                      Get.back();
                                    },
                                    child: buildInfoCard(
                                      size,
                                      'ADD',
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.white,
                                    highlightColor:
                                        Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(40),
                                    onTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      if (_nameController.text.isEmpty &&
                                          _urlController.text.isEmpty) {
                                        submit(
                                          title: "Nothing to Delete",
                                          message:
                                              "No URL or Name found to delete.",
                                          actionName: "Close",
                                          iconData: Icons.info_outline,
                                          iconColor: Colors.orange,
                                        );
                                        return;
                                      }

                                      await prefs.remove('url');
                                      await prefs.remove('name');

                                      _nameController.clear();
                                      _urlController.clear();

                                      submit(
                                        title: "Deleted",
                                        message:
                                            "URL and Name have been deleted successfully.",
                                        actionName: "Close",
                                        iconData: Icons.delete_outline,
                                        iconColor: Colors.red,
                                      );

                                      await Get.find<
                                              RobotresponseapiController>()
                                          .getUrl();
                                    },
                                    child: buildInfoCard(
                                      size,
                                      'DELETE',
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              Column(
                children: [
                  Header(
                    isBack: true,
                    screenName: "WEBSITE LINK",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
              Get.back();
              Get.back();
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
}
