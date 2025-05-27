import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ihub/Controller/Login_api_controller.dart';
import 'package:ihub/Utils/api_constant.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/Utils/pinning_helper.dart';
import 'package:ihub/Utils/web_view.dart';
import 'package:ihub/View/Settings/add_url.dart';
import 'package:ihub/View/Settings/charge_screen.dart';
import 'package:ihub/View/Settings/description_option.dart';
import 'package:ihub/View/Settings/prompt_list_page.dart';
import 'package:ihub/View/Settings/upload_Document.dart';
import 'package:ihub/View/Splash/Loading_Splash.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/battery_Controller.dart';
import '../../Service/Api_Service.dart';
import '../../Service/sharedPreference.dart';
import '../../Utils/colors.dart';
import '../../Utils/popups.dart';
import '../Login_Page/login.dart' as login_page;
import '../Robot_Response/Fulltour_dart.dart';
import '../Robot_Response/language_list.dart';
import 'ApiKey.dart';
import 'Volume_page.dart';

class Maintanance extends StatefulWidget {
  const Maintanance({Key? key}) : super(key: key);

  @override
  State<Maintanance> createState() => _MaintananceState();
}

class _MaintananceState extends State<Maintanance> {
  // static const _platform = MethodChannel('com.example.ihub/channel');

  // static Future<void> openExternalApp() async {
  //   try {
  //     await _platform.invokeMethod('openAnotherApp');
  //   } on PlatformException catch (e) {
  //     print("Failed to open external app: ${e.message}");
  //   }
  // }
  // static const platform = MethodChannel('com.example.ihub/channel');
  // void openAnotherAppKisko() async {
  //   try {
  //     await platform.invokeMethod('openAnotherApp');
  //   } catch (e) {
  //     print("Error launching app: $e");
  //   }
  // }

  bool isTraining = false;

  @override
  void initState() {
    _hideSystemUI();
    super.initState();
  }

  Future<void> startTraining() async {
    try {
      Map<String, dynamic> resp = await ApiServices.train(status: true);

      if (resp['status'] == true) {
        setState(() {
          isTraining = true;
        });

        ProductAppPopUps.submit(
          title: "On Progress",
          message: "Robot on Training",
          actionName: "Close",
          iconData: Icons.done,
          iconColor: Colors.green,
        );
      }
    } catch (e) {
      // Handle errors
      print("Error: $e");
    }
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive); // Hide status bar again
  }

  bool isLoading = false;

  File? imageFile;
  Future<void> _pickImageFromDownloads() async {
    isLoading = true;
    String? initialDirectory = "/storage/emulated/0/Download";

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      initialDirectory: initialDirectory,
    );

    if (result != null && result.files.single.path != null) {
      File originalImage = File(result.files.single.path!);

      setState(() {
        imageFile = originalImage;
      });

      await _processImageForColor(originalImage);
      await _uploadImage(originalImage);
    } else {
      Get.snackbar(
        'CANCELLED',
        'No image selected.',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
    }

    isLoading = false;
  }

// process image
  Future<void> _processImageForColor(File originalFile) async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      FileImage(originalFile),
      size: const Size(500, 500),
      maximumColorCount: 20,
    );

    final dominantColor = paletteGenerator.dominantColor?.color ?? Colors.white;
    final brightness = ThemeData.estimateBrightnessForColor(dominantColor);

    Get.find<BatteryController>().foregroundColor.value =
        brightness == Brightness.dark ? Colors.white : Colors.black;

    print("Updated color: $dominantColor, brightness: $brightness");
  }

// upload image
  Future<void> _uploadImage(File imageFile) async {
    try {
      final url =
          '${ApiConstants.baseUrl}/accounts/upload/background/${Get.find<UserAuthController>().loginData.value?.user?.id}/';
      print('backgroundid $url');

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath(
          'background_image',
          imageFile.path,
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint('bguploadrespo ${response.body}');

      var jsonResponse = jsonDecode(response.body);

      print('bgresponse $jsonResponse');

      if (jsonResponse['status'] == 'ok') {
        Get.find<BackgroudController>().fetchBackground(
            Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);

        ProductAppPopUps.submit(
            message: jsonResponse['message'],
            actionName: "close",
            iconData: Icons.check,
            iconColor: Colors.green);
      }
    } catch (e) {
      print('Errorbgupload $e');
      print('Errorbgupload $e');
      Get.snackbar(
        'Upload Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
    return Scaffold(
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
            padding: const EdgeInsets.only(top: 130, right: 50, left: 50),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    alignment: WrapAlignment.center,
                    children: [
                      // GestureDetector(
                      //   child: buildInfoCard(size, 'ADD EMPLOYEES'),
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       PageRouteBuilder(
                      //         transitionDuration: Duration(milliseconds: 300),
                      //         pageBuilder:
                      //             (context, animation, secondaryAnimation) =>
                      //                 AddEmployee(),
                      //         transitionsBuilder: (context, animation,
                      //             secondaryAnimation, child) {
                      //           return FadeTransition(
                      //               opacity: animation, child: child);
                      //         },
                      //       ),
                      //     );
                      //   },
                      // ),

                      // Material(
                      //   color: Colors.transparent,
                      //   child: InkWell(
                      //     splashColor: Colors.white,
                      //     highlightColor: Colors.white.withOpacity(0.3),
                      //     borderRadius: BorderRadius.circular(20.r),
                      //     child: buildInfoCard(size, 'IP ADDRESS'),
                      //     onTap: () {
                      //       Navigator.push(
                      //         context,
                      //         PageRouteBuilder(
                      //           transitionDuration: Duration(milliseconds: 300),
                      //           pageBuilder:
                      //               (context, animation, secondaryAnimation) =>
                      //                   Ipaddress(),
                      //           transitionsBuilder: (context, animation,
                      //               secondaryAnimation, child) {
                      //             return FadeTransition(
                      //                 opacity: animation, child: child);
                      //           },
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),

                      // GestureDetector(
                      //   child: buildInfoCard(
                      //       size, isTraining ? 'ON TRAINING' : 'TRAIN ROBOT'),
                      //   onTap: () async {
                      //     if (!isTraining) {
                      //       startTraining();
                      //     }
                      //   },
                      // ),

                      // REBOOT
                      // GestureDetector(
                      //   child: buildInfoCard(size, 'REBOOT'),
                      //   onTap: () async {
                      //     Map<String, dynamic> resp =
                      //         await ApiServices.Reboot(true);
                      //     print("POWERPOWERPOWER$resp");
                      //     if (resp['status'] == true) {
                      //       FocusManager.instance.primaryFocus?.unfocus();
                      //       ProductAppPopUps.submit(
                      //         title: "SUCCESS",
                      //         message: resp['message'].toString(),
                      //         actionName: "Close",
                      //         iconData: Icons.done,
                      //         iconColor: Colors.green,
                      //       );
                      //     } else {
                      //       ProductAppPopUps.submit(
                      //         title: "FAILED",
                      //         message: "Something went wrong.",
                      //         actionName: "Close",
                      //         iconData: Icons.info_outline,
                      //         iconColor: Colors.red,
                      //       );
                      //     }
                      //   },
                      // ),

                      SettingsCard(
                        iconPath: 'assets/cryptography.png',
                        subtitle: 'Manage your API keys securely',
                        title: 'API KEY',
                        backgroundColor: Colors.white,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 300),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      ApiKey(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                      ),
                      SettingsCard(
                        iconPath: 'assets/language.png',
                        subtitle: 'Tap to Select language',
                        title: 'SELECT LANGUAGE',
                        backgroundColor: Colors.white,
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => LanguageList()),
                          );
                        },
                      ),
                      SettingsCard(
                          iconPath: 'assets/3d-wifi.png',
                          subtitle: 'Configure your Wi-Fi router settings',
                          title: 'ROUTER SETTINGS',
                          backgroundColor: Colors.white,
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InAppWebViewScreen(
                                  url:
                                      'http://192.168.11.2/admin/index.html#/functions/wifi/client?freq=5GHz',
                                ),
                              ),
                            );
                          }),

                      SettingsCard(
                        iconPath: 'assets/robo.png',
                        subtitle: 'Preparing for mapping',
                        title: 'MAPPING',
                        backgroundColor: Colors.white,
                        onTap: () async {
                          openAnotherApp();
                        },
                      ),
                      SettingsCard(
                        iconPath: 'assets/image.png',
                        subtitle: 'Select and set a new wallpaper',
                        title: 'CHANGE WALLPAPER',
                        backgroundColor: Colors.white,
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await LockTaskService.stopLockTask();
                            await Future.delayed(Duration(milliseconds: 300));
                            await _pickImageFromDownloads();
                            await LockTaskService.startLockTask();
                          } catch (e) {
                            print("Error: $e");
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      ),
                      SettingsCard(
                        iconPath: 'assets/map.png',
                        subtitle: "Upload a new map for your tour",
                        title: 'UPLOAD MAP',
                        backgroundColor: Colors.white,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FileUploadScreen()));
                        },
                      ),
                      SettingsCard(
                        iconPath: 'assets/prompt.png',
                        subtitle: 'Manage Behavior Protocol',
                        title: 'Behavior Protocol',
                        backgroundColor: Colors.white,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PromptListPage()));
                        },
                      ),
                      SettingsCard(
                        iconPath: 'assets/charging.png',
                        subtitle: 'Check the current charge status',
                        title: 'Battery Config',
                        backgroundColor: Colors.white,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChargeEntryView()));
                        },
                      ),
                      SettingsCard(
                        iconPath: 'assets/description.png',
                        subtitle: 'Manage and edit descriptions',
                        title: 'DESCRIPTION',
                        backgroundColor: Colors.white,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DescriptionOption()));
                        },
                      ),
                      SettingsCard(
                        iconPath: 'assets/link.png',
                        subtitle: 'Add and manage web links',
                        title: 'WEB LINK',
                        backgroundColor: Colors.white,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddUrlPage()));
                        },
                      ),
                      SettingsCard(
                        iconPath: 'assets/destination11.png',
                        subtitle: "Create a new full tour itinerary",
                        title: 'ADD FULL TOUR',
                        backgroundColor: Colors.white,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListAnimationdData()));
                        },
                      ),
                      SettingsCard(
                        iconPath: 'assets/high-volume.png',
                        subtitle: 'Adjust the controller volume',
                        title: 'VOLUME CONTROLLER',
                        backgroundColor: Colors.white,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return VolumeControl(
                                  robotid: Get.find<BatteryController>()
                                          .background
                                          .value
                                          ?.data
                                          ?.first
                                          .robot
                                          ?.roboId ??
                                      "",
                                );
                              },
                            ),
                          );
                        },
                      ),
                      SettingsCard(
                        iconPath: 'assets/synchronize.png',
                        subtitle: 'Restart your robot to refresh settings',
                        title: 'RESTART',
                        backgroundColor: Colors.white,
                        onTap: () async {
                          final confirmRestart = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              backgroundColor: Colors.white,
                              title: Text(
                                'Restart Robot',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              content: Text(
                                'Are you sure you want to restart the robot?',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('Restart'),
                                ),
                              ],
                            ),
                          );

                          if (confirmRestart == true) {
                            login_page.checkInternet2(
                              context: context,
                              function: () async {
                                try {
                                  Map<String, dynamic> resp =
                                      await ApiServices.logoutoffline(true)
                                          .timeout(Duration(seconds: 3));
                                  if (resp['message'] ==
                                      "Reboot status updated") {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoadingSplash()),
                                        (_) => false);
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Something went wrong $e')),
                                  );
                                }
                              },
                            );
                          }
                        },
                      ),

                      SettingsCard(
                        iconPath: 'assets/power-on.png',
                        subtitle: 'Turn off your robot completely',
                        title: 'POWER OFF',
                        backgroundColor: Colors.white,
                        onTap: () async {
                          final shouldTurnOff = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              backgroundColor: Colors.white,
                              title: Text(
                                'Power Off',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black87,
                                ),
                              ),
                              content: Text(
                                'Are you sure you want to turn off the robot?',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey[700],
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                  ),
                                  child: Text('Cancel',
                                      style: TextStyle(fontSize: 14)),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text('Turn Off',
                                      style: TextStyle(fontSize: 14)),
                                ),
                              ],
                            ),
                          );

                          if (shouldTurnOff == true) {
                            try {
                              Map<String, dynamic> resp =
                                  await ApiServices.logout()
                                      .timeout(Duration(seconds: 3));

                              if (resp['message'] == "Robot turned OFF") {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => LoadingSplash()),
                                    (_) => false);
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Something went wrong $e')),
                              );
                            }
                          }
                        },
                      ),
                      SettingsCard(
                        iconPath: 'assets/exit.png',
                        subtitle: 'Exit app and close everything',
                        title: 'EXIT',
                        backgroundColor: Colors.white,
                        onTap: () async {
                          final shouldExit = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              backgroundColor: Colors.white,
                              title: Text(
                                'Exit App',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black87,
                                ),
                              ),
                              content: Text(
                                'Are you sure you want to exit the app?',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              actionsPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey[700],
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await SharedPrefs().removeLoginData();
                                    exit(0);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Exit',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (shouldExit == true) {
                            await SharedPrefs().removeLoginData();
                            exit(0);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GetX<BatteryController>(
            builder: (controller) {
              return Positioned(
                right: 0,
                bottom: 0,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: Text(
                    "Version: 2.0.4",
                    style: GoogleFonts.poppins(
                        color: controller.foregroundColor.value,
                        fontSize: 10.h),
                  ),
                ),
              );
            },
          ),
          Column(
            children: [
              Header(
                isBack: true,
                screenName: "SETTINGS",
              ),
            ],
          ),
          if (isLoading)
            Center(
              child: Container(
                  width: 200,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueGrey)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Please wait...",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )),
            ),
        ],
      ),
    );
  }
}

Widget buildInfoCard(Size size, String title, {Color color = Colors.black}) {
  return Container(
    width: size.width * 0.20,
    padding: EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      border: Border.all(color: Colors.blue),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade400,
          spreadRadius: 1,
          blurRadius: 5,
        ),
      ],
    ),
    height: 55,
    child: Center(
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

void openAnotherApp() async {
  const packageName = "com.slamtec.robostudio";
  final Uri androidUri = Uri.parse(
    "intent://#Intent;package=$packageName;end;",
  );
  try {
    if (await canLaunchUrl(Uri.parse("android-app://$packageName"))) {
      await launchUrl(Uri.parse("android-app://$packageName"));
      return;
    }

    if (await canLaunchUrl(androidUri)) {
      await launchUrl(androidUri);
      return;
    }

    // Open Play Store if the app is not installed
    await launchUrl(
      Uri.parse(
        "https://play.google.com/store/apps/details?id=$packageName",
      ),
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    print("Error launching app: $e");
  }
}

class SettingsCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color? backgroundColor; // ✅ New: for background color
  final Color? titleColor; // ✅ New: for title text color
  final Color? subtitleColor; // ✅ New: for subtitle text color

  const SettingsCard({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.backgroundColor,
    this.titleColor,
    this.subtitleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white, // ✅ use given or default
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(iconPath, width: 35.h),
              const SizedBox(height: 15),
              Text(
                title,
                style: TextStyle(
                  fontSize: 19.h,
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? Colors.black, // ✅ use given or default
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16.h,
                  fontWeight: FontWeight.bold,
                  color:
                      subtitleColor ?? Colors.black54, // ✅ use given or default
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
