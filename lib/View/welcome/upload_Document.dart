import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ihub/Controller/FulltourController.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Utils/api_constant.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/Utils/pinning_helper.dart';
import 'package:ihub/Utils/toast.dart';

import '../../Service/Api_Service.dart';

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  File? _selectedFile;
  String roboId = '';
  bool isLoading = false;
  String fileName = '';

  @override
  void initState() {
    _loadMap();
    super.initState();
  }

  Future<void> _loadMap() async {
    try {
      if (Get.find<BatteryController>().roboId == null) return;

      isLoading = true;
      setState(() {});

      roboId = Get.find<BatteryController>().roboId;
      var response = await ApiServices.fetchUploadedMap(robotId: 'RB8');

      if (response['stcm_file_path'] != null) {
        fileName = response['stcm_file_path'].toString().split('/').last;
      }
      setState(() {});
    } catch (e) {
      print('error $e');
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  Future<void> _pickFile() async {
    String? initialDirectory = "/storage/emulated/0/Download";
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      initialDirectory: initialDirectory,
    );

    if (result != null) {
      _selectedFile = File(result.files.single.path!);
      showTopRightToast(
          color: Colors.green,
          context: context,
          message: "Map selected: ${result.files.single.name}");
    } else {
      showTopRightToast(
          color: Colors.black,
          context: context,
          message: 'No file was selected');
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      showTopRightToast(
          color: Colors.orange,
          context: context,
          message: 'Please select a file before upload.');

      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.localIp}/stcm_files/create/'),
      );

      request.files.add(await http.MultipartFile.fromPath(
          'stcm_file_path', _selectedFile!.path));
      request.fields['robot_id'] = roboId;

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        showTopRightToast(
            color: Colors.green,
            context: context,
            message: 'Map uploaded successfully!');
      } else {
        showTopRightToast(
            color: Colors.red,
            context: context,
            message: 'Upload failed: $responseBody');
      }
    } catch (e) {
      showTopRightToast(
          color: Colors.red, context: context, message: 'Something went wrong');
    }
  }

  _deleteMap() async {
    try {
      Map<String, dynamic> resp =
          await ApiServices.deleteFileLocal(robotId: roboId);

      if (resp['status'] == "ok") {
        showTopRightToast(
            color: Colors.green,
            context: context,
            message: resp['detail'] ?? "Map deleted successfully");
        _selectedFile = null;
      } else {
        showTopRightToast(
            color: Colors.red,
            context: context,
            message: resp['detail'] ?? "Map already deleted");
        _selectedFile = null;
      }
    } catch (e) {
      showTopRightToast(
          color: Colors.red, context: context, message: "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        "icon": "assets/select.png",
        "title": "SELECT MAP",
        "subtitle": "Select a map file from your device",
        "onTap": () async {
          await LockTaskService.stopLockTask();
          await _pickFile();
          await LockTaskService.startLockTask();
        }
      },
      {
        "icon": "assets/upload.png",
        "title": "UPLOAD MAP",
        "subtitle": "Upload the selected map to the robot",
        "onTap": _uploadFile,
      },
      {
        "icon": "assets/delete.png",
        "title": "DELETE MAP",
        "subtitle": "Delete the map from the robot",
        "onTap": () {
          Get.dialog(
            Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                width: 400,
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
      {
        "icon": "assets/reload.png",
        "title": "REFRESH",
        "subtitle": "Refresh the map services",
        "onTap": () async {
          Get.dialog(Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 400,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            FullTourControllerNew fullTourController =
                                Get.find();
                            fullTourController.clearData();
                            fullTourController.newDataNavigation.refresh();

                            Map<String, dynamic> response =
                                await ApiServices.mapRestart();

                            if (response['updated_data']['status'] == true) {
                              isLoading = true;
                              setState(() {});

                              await Future.delayed(Duration(seconds: 20));

                              isLoading = false;
                              setState(() {});

                              FullTourControllerNew fullTourController =
                                  Get.find();
                              fullTourController.clearData();
                            } else {
                              showTopRightToast(
                                  color: Colors.red,
                                  context: context,
                                  message: 'Map not restarted');
                            }
                          } catch (e) {
                            showTopRightToast(
                                color: Colors.red,
                                context: context,
                                message: 'Something went wrog!');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          "Yes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
        }
      }
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF608878).withOpacity(0.2),
                  Color(0xFF18221E).withOpacity(0.2),
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.transparent),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[600]?.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: ChildGlasmorphism(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          spacing: 10,
                          children: [
                            Icon(
                              Icons.map_outlined,
                              color: fileName.isNotEmpty
                                  ? Colors.green
                                  : Colors.white,
                            ),
                            Text(
                              fileName.isNotEmpty
                                  ? fileName
                                  : "No Map uploaded",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // avoids overflow
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
                  child: GridView.builder(
                    itemCount: actions.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 2,
                    ),
                    itemBuilder: (context, index) {
                      final action = actions[index];
                      return GestureDetector(
                        onTap:
                            !isLoading ? action["onTap"] as VoidCallback : null,
                        child: ChildGlasmorphism(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 10,
                            children: [
                              Image.asset(action["icon"] as String,
                                  width: 50, color: Colors.white),
                              Text(
                                action["title"] as String,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                action["subtitle"] as String,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
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
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 3,
                        ),
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
    );
  }
}
