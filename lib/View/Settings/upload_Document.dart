import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Utils/api_constant.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/Utils/pinning_helper.dart';
import 'package:ihub/View/Home_Screen/battery_Widget.dart';
import 'package:ihub/View/Settings/settings.dart';
import 'package:lottie/lottie.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Service/Api_Service.dart';
import '../../Utils/popups.dart';

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  File? _selectedFile;
  String roboId = '';
  @override
  void initState() {
    if (Get.find<BatteryController>().roboId != null) {
      roboId = Get.find<BatteryController>().roboId;
    }
    super.initState();
  }

  Future<void> _pickFile() async {
    String? initialDirectory = "/storage/emulated/0/Download";
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      initialDirectory: initialDirectory, // Specify the initial directory
    );

    if (result != null) {
      _selectedFile = File(result.files.single.path!);
      Get.snackbar(
        'SELECTED',
        'Map selected: ${result.files.single.name}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
        margin: EdgeInsets.all(20),
      );
    } else {
      Get.snackbar(
        'CANCELLED',
        'No file was selected.',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
        margin: EdgeInsets.all(20),
      );
    }
  }

// upload map to server
  // Future<void> _uploadFileToServer() async {
  //   if (_selectedFile == null) {
  //     Get.snackbar(
  //       'Warning',
  //       'Please select a file before attempting to upload.',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.orange,
  //       colorText: Colors.white,
  //       duration: Duration(seconds: 2),
  //       margin: EdgeInsets.all(20),
  //     );
  //     return;
  //   }

  //   print("idididididididididid${roboId}");
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse('http://54.211.212.147/stcm_files/create/'),
  //   );

  //   request.files.add(
  //     await http.MultipartFile.fromPath('stcm_file_path', _selectedFile!.path),
  //   );
  //   request.fields['robot_id'] = roboId;

  //   var response = await request.send();
  //   if (response.statusCode == 201) {
  //     Get.snackbar(
  //       'UPLOADED',
  //       'Map uploaded successfully!',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.green,
  //       colorText: Colors.white,
  //       duration: Duration(seconds: 5),
  //       margin: EdgeInsets.all(20),
  //     );
  //   } else {
  //     Get.snackbar(
  //       'FAILED',
  //       'File upload failed! Status: ${response.statusCode}',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       duration: Duration(seconds: 2),
  //       margin: EdgeInsets.all(20),
  //     );
  //   }
  // }

// delelete map from server
  // _deleteMapServer() async {
  //   Map<String, dynamic> resp = await ApiServices.deleteFileServer(
  //     status: true,
  //     robotId: roboId,
  //   );

  //   print('deletemapresponceserver ${resp}');

  //   if (resp['status'] == true) {
  //     FocusManager.instance.primaryFocus?.unfocus();
  //     ProductAppPopUps.submit(
  //       title: "SUCCESS",
  //       message: resp['message'].toString(),
  //       actionName: "Close",
  //       iconData: Icons.done,
  //       iconColor: Colors.green,
  //     );
  //   } else {
  //     ProductAppPopUps.submit(
  //       title: "Failed",
  //       message: resp['message'].toString(),
  //       actionName: "Close",
  //       iconData: Icons.error_outline,
  //       iconColor: Colors.red,
  //     );
  //   }
  // }

// upload map to local
  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      Get.snackbar(
        'Warning',
        'Please select a file before attempting to upload.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(20),
      );
      return;
    }

    print("Selected Robot ID: $roboId");

    var request = await http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl1}/stcm_files/create/'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('stcm_file_path', _selectedFile!.path),
    );

    request.fields['robot_id'] = roboId;

    var response = await request.send();

    final responseBody = await response.stream.bytesToString();
    print('Response status upload map: ${response.statusCode}');
    print('Response body: $responseBody');

    final decodedBody = json.decode(responseBody);

    try {
      if (response.statusCode == 201) {
        Get.snackbar(
          'UPLOADED',
          'Map uploaded successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
          margin: EdgeInsets.all(20),
        );
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Client error
        final error =
            decodedBody['robot_id']?.join(', ') ?? 'Client error occurred';
        Get.snackbar(
          'FAILED',
          'Client Error: $error',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
          margin: EdgeInsets.all(20),
        );
      } else if (response.statusCode >= 500) {
        // Server error
        Get.snackbar(
          'FAILED',
          'Server Error! Please try again later.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
          margin: EdgeInsets.all(20),
        );
      } else {
        Get.snackbar(
          'FAILED',
          'Unexpected error!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
          margin: EdgeInsets.all(20),
        );
      }
    } on SocketException {
      Get.snackbar(
        'NO INTERNET',
        'Please check your connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
        margin: EdgeInsets.all(20),
      );
    } on TimeoutException {
      Get.snackbar(
        'TIMEOUT',
        'Connection timed out.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
        margin: EdgeInsets.all(20),
      );
    } catch (e) {
      Get.snackbar(
        'ERROR',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
        margin: EdgeInsets.all(20),
      );
    }
  }

  // DELETE MAP FROM LOCAL
  _deleteMap() async {
    try {
      Map<String, dynamic> resp = await ApiServices.deleteFileLocal(
        robotId: roboId,
      );

      if (resp['status'] == "ok") {
        FocusManager.instance.primaryFocus?.unfocus();
        ProductAppPopUps.submit(
          title: "SUCCESS",
          message: resp['detail'] ?? "Map deleted successfully",
          actionName: "Close",
          iconData: Icons.done,
          iconColor: Colors.green,
        );
        _selectedFile = null;
      } else {
        print('mapdelete ${resp['detail']}');
        ProductAppPopUps.submit(
          title: "Failed",
          message: resp['detail'] ?? "Something went wrong!",
          actionName: "Close",
          iconData: Icons.error_outline,
          iconColor: Colors.red,
        );
        _selectedFile = null;
      }
    } catch (e) {
      print('Error in _deleteMap: $e');
      ProductAppPopUps.submit(
        title: "Error",
        message: "Something went wrong: $e",
        actionName: "Close",
        iconData: Icons.error_outline,
        iconColor: Colors.red,
      );
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
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        color: Colors.black.withOpacity(0),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 20,
                children: [
                  SizedBox(height: 100),
                  Row(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SettingsCard(
                        iconPath: 'assets/select.png',
                        subtitle: "Select a map file from your device",
                        title: 'SELECT MAP',
                        backgroundColor: Colors.white,
                        onTap: () async {
                          await LockTaskService.stopLockTask();
                          await Future.delayed(Duration(milliseconds: 300));
                          await _pickFile();
                          await LockTaskService.startLockTask();
                        },
                      ),
                      SettingsCard(
                        iconPath: 'assets/upload.png',
                        subtitle: "Upload the selected map to the robot",
                        title: 'UPLOAD MAP',
                        backgroundColor: Colors.white,
                        onTap: () {
                          _uploadFile();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      SettingsCard(
                        iconPath: 'assets/delete.png',
                        subtitle: "Delete the map from the robot",
                        title: 'DELETE MAP',
                        backgroundColor: Colors.white,
                        onTap: () {
                          Get.dialog(
                            Dialog(
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
                                      "assets/delete.png",
                                      width: 60,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "DELETE MAP?",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Are you sure you want to delete the map from the robot? This action cannot be undone",
                                      style: TextStyle(fontSize: 14),
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
                                            _deleteMap();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
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
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Header(
                isBack: true,
                screenName: "MANAGE MAP",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
