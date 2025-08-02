import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Model/battery_offline_model.dart';
import 'package:ihub/Utils/colors.dart';
import 'package:ihub/Utils/toast.dart';
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
  Rx<Color> foregroundColor = Colors.white.obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  RxBool isRotale = false.obs;
  RxInt batteryStatus = 0.obs;
  Future<void> fetchBattery(int userID, BuildContext context) async {
    isLoading.value = true;
    isLoaded.value = false;

    try {
      Map<String, dynamic>? onlineBatteryResponse;
      Map<String, dynamic>? offlineBatteryResponse;

   
      // Try fetching offline data
      try {
        offlineBatteryResponse = await ApiServices.batteryOffline();

        if (offlineBatteryResponse['status'] == 'ok') {
          offlineBatteryModel.value =
              OfflineBatteryModel.fromJson(offlineBatteryResponse);
        } else {
          print("Offline battery status not OK");
          offlineBatteryResponse = null;
        }
      } catch (e) {
        print('Error fetching offline battery: $e');
        offlineBatteryResponse = null;
        showTopRightToast(
          context: context,
          message:
              "Can't load battery info from robot. Please check the Wi-Fi or IP settings.",
          color: Colors.red,
        );
      }




         // Try fetching online data
      try {
        onlineBatteryResponse = await ApiServices.battery(userId: userID);

        if (onlineBatteryResponse['status'] == 'ok') {
          batteryModel.value = BatteryModel.fromJson(onlineBatteryResponse);
          roboId = batteryModel.value?.data?.first.robot?.roboId;
          print("Robo ID: $roboId");
        } else {
          print("Online battery status not OK");
          onlineBatteryResponse = null;
        }
      } catch (e) {
        print('Error fetching online battery: $e');
        onlineBatteryResponse = null;
      }


      print("API Online Battery Response: $onlineBatteryResponse");
      print("API Offline Battery Response: $offlineBatteryResponse");

      // Get battery status from valid source
      String? onlineBattery =
          batteryModel.value?.data?.first.robot?.batteryStatus;
      String? offlineBattery =
          offlineBatteryModel.value?.data?.batteryStatus ?? '0';

      String? finalBatteryStr;

      if (onlineBattery != null && onlineBattery.trim().isNotEmpty) {
        finalBatteryStr = onlineBattery;
      } else if (offlineBattery.trim().isNotEmpty) {
        finalBatteryStr = offlineBattery;
      } else {
        finalBatteryStr = '0';
      }

      batteryStatus.value = int.tryParse(finalBatteryStr.trim()) ?? 0;

      print("Final Battery Level: ${batteryStatus.value}");

      // Show warning if battery is low
      if (batteryStatus.value <= 30 && batteryStatus.value >= 0) {
        if (!popupshow) {
          popupshow = true;

          await Get.dialog(
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
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
              content: SizedBox(
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
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.h,
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

      isLoaded.value = true;
    } catch (e) {
      print("Unexpected error in fetchBattery(): $e");
      isLoaded.value = false;
      showTopRightToast(
        context: context,
        message: "Something went wrong while fetching battery data.",
        color: Colors.red,
      );
    } finally {
      resetStatus();
    }
  }
}
