import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ihub/Controller/Login_api_controller.dart';
import 'package:ihub/Utils/api_constant.dart';
import 'package:ihub/View/Settings/add_url.dart';
import 'package:ihub/View/Settings/charge_screen.dart';
import 'package:ihub/View/Settings/description_option.dart';
import 'package:ihub/View/Settings/prompt_list_page.dart';
import 'package:ihub/View/Settings/upload_Document.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/battery_Controller.dart';
import '../../Service/Api_Service.dart';
import '../../Service/sharedPreference.dart';
import '../../Utils/colors.dart';
import '../../Utils/popups.dart';
import '../Login_Page/login.dart' as login_page;
import '../Robot_Response/Fulltour_dart.dart';
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

  File? _imageFile;
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      File compressedImage = await _compressImage(File(pickedFile.path));

      setState(() {
        _imageFile = compressedImage;
      });

      _uploadImage(_imageFile!);
    }
  }

  Future<File> _compressImage(File file) async {
    final rawImage = img.decodeImage(await file.readAsBytes());
    if (rawImage == null) return file;

    final compressedBytes =
        img.encodeJpg(rawImage, quality: 75); // 0-100 quality
    final compressedFile = await file.writeAsBytes(compressedBytes);

    return compressedFile;
  }

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
        ProductAppPopUps.submit(
            message: jsonResponse['message'],
            actionName: "close",
            iconData: Icons.check,
            iconColor: Colors.green);

        Get.find<BackgroudController>().fetchBackground(
            Get.find<UserAuthController>().loginData.value?.user?.id ?? 0);
      }
    } catch (e) {
      print('Errorbgupload $e');
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

            /// Main Content
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
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
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  await SharedPrefs().removeLoginData();
                                },
                                child: Text(
                                  "SETTINGS",
                                  style: GoogleFonts.oxygen(
                                      color: Colors.white,
                                      fontSize: 25.h,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     gradient: LinearGradient(
                        //       colors: [Colors.red, Colors.red],
                        //       begin: Alignment.topLeft,
                        //       end: Alignment.bottomRight,
                        //     ),
                        //     borderRadius: BorderRadius.circular(
                        //         10), // Ensure proper border radius
                        //   ),
                        //   child: Material(
                        //     color: Colors
                        //         .transparent, // Ensure the gradient is visible
                        //     borderRadius: BorderRadius.circular(10),
                        //     child: FloatingActionButton.extended(
                        //       backgroundColor: Colors.transparent,
                        //       onPressed: () {
                        //         exit(0);
                        //       },
                        //       icon: Icon(Icons.arrow_forward_ios,
                        //           color: Colors.white),
                        //       label: Text("EXIT APP",
                        //           style: GoogleFonts.poppins(
                        //             color: Colors.white,
                        //             fontSize: 18.h,
                        //             fontWeight: FontWeight.bold,
                        //           )),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                      bottom: 20,
                      right: 20,
                      left: 20,
                    ),
                    child: Wrap(
                      spacing: 20.0, // Horizontal space between items
                      runSpacing: 20.0, // Vertical space between rows
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
                          iconPath: 'assets/key.png',
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
                          iconPath: 'assets/robo.png',
                          subtitle: 'Preparing for mapping',
                          title: 'MAPPING',
                          backgroundColor: Colors.white,
                          onTap: () {
                            openAnotherApp();
                          },
                        ),
                        SettingsCard(
                          iconPath: 'assets/change.png',
                          subtitle: 'Select and set a new wallpaper',
                          title: 'CHANGE WALLPAPER',
                          backgroundColor: Colors.white,
                          onTap: () async {
                            await _pickImage();
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
                          subtitle: 'Manage system prompts and responses',
                          title: 'SYSTEM PROMPT',
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
                          iconPath: 'assets/destination.png',
                          subtitle: "Create a new full tour itinerary",
                          title: 'ADD FULL TOUR',
                          backgroundColor: Colors.white,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ListAnimationdData()));
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
                          subtitle: 'Restart your device to refresh settings',
                          title: 'RESTART',
                          backgroundColor: Colors.white,
                          onTap: () {
                            login_page.checkInternet2(
                              context: context,
                              function: () async {
                                try {
                                  Map<String, dynamic> resp =
                                      await ApiServices.logoutoffline(true)
                                          .timeout(Duration(seconds: 3));
                                  if (resp['message'] ==
                                      "Reboot status updated") {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    ProductAppPopUps.submitLogOut2(
                                      title: "SUCCESS",
                                      message: "Robot Restarted",
                                      actionName: "OK",
                                      iconData: Icons.done,
                                      iconColor: Colors.green,
                                      context: context,
                                    );
                                  } else {
                                    ProductAppPopUps.submit(
                                      title: "FAILED",
                                      message: "Api Response Issue",
                                      actionName: "Close",
                                      iconData: Icons.info_outline,
                                      iconColor: Colors.red,
                                    );
                                  }
                                } catch (e) {
                                  ProductAppPopUps.submit(
                                    title: "FAILED",
                                    message: "Something went wrong.",
                                    actionName: "Close",
                                    iconData: Icons.info_outline,
                                    iconColor: Colors.red,
                                  );
                                }
                              },
                            );
                          },
                        ),
                        SettingsCard(
                          iconPath: 'assets/power-on.png',
                          subtitle: 'Turn off your device completely',
                          title: 'POWER OFF',
                          backgroundColor: Colors.white,
                          onTap: () async {
                            try {
                              Map<String, dynamic> resp =
                                  await ApiServices.logout()
                                      .timeout(Duration(seconds: 3));
                              print("POWERPOWERPOWER$resp");
                              if (resp['message'] == "Robot turned OFF") {
                                FocusManager.instance.primaryFocus?.unfocus();
                                ProductAppPopUps.submitLogOut(
                                  title: "SUCCESS",
                                  message: resp['message'].toString(),
                                  actionName: "Close",
                                  iconData: Icons.done,
                                  iconColor: Colors.green,
                                  context: context,
                                );
                              } else {
                                ProductAppPopUps.submit(
                                  title: "FAILED",
                                  message: "Api issue",
                                  actionName: "Close",
                                  iconData: Icons.info_outline,
                                  iconColor: Colors.red,
                                );
                              }
                            } catch (e) {
                              ProductAppPopUps.submit(
                                title: "FAILED",
                                message: "Something went wrong.",
                                actionName: "Close",
                                iconData: Icons.info_outline,
                                iconColor: Colors.red,
                              );
                            }
                          },
                        ),
                        SettingsCard(
                          iconPath: 'assets/exit.png',
                          subtitle: 'Exit and close everything',
                          title: 'Exit',
                          backgroundColor: Colors.white,
                          onTap: () async {
                            exit(0);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

Widget buildInfoCard(Size size, String title) {
  return Ink(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [ColorUtils.userdetailcolor, ColorUtils.userdetailcolor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [
        BoxShadow(
          color: Colors.white,
          spreadRadius: 0,
          blurRadius: 0,
          offset: Offset(0, 0),
        ),
      ],
    ),
    width: size.width * 0.28,
    height: size.height * 0.08,
    child: Center(
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
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
            border: Border.all(color: Colors.blueGrey.shade200, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(iconPath, width: 30),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? Colors.black, // ✅ use given or default
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
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
