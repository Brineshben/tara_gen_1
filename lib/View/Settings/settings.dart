import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ihub/Controller/FulltourController.dart';
import 'package:ihub/Controller/Login_api_controller.dart';
import 'package:ihub/Utils/api_constant.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/Utils/pinning_helper.dart';
import 'package:ihub/Utils/web_view.dart';
import 'package:ihub/View/Settings/add_url.dart';
import 'package:ihub/View/Settings/charge_screen.dart';
import 'package:ihub/View/Settings/crop_image.dart';
import 'package:ihub/View/Settings/description_option.dart';
import 'package:ihub/View/Settings/list_of_mode.dart';
import 'package:ihub/View/Settings/prompt_list_page.dart';
import 'package:ihub/View/Settings/upload_Document.dart';
import 'package:ihub/View/Splash/Loading_Splash.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/battery_Controller.dart';
import '../../Service/Api_Service.dart';
import '../../Service/sharedPreference.dart';
import '../../Utils/popups.dart';
import '../Login_Page/login.dart' as login_page;
import '../Robot_Response/language_list.dart';
import 'ApiKey.dart';
import 'Volume_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static final GlobalKey<_SettingsPageState> globalKey =
      GlobalKey<_SettingsPageState>();

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    _hideSystemUI();
    super.initState();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive); // Hide status bar again
  }

  bool isLoading = false;

  Future<void> pickImageFromDownloads() async {
    isLoading = true;
    String? initialDirectory = "/storage/emulated/0/Download";

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      initialDirectory: initialDirectory,
    );

    if (result != null && result.files.single.path != null) {
      File originalImage = File(result.files.single.path!);

      final croppedImage = await Navigator.push<File?>(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CropAndPreviewScreen(originalImage: originalImage),
        ),
      );

      if (croppedImage != null) {
        await processImageForColor(croppedImage);
        await uploadImage(croppedImage);
      } else {
        Get.snackbar(
          margin: EdgeInsets.all(10),
          'CANCELLED',
          'Cropping cancelled.',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
        );

        await LockTaskService.startLockTask();
      }
    }
    isLoading = false;
  }

  Future<void> processImageForColor(File originalFile) async {
    final avgColor = await getAverageColor(originalFile);
    final brightness = ThemeData.estimateBrightnessForColor(avgColor);
    Get.find<BatteryController>().foregroundColor.value =
        brightness == Brightness.dark ? Colors.white : Colors.black;
    print("Average color: $avgColor, brightness: $brightness");
  }

  Future<Color> getAverageColor(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return Colors.transparent;

    final Uint8List pixels = byteData.buffer.asUint8List();
    int length = pixels.lengthInBytes;

    int r = 0, g = 0, b = 0, count = 0;

    for (int i = 0; i < length; i += 4) {
      r += pixels[i];
      g += pixels[i + 1];
      b += pixels[i + 2];
      count++;
    }
    return Color.fromARGB(255, r ~/ count, g ~/ count, b ~/ count);
  }

// upload image
  Future<void> uploadImage(File imageFile) async {
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

        showDialog(
          context: context,
          builder: (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 60,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Success!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    jsonResponse['message'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
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

  bool isTraining = false;
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
            padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height * 0.2,
              right: 50,
              left: 50,
            ),
            child: SingleChildScrollView(
              child: Center(
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

                        // SettingsCard(
                        //   iconPath: "assets/arrow.png",
                        //   subtitle: 'Control robot movement',
                        //   title: "NAVIGATIONS",
                        //   backgroundColor: Colors.white,
                        //   onTap: () {
                        //     Navigator.push(context, MaterialPageRoute(
                        //       builder: (context) {
                        //         return Navigation(
                        //           robotid: Get.find<BatteryController>()
                        //                   .background
                        //                   .value
                        //                   ?.data
                        //                   ?.first
                        //                   .robot
                        //                   ?.roboId ??
                        //               "",
                        //         );
                        //       },
                        //     ));
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
                              await pickImageFromDownloads();
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
                          iconPath: 'assets/reload.png',
                          subtitle: "Refresh the map services",
                          title: 'REFRESH',
                          backgroundColor: Colors.white,
                          onTap: () async {
                            Get.dialog(Dialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                width: 300,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      "assets/reload.png",
                                      width: 60,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "REFRESH MAP",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Refreshing the map may take 2 to 3 minutes. Are you sure you want to continue?",
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Make sure the robot is at the charging dock before proceeding.",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => Get.back(),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.red,
                                            backgroundColor: Colors.white,
                                          ),
                                          child: const Text("No"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            Get.back();
                                            try {
                                              FullTourControllerNew
                                                  fullTourController =
                                                  Get.find();
                                              fullTourController.clearData();
                                              fullTourController
                                                  .newDataNavigation
                                                  .refresh();

                                              Map<String, dynamic> response =
                                                  await ApiServices
                                                      .mapRestart();

                                              if (response['updated_data']
                                                      ['status'] ==
                                                  true) {
                                                isLoading = true;
                                                setState(() {});

                                                await Future.delayed(
                                                    Duration(seconds: 10));

                                                isLoading = false;
                                                setState(() {});

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Row(
                                                      children: [
                                                        Icon(Icons.check_circle,
                                                            color:
                                                                Colors.white),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Restarting the map...',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    backgroundColor:
                                                        Colors.green.shade600,
                                                    duration:
                                                        Duration(seconds: 5),
                                                    elevation: 4,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.zero,
                                                    ),
                                                  ),
                                                );

                                                FullTourControllerNew
                                                    fullTourController =
                                                    Get.find();
                                                fullTourController.clearData();
                                              } else {
                                                Get.snackbar(
                                                  'Failed',
                                                  'Map not restarted',
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white,
                                                  duration:
                                                      Duration(seconds: 2),
                                                  margin: EdgeInsets.all(20),
                                                );
                                              }
                                            } catch (e) {
                                              Get.snackbar(
                                                'Failed',
                                                '$e',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                                duration: Duration(seconds: 2),
                                                margin: EdgeInsets.all(20),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          child: const Text(
                                            "Yes",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ));
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
                                            .batteryModel
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
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
                                    onPressed: () =>
                                        Navigator.pop(context, true),
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
                                      setState(() {
                                        isLoading = true;
                                      });
                                      Future.delayed(Duration(seconds: 4), () {
                                        setState(() {});
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoadingSplash()),
                                                (_) => false);
                                      });
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
                                    onPressed: () =>
                                        Navigator.pop(context, true),
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
                                          builder: (context) =>
                                              LoadingSplash()),
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
                          subtitle: 'Logout app and close everything',
                          title: 'LOGOUT',
                          backgroundColor: Colors.white,
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                backgroundColor: Colors.white,
                                title: Text(
                                  'Logout App',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to logout the app?',
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
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                login_page.LoginPage()),
                                        (route) => false,
                                      );
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
                                      'Logout',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
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
                    "Version: 2.5.10",
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
                    border: Border.all(color: Colors.blueGrey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Loading...",
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
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.deepPurple, width: 2),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListofMode()),
            );
          },
          borderRadius: BorderRadius.circular(30),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.swap_horiz, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text(
                "Switch Mode",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildInfoCard(
  Size size,
  String title, {
  Color color = Colors.black,
  required VoidCallback onTap,
}) {
  return Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    elevation: 2,
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      highlightColor: Colors.green.withOpacity(0.3),
      splashColor: Colors.blue.withOpacity(0.3),
      onTap: onTap,
      child: Container(
        width: size.width * 0.22,
        height: 55,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue),
        ),
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
        splashColor: Colors.blue.withOpacity(0.3),
        highlightColor: Colors.green.withOpacity(0.3),
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
