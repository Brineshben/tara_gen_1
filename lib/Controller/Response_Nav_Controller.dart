import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../Model/Model.dart';
import '../Service/Api_Service.dart';
import '../Utils/colors.dart';
import 'battery_Controller.dart';

class ResponseNavController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<ResponseNavModel?> passwordApi = Rx(null);

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future<void> fetchresponsenav(
    String roboid,
  ) async {
    isLoading.value = true;
    isLoaded.value = false;

    try {
      Map<String, dynamic> resp =
          await ApiServices.resposefornav(userId: roboid);

      ResponseNavModel pass = ResponseNavModel.fromJson(resp);
      passwordApi.value = pass;
      isLoaded.value = true;
      print("anuuuuuuuuu${pass.message}");
      if (pass.message == "no message" || pass.message == null) {
      } else {
        Get.dialog(
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
                  "DESTINATION REACHED",
                  style: GoogleFonts.orbitron(
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
              style: GoogleFonts.oxygen(
                color: Colors.black,
                fontSize: 15.h,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    onPressed: () {
                      ApiServices.navigatePopup(
                          userId: Get.find<BatteryController>()
                                  .background
                                  .value
                                  ?.data
                                  ?.first
                                  .robot
                                  ?.roboId ??
                              "",
                          message: "no message");
                      ApiServices.sendResponseData(
                          status: true,
                          RobotID: Get.find<BatteryController>()
                                  .background
                                  .value
                                  ?.data
                                  ?.first
                                  .robot
                                  ?.roboId ??
                              "");
                      Get.back();
                      Get.back();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(ColorUtils.userdetailcolor),
                    ),
                    child: Text(
                      "YES",
                      style: TextStyle(color: Colors.white, fontSize: 16.h),
                    ),
                  ),
                ],
              )
            ],
          ),
        );

        Future.delayed(const Duration(seconds: 16), () {
          if (Get.isDialogOpen ?? false) {
            ApiServices.navigatePopup(
                userId: Get.find<BatteryController>()
                        .background
                        .value
                        ?.data
                        ?.first
                        .robot
                        ?.roboId ??
                    "",
                message: "no message");
            ApiServices.sendResponseData(
                status: true,
                RobotID: Get.find<BatteryController>()
                        .background
                        .value
                        ?.data
                        ?.first
                        .robot
                        ?.roboId ??
                    "");

            Get.back();
            Get.back();
          }
        });
      }
    } catch (e) {
      isLoaded.value = false;
      print("m..............");
      // Get.snackbar(
      //   'Failed', // Title
      //   'Api Issue in Password', // Message
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.blueGrey,
      //   colorText: Colors.white,
      //   borderRadius: 10,
      //   margin: EdgeInsets.all(10),
      //   duration: Duration(seconds: 3), // Auto dismiss time
      //   icon: Icon(Icons.check_circle, color: Colors.white),
      // );

      print("Error fetching battery data: $e");
    } finally {
      resetStatus();
    }
  }
}
