import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihub/Controller/battery_Controller.dart';
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
  String _statusMessage = "";

  Future<void> _pickFile() async {
    String? initialDirectory = "/storage/emulated/0/Download";

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      initialDirectory: initialDirectory, // Specify the initial directory
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _statusMessage = "File selected: ${result.files.single.name}";
      });
    } else {
      setState(() {
        _statusMessage = "No file selected.";
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      setState(() {
        _statusMessage = "Please select a file first.";
      });
      return;
    }

    String id = Get.find<BatteryController>().roboId;
    print("idididididididididid${id}");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://54.211.212.147/enquiry/upload-stcm/$id/'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', _selectedFile!.path),
    );

    var response = await request.send();
    if (response.statusCode == 201) {
      setState(() {
        _statusMessage = "File uploaded successfully!";
      });
    } else {
      setState(() {
        _statusMessage = "File upload failed! Status: ${response.statusCode}";
      });
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
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
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
                      child: Text(
                        "ADD MAP",
                        style: GoogleFonts.oxygen(
                            color: Colors.white,
                            fontSize: 25.h,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
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
                          onTap: () {
                            print("nenhenh");
                            _pickFile();
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
                          onTap: () async {
                            print("dsjfjdgijf");
                            // try {
                            Map<String, dynamic> resp =
                                await ApiServices.deleteFile(status: true);
                            if (resp['status'] == true) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              ProductAppPopUps.submit(
                                title: "SUCCESS",
                                message: resp['message'].toString(),
                                actionName: "Close",
                                iconData: Icons.done,
                                iconColor: Colors.green,
                              );
                            } else {
                              ProductAppPopUps.submit(
                                title: "Failed",
                                message: resp['message'].toString(),
                                actionName: "Close",
                                iconData: Icons.error_outline,
                                iconColor: Colors.red,
                              );
                            }
                            // } catch (e) {
                            //   ProductAppPopUps.submit(
                            //     title: "Failed",
                            //     message: "Response not ",
                            //     actionName: "Close",
                            //     iconData: Icons.error_outline,
                            //     iconColor: Colors.red,
                            //   );
                            // }
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        _statusMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
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
        style: GoogleFonts.orbitron(
          color: Colors.white,
          fontSize: 18.h,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
