import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Utils/popups.dart';
import 'package:lottie/lottie.dart';

import '../Model/Model.dart';
import '../Service/Api_Service.dart';
import '../Utils/colors.dart';

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
          AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Column(
              children: [
                Center(
                  child: SizedBox(
                    width: 180.w,
                    height: 180.h,
                    child: Lottie.asset(
                      "assets/navigate.json",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Text(
                  "${resp['message'] ?? "NAVIGATION REACHED"}",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20.h,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              "Can I return home?",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.black, fontSize: 15.h),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    onPressed: () {
                      Get.back(); // Close dialog
                      navigateToLocationByName();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        ColorUtils.userdetailcolor,
                      ),
                    ),
                    child: Text(
                      "YES",
                      style: TextStyle(color: Colors.white, fontSize: 16.h),
                    ),
                  ),
                ],
              ),
            ],
          ),
          barrierDismissible: false,
        );

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
