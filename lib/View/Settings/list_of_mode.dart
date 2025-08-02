import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/mode_container.dart';
import 'package:ihub/Utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class ListofMode extends StatefulWidget {
  const ListofMode({super.key});

  @override
  State<ListofMode> createState() => _ListofModeState();
}

class _ListofModeState extends State<ListofMode> {
  bool isTeachingMode = false;

  @override
  void initState() {
    super.initState();
    loadTeachingMode();
  }

  void loadTeachingMode() async {
    final response = await ApiServices.checkTeachingMode();
    setState(() {
      isTeachingMode = response['data']?['status'] ?? false;
    });
  }

  void openEduTara(int userId) async {
    const packageName = "com.ihub.edu_tara";

    // final Uri androidUri = Uri.parse("myapp://edu_tara?user_id=$userId");
    final fallbackUri = Uri.parse("android-app://$packageName");

    // final Uri androidUri = Uri.parse(
    //     "intent://edu_tara?user_id=$userId#Intent;scheme=myapp;package=$packageName;end;");

    try {
      if (await canLaunchUrl(fallbackUri)) {
        await launchUrl(fallbackUri);
      } else {
        Fluttertoast.showToast(msg: "App not installed");
        Fluttertoast.showToast(msg: "Redirecting to Play Store...");
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print("Error launching app: $e");
      Fluttertoast.showToast(msg: "Please install the app first");
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
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Row(
            spacing: 20,
            children: [
              Expanded(
                child: ModeCard(
                  title: "Teaching Mode ",
                  imageUrl:
                      "https://media.istockphoto.com/id/966248982/photo/robot-with-education-hud.jpg?s=612x612&w=0&k=20&c=9eoZYRXNZsuU3edU87PksxN4Us-c9rB6IR7U_IGZ-U8=",
                  onSelect: () {
                    showModeDialog(context, isTeachingMode);
                  },
                  teachingModeStatus: isTeachingMode,
                ),
              ),
              Expanded(
                child: ModeCard(
                  title: "Expo Mode",
                  imageUrl:
                      "https://www.therobotreport.com/wp-content/uploads/2025/04/BostonDeviceRobotics-featured-1.jpg",
                  comingSoon: true,
                  onSelect: () {
                    showComingSoonDialog(context);
                  },
                ),
              ),
              Expanded(
                child: ModeCard(
                  title: "Control Mode",
                  imageUrl:
                      "https://media.istockphoto.com/id/1022892534/photo/engineer-manager-check-and-control-automation-robot-arms-machine-in-intelligent-industrial.jpg?s=612x612&w=0&k=20&c=1lfHMx6lgDgjIpt2YfJHLZ692aYXAJnQE4IJj8UXcVU=",
                  comingSoon: true,
                  onSelect: () {
                    showComingSoonDialog(context);
                  },
                ),
              ),
            ],
          )),
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

  void showModeDialog(BuildContext context, bool isTeachingMode) {
    showDialog(
      context: context,
      builder: (ctx) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;

        return Dialog(
          backgroundColor: Colors.transparent, // Needed for glass effect
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                width: width * 0.85,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                constraints: BoxConstraints(
                  maxHeight: height * 0.85,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sync_alt, color: Colors.deepPurple, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      "Switch Robot Mode",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black26,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "🟢 Current Mode: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
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
                            color: Colors.white,
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
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isTeachingMode
                                ? "Do you want to switch to Reception Mode?\n\n"
                                    "This mode is used for greeting and managing visitors at the entrance."
                                : "Do you want to switch to Teaching Mode?\n\n"
                                    "The app will close, and open the Teaching Controller app for classroom navigation.",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.9),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
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
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      Expanded(
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);

                              await Future.delayed(
                                  const Duration(milliseconds: 300));

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 12, sigmaY: 12),
                                        child: Container(
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.2)),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(Icons.sync,
                                                  color: Colors.white,
                                                  size: 48),
                                              SizedBox(height: 16),
                                              Text(
                                                "Switching Mode...",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 4,
                                                      color: Colors.black26,
                                                      offset: Offset(1, 1),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );

                              await Future.delayed(const Duration(seconds: 3));
                              Navigator.pop(context);

                              if (isTeachingMode) {
                                toggleTeachingMode(false);
                              } else {
                                final batteryController =
                                    Get.find<BatteryController>();
                                final user = batteryController
                                    .batteryModel.value?.data?.first.user;
                                final userId = user?.id ?? 0;
                                final robotId = batteryController.roboId;

                                if (userId == 7 || robotId == "RB6") {
                                  toggleTeachingMode(true);
                                  openEduTara(userId);
                                } else {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Access denied! Only user akhil allowed.",
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                }
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Text(
                                "Switch",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
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
          ),
        );
      },
    );
  }
}
