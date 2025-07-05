import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Utils/popups.dart';
import 'package:lottie/lottie.dart';

import '../Model/Model.dart';
import '../Service/Api_Service.dart';

class ResponseNavController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<ResponseNavModel?> passwordApi = Rx<ResponseNavModel?>(null);

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  bool isNavigationDialogOpen = false;
  String? lastShownMessage;

  Future<void> fetchresponsenav(String roboid) async {
    if (isNavigationDialogOpen) return; // Prevent overlapping dialogs

    isLoading.value = true;
    isLoaded.value = false;

    try {
      final resp = await ApiServices.resposefornav(userId: roboid);
      print("Reached-Response: $resp");
      final responseModel = ResponseNavModel.fromJson(resp);
      passwordApi.value = responseModel;
      isLoaded.value = true;

      final message = responseModel.message ?? "no message";

      if (message != "no message") {
        isNavigationDialogOpen = true;
        lastShownMessage = message;
        await Get.dialog(
          barrierDismissible: false,
          AlertDialog(
            backgroundColor: const Color(0xFFEFF7FF), // Light blue background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Full-width Lottie without circle
                SizedBox(
                  width: double.infinity,
                  height: 160.h,
                  child: Lottie.asset(
                    "assets/navigate.json",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 20.h),

                // Title
                Text(
                  "${resp['message'] ?? "NAVIGATION REACHED"}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 22.h,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0050AC), // Dark blue
                  ),
                ),
                SizedBox(height: 12.h),

                // Main message
                Text(
                  "Would you like to return home now or stay at your current location?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16.h,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 24.h),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Get.back();
                          navigateToLocationByName();
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Color(0xFF00C897), // Green-teal
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Text(
                            "✅ YES, Go Home",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Color(0xFFFF6B6B), // Coral red
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Text(
                            "❌ NO, Stay Here",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.h,
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
        );

        Future.delayed(const Duration(seconds: 5), () {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
        });

        // Mark dialog as closed after `Get.dialog()` completes
        isNavigationDialogOpen = false;
      }
    } catch (e) {
      isLoaded.value = false;
      print("Error fetching navigation data: $e");
    } finally {
      resetStatus();
    }
  }
}

void navigateToLocationByName() async {
  try {
    final resp = await ApiServices.setHOme();

    if (resp['status'] == true) {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Center(
                child: SizedBox(
                  width: 180.w,
                  height: 180.h,
                  child: Lottie.asset("assets/navigate.json"),
                ),
              ),
              Text(
                "COMMAND RECEIVED",
                style: GoogleFonts.orbitron(
                  color: Colors.black,
                  fontSize: 20.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            "Heading to the home location",
            textAlign: TextAlign.center,
            style: GoogleFonts.oxygen(color: Colors.black, fontSize: 15.h),
          ),
        ),
      );
      Future.delayed(const Duration(seconds: 3), () {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      });
    }
  } catch (e) {
    ProductAppPopUps.submit(
      title: "FAILED",
      message: "Something went wrong.",
      actionName: "Close",
      iconData: Icons.info_outline,
      iconColor: Colors.red,
    );
    print("Error: ${e.toString()}");
  }
}
