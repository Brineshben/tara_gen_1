import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ihub/Controller/Navigate_Controller.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/mode_container.dart';
import 'package:ihub/Utils/toast.dart';
import 'package:ihub/View/Settings/pdf_view_screen.dart';
import 'package:path_provider/path_provider.dart';

class ListofMode extends StatefulWidget {
  const ListofMode({super.key});

  @override
  State<ListofMode> createState() => _ListofModeState();
}

class _ListofModeState extends State<ListofMode> {
  File? _pdfFile;
  bool isTeachingMode = false;

  @override
  void initState() {
    super.initState();
    loadTeachingMode();
    loadLatestPDF();
  }

  void loadTeachingMode() async {
    final response = await ApiServices.checkTeachingMode();
    setState(() {
      isTeachingMode = response['data']?['status'] ?? false;
    });
  }

  void loadLatestPDF() async {
    final response = await ApiServices.getLatestPDF();
    final url = response['data']?['file'];

    if (url != null && url.toString().startsWith("http")) {
      try {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/latest.pdf';

        final downloadRes = await http.get(Uri.parse(url));
        final file = File(filePath);
        await file.writeAsBytes(downloadRes.bodyBytes);

        setState(() {
          _pdfFile = file;
        });

        showTopRightToast(
          context: context,
          message: "PDF downloaded and ready",
          color: Colors.green,
        );
      } catch (e) {
        showTopRightToast(
          context: context,
          message: "Download failed: $e",
          color: Colors.red,
        );
      }
    } else {
      showTopRightToast(
        context: context,
        message: "No valid PDF URL from server",
        color: Colors.blue,
      );
    }
  }

  Future<void> pickPDF() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      setState(() {
        _pdfFile = file;
      });

      final res = await ApiServices.uploadPDF(file);
      if (res['status'] == 'ok') {
        showTopRightToast(
          context: context,
          message: res['message'] ?? "PDF uploaded successfully",
          color: Colors.green,
        );
      } else {
        showTopRightToast(
          context: context,
          message: res['message'] ?? "Failed to upload PDF",
          color: Colors.red,
        );
      }
    }
  }

  void toggleTeachingMode(bool value) async {
    setState(() {
      isTeachingMode = value;
    });
    final res = await ApiServices.changeTeachingMode(status: value);
    if (res['status'] == 'ok') {
      showTopRightToast(
        context: context,
        message: res['message'] ?? "Teaching mode updated",
        color: Colors.green,
      );
    } else {
      showTopRightToast(
        context: context,
        message: "Failed to update teaching mode",
        color: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text("Modes",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        toolbarHeight: 90,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.82,
          children: [
            ModeCard(
              title: isTeachingMode ? "Teaching Mode" : "Reception Mode",
              imageUrl:
                  "https://media.istockphoto.com/id/966248982/photo/robot-with-education-hud.jpg?s=612x612&w=0&k=20&c=9eoZYRXNZsuU3edU87PksxN4Us-c9rB6IR7U_IGZ-U8=",
              pdfFile: _pdfFile,
              onSelect: () => showModeDialog(context),
              onView: () {
                if (_pdfFile != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PdfViewScreen(pdfFile: _pdfFile!),
                    ),
                  );
                } else {
                  showTopRightToast(
                    context: context,
                    message: "No PDF available",
                    color: Colors.red,
                  );
                }
              },
              onUpload: pickPDF,
            ),
            ModeCard(
              title: "Expo Mode",
              imageUrl:
                  "https://www.therobotreport.com/wp-content/uploads/2025/04/BostonDeviceRobotics-featured-1.jpg",
              comingSoon: true,
              onSelect: () {
                showComingSoonDialog(context);


             
              },
            ),
            ModeCard(
              title: "Control Mode",
              imageUrl:
                  "https://media.istockphoto.com/id/1022892534/photo/engineer-manager-check-and-control-automation-robot-arms-machine-in-intelligent-industrial.jpg?s=612x612&w=0&k=20&c=1lfHMx6lgDgjIpt2YfJHLZ692aYXAJnQE4IJj8UXcVU=",
              comingSoon: true,
              onSelect: () {
                showComingSoonDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        titlePadding: EdgeInsets.fromLTRB(24, 20, 24, 0),
        contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 16),
        actionsPadding: EdgeInsets.only(right: 12, bottom: 10),
        title: Row(
          children: [
            Icon(Icons.lock_clock, color: Colors.deepPurple),
            SizedBox(width: 10),
            Text(
              "Coming Soon",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          "This feature is not available yet. Stay tuned!",
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.deepPurple,
            ),
            child: Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void showModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final width = MediaQuery.of(context).size.width;
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: width * 0.8,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sync_alt,
                    color: Colors.deepPurple,
                    size: 40,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Switch Robot Mode",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  /// Combined row: current + switch to
                  Row(
                    children: [
                      Text(
                        "🟢 Current Mode: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        isTeachingMode ? "Teaching Mode" : "Reception Mode",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isTeachingMode ? Colors.green : Colors.red,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "🔁 Switching To: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        isTeachingMode ? "Reception Mode" : "Teaching Mode",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isTeachingMode ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                Row(
                    children: [
                      Expanded(
                        child: Text(
                          isTeachingMode
                              ? "Are you sure you want to switch to Reception Mode?\n\n"
                                  "In Reception Mode, the robot will greet and assist visitors automatically."
                              : "Are you sure you want to switch to Teaching Mode?\n\n"
                                  "You will be asked to select a class. The robot will then guide students as per the class location.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800],
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.redAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);

                            if (!isTeachingMode) {
                              // Switching TO Teaching Mode ➜ Show class list first
                              showNavigationListDialog(context);
                            } else {
                              // Switching TO Reception Mode ➜ Direct switch
                              toggleTeachingMode(false);
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            "Switch",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
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
    );
  }

  Widget buildInfoCard2(String title) {
    final Size size = MediaQuery.of(context).size;
    return Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.blueGrey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 0.01,
            offset: Offset(0, 0),
          ),
        ],
      ),
      width: size.width * 0.25,
      height: size.height * 0.080,
      child: Center(
        child: Text(
          title.toUpperCase(),
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18.h,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void showNavigationListDialog(BuildContext context) {
    final controller = Get.find<NavigateController>();
    controller.navigateData(); // fetch data when dialog opens

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
              minWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Class",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: GetX<NavigateController>(
                    builder: (controller) {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.blue),
                        );
                      }

                      final classList = controller.dataList
                          .where((item) =>
                              item?.name?.toLowerCase().contains("class") ??
                              false)
                          .toList();

                      if (classList.isEmpty) {
                        return const Center(child: Text("No classes found"));
                      }

                      return SingleChildScrollView(
                        child: Wrap(
                          children: List.generate(
                            classList.length,
                            (index) {
                              final item = classList[index];
                              return Padding(
                                padding: const EdgeInsets.all(6),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      navigateToLocationByName(item?.id ?? 0);
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    splashColor: Colors.blue,
                                    highlightColor:
                                        Colors.green.withOpacity(0.3),
                                    child: buildInfoCard2(item?.name ?? ''),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void navigateToLocationByName(int classId) async {
    Map<String, dynamic> response = await ApiServices.destination(id: classId);
    if (response['status'] == 'ok') {
      toggleTeachingMode(!isTeachingMode);
      
    }
  }
}
