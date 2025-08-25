import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/glassmorphism.dart';
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
    final fallbackUri = Uri.parse("android-app://$packageName");

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
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    ChildGlasmorphism(
                      borderRadius: 10,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => Navigator.of(context).pop(),
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'MODE SELECTION',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Spacer(),
                    ChildGlasmorphism(
                      borderColor: Colors.green,
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        isTeachingMode ? "TARA LEARN" : "TARA GREAT",
                        style: TextStyle(color: Colors.green),
                      ),
                    ))
                  ],
                ),

                const SizedBox(height: 40),

                // Mode cards
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
                    child: Row(
                      children: [
                        Expanded(
                          child: ModeCard(
                            title: "TARA LEARN",
                            icon: Icons.school,
                            iconColor: Colors.amber,
                            onSelect: () {
                              showModeDialog(context, isTeachingMode);
                            },
                            teachingModeStatus: isTeachingMode,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ModeCard(
                            title: "TARA EXPO",
                            icon: Icons.explore,
                            iconColor: Colors.blue,
                            comingSoon: true,
                            onSelect: () {
                              showComingSoonDialog(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ModeCard(
                            title: "TARA CARE",
                            icon: Icons.medical_services,
                            iconColor: Colors.green,
                            comingSoon: true,
                            onSelect: () {
                              showComingSoonDialog(context);
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
        ],
      ),
    );
  }

  void showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_clock, size: 50, color: Colors.deepPurple),
              const SizedBox(height: 16),
              Text(
                "Coming Soon",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "This feature is not available yet. Stay tuned!",
                style: TextStyle(color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 100, vertical: 12),
                ),
                child: const Text(
                  "OK",
                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void showModeDialog(BuildContext context, bool isTeachingMode) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 200),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sync_alt, color: Colors.white, size: 40),
                    const SizedBox(height: 16),
                    Text(
                      "Switch Robot Mode",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current Mode:",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              isTeachingMode
                                  ? "Teaching Mode"
                                  : "Reception Mode",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isTeachingMode
                                    ? Colors.amber
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Switching To:",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              isTeachingMode
                                  ? "Reception Mode"
                                  : "Teaching Mode",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isTeachingMode
                          ? "Switching to Reception Mode for greeting and managing visitors at the entrance."
                          : "Switching to Teaching Mode for classroom navigation.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await Future.delayed(
                                  const Duration(milliseconds: 300));

                              // Show loading dialog
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            CircularProgressIndicator(
                                                color: Colors.white),
                                            SizedBox(height: 16),
                                            Text(
                                              "Switching Mode...",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );

                              await Future.delayed(const Duration(seconds: 2));
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
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              "Switch",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
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
