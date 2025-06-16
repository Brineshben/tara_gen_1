import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ihub/Service/charge_service.dart';
import 'package:ihub/Utils/colors.dart';

class ChargeScreenController extends GetxController {
  // update charge
  RxString lowBatteryEntry = ''.obs;
  RxString backToHomeEntry = ''.obs;

  Future<void> updateChargeValues({
    required String batteryEntry,
    required String homeEntry,
  }) async {
    Map<String, dynamic> resp = await ChargeService.updateCharge(
      batteryEntry: batteryEntry,
      homeEntry: homeEntry,
    );

    print("Charge update response: $resp");

    if (resp['status'] == 'ok') {
      lowBatteryEntry.value = resp['data']['low_battery_entry'].toString();
      backToHomeEntry.value = resp['data']['back_to_home_entry'].toString();

      Get.dialog(
        AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Column(
            children: [
              Icon(
                Icons.check,
                color: Colors.green,
                size: 50.h,
              ),
            ],
          ),
          content: Text(
            'Updated',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.h),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(ColorUtils.userdetailcolor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Close",
                    style: TextStyle(color: Colors.white, fontSize: 16.h),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (resp['status'] == "error") {
      Get.snackbar(
        'Failed',
        resp["message"]['value'][0] ?? 'Something went wrong!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  // get charge
  RxBool isLoading = false.obs;
  Future<void> fetchChargeValues() async {
    isLoading.value = true;
    try {
      final response = await ChargeService.fetchCurrentCharge();
      print('Fetched Charge Response: $response');

      if (response['status'] == 'ok') {
        lowBatteryEntry.value =
            response['data']['low_battery_entry'].toString();
        backToHomeEntry.value =
            response['data']['back_to_home_entry'].toString();
        print(lowBatteryEntry.value);
        print(backToHomeEntry.value);
      } else {
        Get.snackbar(
          margin: EdgeInsets.all(20),
          'Error',
          'Failed to fetch charge data',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Get.theme.colorScheme.onPrimary,
        );
      }
    } catch (e) {
      print(e);
      // Get.snackbar(
      //   margin: EdgeInsets.all(20),
      //   'Error',
      //   'Something went wrong!',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: AppColor.primary,
      //   colorText: Get.theme.colorScheme.onPrimary,
      // );
    } finally {
      isLoading.value = false;
    }
  }
}
