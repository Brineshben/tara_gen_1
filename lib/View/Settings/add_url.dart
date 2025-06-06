import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/RobotresponseApi_controller.dart';
import 'package:ihub/Service/url_service.dart';
import 'package:ihub/Utils/popups.dart';
import 'package:ihub/View/Settings/settings.dart';
import 'package:lottie/lottie.dart';

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
              Positioned.fill(
                child: Center(
                  child: SizedBox(
                    width: size.width * 0.5,
                    height: size.width * 0.5,
                    child: Lottie.asset(
                      "assets/loginimage.json",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Container(
                                      height: 60.h,
                                      width: 60.h,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(15).r),
                                      child: Icon(
                                        Icons.arrow_back_outlined,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30.w, vertical: 5.h),
                                    child: Text(
                                      'ADD WEB LINK',
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 30.h,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.w, vertical: 2.h),
                                child: TextFormField(
                                  cursorColor: ColorUtils.userdetailcolor,
                                  controller: _nameController,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(color: Colors.white),
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
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(color: Colors.white),
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
                              Center(
                                child: Material(
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

                                      Map<String, dynamic> response =
                                          await UrlService.addUrl(
                                              name: _nameController.text,
                                              urlpage: _urlController.text);

                                      print('addurlresponse$response');

                                      if (response['status'] == 'ok') {
                                        submit(
                                          title: "SUCCESS",
                                          message: "URL added successfully",
                                          actionName: "Close",
                                          iconData: Icons.done,
                                          iconColor: Colors.green,
                                        );

                                        Get.find<RobotresponseapiController>()
                                            .getUrl();
                                      } else {
                                        ProductAppPopUps.submit(
                                          title: "FAILED",
                                          message: "Failed to add URL",
                                          actionName: "Close",
                                          iconData: Icons.info,
                                          iconColor: Colors.red,
                                        );
                                      }
                                    },
                                    child: buildInfoCard(size, 'ADD'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
