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
import 'package:ihub/Controller/RobotresponseApi_controller.dart';
import 'package:ihub/Utils/api_constant.dart';
import 'package:ihub/View/Settings/add_url.dart';
import 'package:ihub/View/Settings/charge_screen.dart';
import 'package:ihub/View/Settings/upload_Document.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/battery_Controller.dart';
import '../../Service/Api_Service.dart';
import '../../Service/sharedPreference.dart';
import '../../Utils/colors.dart';
import '../../Utils/popups.dart';
import '../Login_Page/login.dart' as login_page;
import '../Robot_Response/Fulltour_dart.dart';
import 'Add_Description.dart';
import 'ApiKey.dart';
import 'Volume_page.dart';

class Maintanance extends StatefulWidget {
  const Maintanance({Key? key}) : super(key: key);

  @override
  State<Maintanance> createState() => _MaintananceState();
}

class _MaintananceState extends State<Maintanance> {
  static const _platform = MethodChannel('com.example.ihub/channel');

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

  // Future<void> _uploadImage(File imageFile) async {
  //   try {
  //     final url =
  //         '${ApiConstants.baseUrl}/accounts/upload/background/${Get.find<UserAuthController>().loginData.value?.user?.id}';
  //     print('backgroundid $url');

  //     var request = http.MultipartRequest('POST', Uri.parse(url));

  //     request.files.add(
  //       await http.MultipartFile.fromPath(
  //         'background_image',
  //         imageFile.path,
  //       ),
  //     );

  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);

  //     print('bguploadrespo ${response.body}');

  //     var jsonResponse = jsonDecode(response.body);

  //     if (jsonResponse['status'] == 'ok') {
  //       Get.snackbar(
  //         "Success",
  //         "Background image uploaded successfully and replaced the old one",
  //       );
  //     } else {
  //       Get.snackbar(
  //         "Error",
  //         "Image size too large. Please upload a smaller image",
  //       );
  //     }
  //   } catch (e) {
  //     print('Errorbgupload $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('something went wrong!')),
  //     );
  //   }
  // }

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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                    padding: const EdgeInsets.only(left: 20, top: 40),
                    child: Row(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
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
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white,
                            highlightColor: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20.r),
                            child: buildInfoCard(size, 'API KEY'),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                      Duration(milliseconds: 300),
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
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
                        ),
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
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white,
                            highlightColor: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20.r),
                            child: buildInfoCard(size, 'MAPPING'),
                            onTap: () {
                              // NativeBridge.openExternalApp();
                              //
                              // // openExternalApp();
                              // openAnotherApp();
                            },
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white,
                            highlightColor: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20.r),
                            child: buildInfoCard(size, 'CHANGE WALLPAPER'),
                            onTap: () async {
                              await _pickImage();
                            },
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white,
                            highlightColor: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20.r),
                            child: buildInfoCard(size, 'UPLOAD MAP'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FileUploadScreen()));
                            },
                          ),
                        ),

                        // charge

                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white,
                            highlightColor: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20.r),
                            child: buildInfoCard(size, 'CHARGE'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChargeEntryView()));
                            },
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white,
                            highlightColor: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20.r),
                            child: buildInfoCard(size, 'ADD DESCRIPTION'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddDescription()));
                            },
                          ),
                        ),

                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white,
                            highlightColor: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20.r),
                            child: buildInfoCard(size, 'ADD WEB LINK'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddUrlPage()));
                            },
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white,
                            highlightColor: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20.r),
                            child: buildInfoCard(size, 'ADD FULL TOUR'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ListAnimationdData()));
                            },
                          ),
                        ),
                        // GestureDetector(
                        //   child: buildInfoCard(size, 'REBOOT'),
                        //   onTap: () async {
                        //       Map<String, dynamic> resp = await ApiServices
                        //           .Reboot(true);
                        //       print("POWERPOWERPOWER$resp");
                        //       if (resp['status'] == true) {
                        //         FocusManager.instance.primaryFocus?.unfocus();
                        //         ProductAppPopUps.submit(
                        //           title: "SUCCESS",
                        //           message: resp['message'].toString(),
                        //           actionName: "Close",
                        //           iconData: Icons.done,
                        //           iconColor: Colors.green,
                        //         );
                        //       } else {
                        //         ProductAppPopUps.submit(
                        //           title: "FAILED",
                        //           message: "Something went wrong.",
                        //           actionName: "Close",
                        //           iconData: Icons.info_outline,
                        //           iconColor: Colors.red,
                        //         );
                        //       }
                        //
                        //   },
                        // ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white,
                            highlightColor: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20.r),
                            child: buildInfoCard(size, 'VOLUME'),
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
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white,
                            highlightColor: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20.r),
                            child: buildInfoCardGREEN(size, 'RESTART'),
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
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white,
                            highlightColor: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20.r),
                            child: buildInfoCardRed(size, 'POWER OFF'),
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
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(
              left: 30.w, top: 120.h, right: 20.w, bottom: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.circular(10), // Ensure proper border radius
                ),
                child: Material(
                  color: Colors.transparent, // Ensure the gradient is visible
                  borderRadius: BorderRadius.circular(10),
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      exit(0);
                    },
                    icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                    label: Text("EXIT APP",
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontSize: 18.h,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ),
            ],
          ),
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
    height: size.height * 0.075,
    child: Center(
      child: Text(
        title,
        style: GoogleFonts.orbitron(
          color: Colors.white,
          fontSize: 18.h,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
// void openAnotherApp() async {
//   const packageName = "com.slamtec.robostudio";
//   final Uri androidUri =
//   Uri.parse("intent://#Intent;package=$packageName;end;");
//
//   try {
//     if (await canLaunchUrl(Uri.parse("android-app://$packageName"))) {
//       await launchUrl(Uri.parse("android-app://$packageName"));
//       return;
//     }
//
//     if (await canLaunchUrl(androidUri)) {
//       await launchUrl(androidUri);
//       return;
//     }
//
//     // Open Play Store if the app is not installed
//     await launchUrl(
//       Uri.parse("https://play.google.com/store/apps/details?id=$packageName"),
//       mode: LaunchMode.externalApplication,
//     );
//   } catch (e) {
//     print("Error launching app: $e");
//   }
// }

Widget buildInfoCardGREEN(Size size, String title) {
  return Ink(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.green, Colors.green],
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
    height: size.height * 0.075,
    child: Center(
      child: Text(
        title,
        style: GoogleFonts.orbitron(
          color: Colors.white,
          fontSize: 18.h,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

class NativeBridge {
  static const platform = MethodChannel('com.example.ihub/channel');

  static Future<void> openExternalApp() async {
    try {
      await platform.invokeMethod('openAnotherApp');
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
    }
  }
}
