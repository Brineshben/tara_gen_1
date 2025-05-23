import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/View/Home_Screen/battery_Widget.dart';
import 'package:ihub/View/Settings/settings.dart';
import 'package:pinput/pinput.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  bool isOldPinError = false;
  bool isNewPinError = false;

  @override
  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Colors.black),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GetX<BackgroudController>(
              builder: (controller) {
                return Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl:
                        controller.backgroundModel.value?.backgroundImage ?? "",
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Image.asset("assets/images.jpg", fit: BoxFit.cover),
                    errorWidget: (_, __, ___) =>
                        Image.asset("assets/images.jpg", fit: BoxFit.cover),
                  ),
                );
              },
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: 60.h,
                              width: 60.h,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15).r,
                              ),
                              child: const Icon(Icons.arrow_back_outlined,
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "CHANGE PASSWORD",
                            style: GoogleFonts.oxygen(
                              color: Colors.black,
                              fontSize: 22.h,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // GetX<BatteryController>(
                    //   builder: (batteryController) {
                    //     int batteryLevel = int.tryParse(
                    //           batteryController.background.value?.data?.first
                    //                   .robot?.batteryStatus ??
                    //               "0",
                    //         ) ??
                    //         0;
                    //     return BatteryIcon(batteryLevel: batteryLevel);
                    //   },
                    // ),

                    Column(
                      children: [
                        Header(
                          isBack: true,
                          screenName: "", page: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  children: [
                    Text("Enter Old Password", style: _titleStyle()),
                    const SizedBox(height: 10),
                    Pinput(
                      controller: _oldPinController,
                      length: 4,
                      obscureText: true,
                      defaultPinTheme: defaultPinTheme,
                      onChanged: (_) => setState(() => isOldPinError = false),
                    ),
                    const SizedBox(height: 30),
                    Text("Enter New Password", style: _titleStyle()),
                    const SizedBox(height: 10),
                    Pinput(
                      controller: _newPinController,
                      length: 4,
                      obscureText: true,
                      defaultPinTheme: defaultPinTheme,
                      onChanged: (_) => setState(() => isNewPinError = false),
                    ),
                    const SizedBox(height: 30),
                    FilledButton(
                      onPressed: _handleChangePassword,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Save", style: TextStyle(fontSize: 16)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _titleStyle() {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
  }

  void _handleChangePassword() {
    String oldPin = _oldPinController.text.trim();
    String newPin = _newPinController.text.trim();

    if (oldPin != '5678') {
      setState(() => isOldPinError = true);
      _showCustomDialog(
        message: 'Wrong old password',
        iconData: Icons.error,
        iconColor: Colors.red,
        actionName: "Retry",
        onPressed: () {
          Get.back();
          _oldPinController.clear();
        },
      );
      return;
    }

    if (newPin.length != 4) {
      setState(() => isNewPinError = true);
      _showCustomDialog(
        message: 'New password must be 4 digits',
        iconData: Icons.warning,
        iconColor: Colors.orange,
        actionName: "Retry",
        onPressed: () {
          Get.back();
        },
      );
      return;
    }

    _showCustomDialog(
      message: 'Password changed successfully!',
      iconData: Icons.check_circle,
      iconColor: Colors.green,
      actionName: "OK",
      onPressed: () {
        Get.back();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Maintanance()));
      },
    );
  }

  void _showCustomDialog({
    required String message,
    required String actionName,
    required IconData iconData,
    required Color iconColor,
    required Function() onPressed,
  }) {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData, color: iconColor, size: 50),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.cyanAccent, fontSize: 16),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  elevation: 2,
                ),
                child: Text(
                  actionName,
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 16,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
