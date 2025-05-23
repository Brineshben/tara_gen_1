import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl1}/stcm_files/create/'),
      // Uri.parse('http://192.168.1.31:8000/stcm_files/create/'),
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

      print('deletemapresponcelocal $resp');
      print('robotIdddddddddddd $roboId');

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
                child: CachedNetworkImage(
                  imageUrl:
                      controller.backgroundModel.value?.backgroundImage ?? "",
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Image.asset(controller.defaultIMage, fit: BoxFit.cover),
                  errorWidget: (context, url, error) =>
                      Image.asset(controller.defaultIMage, fit: BoxFit.cover),
                ),
              );
            },
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 100),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white,
                            highlightColor: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20.r),
                            child: buildInfoCard(size, 'SELECT MAP'),
                            onTap: () async {
                              await LockTaskService.stopLockTask();
                              await Future.delayed(Duration(milliseconds: 300));
                              await _pickFile();
                              await LockTaskService.startLockTask();
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white,
                            highlightColor: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20.r),
                            child: buildInfoCard(size, 'UPLOAD MAP'),
                            onTap: () {
                              _uploadFile();
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white,
                            highlightColor: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20.r),
                            child: buildInfoCardRed(size, 'DELETE MAP'),
                            onTap: () {
                              _deleteMap();
                            },
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
                screenName: "MANAGE MAP", page: false,
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          icon: Icon(Icons.refresh, color: Colors.black),
          label: Text(
            'Refresh',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () async {
            Map response = await ApiServices.mapRestart();
            if (response['updated_data']['status'] == true) {
              Get.snackbar(
                'Success',
                'Map restarted successfully!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: Duration(seconds: 2),
                margin: EdgeInsets.all(20),
              );
            } else {
              Get.snackbar(
                'Failed',
                'Map not restarted',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: Duration(seconds: 2),
                margin: EdgeInsets.all(20),
              );
            }
          },
        ),
      ),
    );
  }
}

Widget buildInfoCardRed(Size size, String title) {
  return Ink(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.red, Colors.red],
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
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18.h,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
