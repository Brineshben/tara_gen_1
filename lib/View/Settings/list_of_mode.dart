import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
        title: Text("Modes", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
               if(_pdfFile != null) {
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
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: Text(
          "Switch Mode",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Current Mode:",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black87)),
            SizedBox(height: 4),
            Text(
              isTeachingMode ? "Teaching" : "Reception",
              style: TextStyle(
                fontSize: 16,
                color: isTeachingMode ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Do you want to switch this mode?\n\nIt will change to ${isTeachingMode ? 'Reception' : 'Teaching'} mode.",
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel",
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              toggleTeachingMode(!isTeachingMode);
            },
            child: Text("Switch"),
          ),
        ],
      ),
    );
  }
}
