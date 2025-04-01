import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Model/SessionUpdateModel.dart';
import '../Service/Api_Service.dart';
import '../Utils/popups.dart';

class SessionController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<SessionUpdateModel?> sessionDatas = Rx(null);



  // void resetStatus() {
  //   isLoading.value = false;
  //   isError.value = false;
  // }

  Future<void> sessionData() async {
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp =
      await ApiServices.session();
      print("------respben------$resp");
      if (resp['status'] == "ok") {
        SessionUpdateModel sessionData = SessionUpdateModel.fromJson(resp);
        sessionDatas.value = sessionData;

        print("------bebebebebebebe--${sessionDatas.value?.sessionId}--------");
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
      Get.snackbar(
        'Failed', // Title
        'Api Response Issue  Session Control', // Message
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
