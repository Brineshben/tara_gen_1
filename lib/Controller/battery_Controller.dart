import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Utils/colors.dart';
import 'package:lottie/lottie.dart';

import '../Model/batteryModel.dart';
import '../Service/Api_Service.dart';

class BatteryController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<BatteryModel?> background = Rx(null);
  bool popupshow = false;

  var roboId;

  Rx<Color> foregroundColor = Colors.black.obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  RxBool isRotale = false.obs;

  Future<bool?> fetchBattery(int userID) async {
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.battery(userId: userID);
      if (resp['status'] == 'ok') {
        print("--------Responsessssss: $resp-------");
        BatteryModel batteryData = BatteryModel.fromJson(resp);
        roboId = batteryData.data?.first.robot?.roboId;
        print("roboId: $roboId}");
        background.value = batteryData;

        int batteryStatus = int.tryParse(
                batteryData.data?.first.robot?.batteryStatus?.toString() ??
                    '0') ??
            0;

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
                        onPressed: () => Get.back(),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              ColorUtils.userdetailcolor),
                        ),
                        child: Text(
                          "OK PROCEED",
                          style: TextStyle(color: Colors.white, fontSize: 16.h),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
        }

        bool? charge = background.value?.data?.first.robot?.charging;
        print("BATTERT-IS-CHARGING $charge");

        if (charge == true) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      isLoaded.value = false;
      print("Error fetching battery data: $e");
    } finally {
      resetStatus();
    }
    return null;
  }

  // Future<bool?> fetchCharging(int userID) async {
  //   isLoading.value = true;
  //   isLoaded.value = false;
  //   try {
  //     Map<String, dynamic> resp = await ApiServices.battery(userId: userID);

  //     if (resp['status'] == "ok") {
  //       print("--------Responsessssss: $resp-------");
  //       BatteryModel batteryData = BatteryModel.fromJson(resp);
  //       background.value = batteryData;
  //       print("background.value: ${batteryData}");

  //       bool? charge = background.value?.data?.first.robot?.charging;
  //       print("BATTERT-IS-CHARGING $charge");
  //       if (charge == true) {
  //         return true;
  //       } else {
  //         return false;
  //       }
  //     }
  //   } catch (e) {
  //     isLoaded.value = false;
  //     print("bennn");

  //     print("Error fetching battery data: $e");
  //   } finally {
  //     resetStatus();
  //   }
  //   return null;
  // }
}
