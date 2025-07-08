import 'dart:io';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/View/Settings/settings.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lottie/lottie.dart';

class CropAndPreviewScreen extends StatefulWidget {
  final File originalImage;

  const CropAndPreviewScreen({super.key, required this.originalImage});

  @override
  State<CropAndPreviewScreen> createState() => _CropAndPreviewScreenState();
}

class _CropAndPreviewScreenState extends State<CropAndPreviewScreen> {
  File? croppedImage;

  Future<void> _cropImage(File image) async {
    try {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black, // White background
            toolbarWidgetColor: Colors.white, // Black icons and text
            hideBottomControls: false,
            lockAspectRatio: false,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          IOSUiSettings(title: 'Crop Image'),
        ],
      );

      if (!mounted) return;

      if (croppedFile != null) {
        setState(() {
          croppedImage = File(croppedFile.path);
        });
      }
    } catch (e) {
      print("Crop error: $e");
      if (mounted) Navigator.pop(context);
    }
  }

  void _submit() {
    Navigator.pop(context, croppedImage ?? widget.originalImage);
  }

  @override
  Widget build(BuildContext context) {
    final File imageToShow = croppedImage ?? widget.originalImage;
    return Scaffold(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 30,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.7,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.deepPurple,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Stack(
                        children: [
                          Image.file(
                            imageToShow,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 20),
                                child: Container(
                                  width: 150,
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
                                      CircleAvatar(
                                        radius: 20.r,
                                        backgroundColor: Colors.black,
                                        child: ClipOval(
                                          child: Image.asset(
                                            "assets/taraLogo.png",
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Stack(
                                        children: [
                                          Image.asset(
                                            "assets/logo1.png",
                                            width: 100,
                                          ),
                                          Positioned(
                                            top: 5,
                                            left: 7,
                                            child: Text(
                                              "POWERED BY",
                                              style: TextStyle(
                                                fontSize: 3,
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
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  spacing: 20,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/alert-icon-orange.svg",
                                      width: 30,
                                    ),
                                    Image.asset(
                                      "assets/brake.png",
                                      width: 30,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 10.w,
                                  top: 25.h,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GetX<BatteryController>(
                                      builder: (BatteryController controller) {
                                        Color? roboColor;
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: Color(0xFFFFFFF ^
                                                  controller.foregroundColor
                                                      .value.value),
                                              borderRadius:
                                                  BorderRadius.circular(90.r),
                                              border: Border.all(
                                                color: controller
                                                    .foregroundColor.value
                                                    .withOpacity(0.09),
                                              )),
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.1,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.060,
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Image.asset(
                                                    width: 15,
                                                    "assets/google-maps.png",
                                                    color: roboColor),
                                                Text(
                                                  "Q: 100",
                                                  style: GoogleFonts.roboto(
                                                    color: controller
                                                        .foregroundColor.value,
                                                    fontSize: 18.h,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "100%".toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Lottie.asset(
                                          'assets/green.json',
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.14,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          //
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, bottom: 20),
                                    child: Container(
                                      width: 200,
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset("assets/arrow.png",
                                              width: 20),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "NAVIGATIONS",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                'Control robot movement',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20, bottom: 20),
                                    child: Container(
                                      width: 200,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                  "assets/management.png",
                                                  width: 20),
                                              SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "SETTINGS",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Manage robot preferences',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Positioned(
                                left: 0,
                                right: 0,
                                child: Column(
                                  children: [
                                    Center(
                                      child: Lottie.asset(
                                          "assets/Animation - 1739525563341.json",
                                          width: 70),
                                    ),
                                    DefaultTextStyle(
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 25.h,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 5.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              offset: Offset(2, 2),
                                            ),
                                          ]),
                                      child: Center(
                                        child: AnimatedTextKit(
                                          animatedTexts: [
                                            TypewriterAnimatedText(
                                              "THINKING",
                                              speed: Duration(milliseconds: 50),
                                              cursor: '|',
                                            ),
                                          ],
                                          repeatForever: true,
                                          isRepeatingAnimation: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 🔸 Right side: Action Buttons
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildCustomButton(
                        onTap: _submit,
                        text: 'Set Wallpaper',
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                      SizedBox(height: 20),
                      _buildCustomButton(
                        onTap: () => _cropImage(widget.originalImage),
                        text: 'Crop Again',
                        icon: Icons.crop,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(height: 20),
                      _buildCustomButton(
                        onTap:() {
                           SettingsPage.globalKey.currentState?.pickImageFromDownloads();
                        },
                        text: 'Select image',
                        icon: Icons.select_all,
                        color: Colors.deepOrange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Header(
                isBack: true,
                screenName: "WALLPAPER PREVIEW",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton({
    required VoidCallback onTap,
    required String text,
    required IconData icon,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
