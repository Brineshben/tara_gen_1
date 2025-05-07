import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/speed/service/speed_service.dart';

class SpeedController extends GetxController {
  RxBool isLoading = false.obs;
  RxDouble speed = RxDouble(0.1);

  Future<void> fetchSpeed() async {
    isLoading.value = true;
    try {
      Map<String, dynamic>? resp = await SpeedService.speedGet();
      print("------resp------$resp");
      if (resp != null) {
        speed.value = resp['data']["value"];
      }
    } catch (e) {
      // Get.snackbar(
      //   'Failed',
      //   'Error in Robot Response speed Control',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: AppColor.primary,
      //   colorText: Colors.white,
      //   borderRadius: 10,
      //   margin: EdgeInsets.all(10),
      //   duration: Duration(seconds: 3),
      //   icon: Icon(Icons.check_circle, color: Colors.white),
      // );

      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSpeed(double speedValue) async {
    Map<String, dynamic> resp = await SpeedService.speedUpdate(
      speed: speedValue,
    );
    print("speed update resp $resp");
    if (resp['status'] == 'ok') {
      speed.value = resp['data']['value'];
    }

    if (resp['status'] == "error") {
      Get.snackbar(
        'Failed',
        resp["message"]['value'][0] ?? 'Somthing went wrong!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.check_circle, color: Colors.white),
      );
    }
  }
}
