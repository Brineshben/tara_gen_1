import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/sessionModel.dart';
import '../Service/Api_Service.dart';

class SessionIDController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<SessionUpdateIdModel?> sessionDatas = Rx(null);

  // void resetStatus() {
  //   isLoading.value = false;
  //   isError.value = false;
  // }

  Future<void> sessionDataid() async {
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.sessionid();
      print("------respben------$resp");
      if (resp['status'] == "ok") {
        SessionUpdateIdModel sessionData = SessionUpdateIdModel.fromJson(resp);
        sessionDatas.value = sessionData;

        print(
            "------bebebebebebebe--${sessionDatas.value?.latestSessionId}--------");
        // isLoaded.value = true;
        // ProductAppPopUps.submit(
        //   title: "Success",
        //   message: "${resp['message'] ?? 'Login successful.'}",
        //   actionName: "Close",
        //   iconData: Icons.error_outline,
        //   iconColor:Colors.grey,
        // );
      }
    } catch (e) {
      isLoaded.value = false;
      print("--------session id not generated---------");
      Get.snackbar(
        'Failed', // Title
        'Api Response Issue SessionID', // Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueGrey,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3), // Auto dismiss time
        icon: Icon(Icons.check_circle, color: Colors.white),
      );
    } finally {
      print("--------sesssssssion id not generated---------");
      // resetStatus();
    }
  }
}
