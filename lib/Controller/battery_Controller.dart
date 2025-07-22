import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Model/battery_offline_model.dart';
import 'package:ihub/Utils/colors.dart';
import 'package:lottie/lottie.dart';

import '../Model/batteryModel.dart';
import '../Service/Api_Service.dart';

class BatteryController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<BatteryModel?> batteryModel = Rx(null);
  Rx<OfflineBatteryModel?> offlineBatteryModel = Rx(null);
  bool popupshow = false;

  var roboId;
  Rx<Color> foregroundColor = Colors.black.obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  RxBool isRotale = false.obs;
  RxInt batteryStatus = 0.obs;

  fetchBattery(int userID) async {
    isLoading.value = true;
    isLoaded.value = false;

    try {
      Map<String, dynamic> onlineBatteryResponse = await ApiServices.battery(
        userId: userID,
      );

      // Save online data if valid
      if (onlineBatteryResponse['status'] == 'ok') {
        batteryModel.value = BatteryModel.fromJson(onlineBatteryResponse);
        roboId = batteryModel.value?.data?.first.robot?.roboId;
        print("Robo ID: $roboId");
      }

      Map<String, dynamic> offlineBatteryResponse =
          await ApiServices.batteryOffline();

      // Check if offline response is valid
      if (offlineBatteryResponse['status'] == 'ok') {
        offlineBatteryModel.value = OfflineBatteryModel.fromJson(
          offlineBatteryResponse,
        );
      }

      print("API Online Battery Response: $onlineBatteryResponse");
      print("API Offline Battery Response: $offlineBatteryResponse");

      // Get battery level from either online or offline
      String? onlineBattery =
          batteryModel.value?.data?.first.robot?.batteryStatus;
      String? offlineBattery = offlineBatteryModel.value?.data?.batteryStatus;

      print("Online Battery: $onlineBattery");
      print("Offline Battery: $offlineBattery");

      if (onlineBattery != null && onlineBattery.trim().isNotEmpty) {
        batteryStatus.value = int.tryParse(onlineBattery.trim()) ?? 0;
      } else if (offlineBattery != null && offlineBattery.trim().isNotEmpty) {
        batteryStatus.value = int.tryParse(offlineBattery.trim()) ?? 0;
      }

      print("Final Battery Level: $batteryStatus");

      // Show battery low dialog if level is 0–30
      if (batteryStatus <= 30 && batteryStatus >= 0) {
        if (!popupshow) {
          popupshow = true;
          await Get.dialog(
            AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              title: Column(
                children: [
                  Center(
                    child: SizedBox(
                      width: 120.w,
                      height: 120.h,
                      child: Lottie.asset(
                        "assets/batterylottie.json",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Text(
                    "BATTERY LOW",
                    style: GoogleFonts.oxygen(
                      color: Colors.black,
                      fontSize: 18.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Container(
                width: 150.w,
                child: const Text(
                  "Hey there! My energy levels are running low. I need a recharge soon to keep assisting you.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          ColorUtils.userdetailcolor,
                        ),
                      ),
                      child: Text(
                        "OK PROCEED",
                        style: TextStyle(color: Colors.white, fontSize: 16.h),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      isLoaded.value = false;
      print("Error fetching battery data: $e");
    } finally {
      resetStatus();
    }
  }
}
