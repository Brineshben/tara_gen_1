import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/PasswordModel.dart';

import '../Service/Api_Service.dart';
import '../Utils/popups.dart';

class Passwordcontroller extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<PasswordModel?> passwordApi = Rx(null);

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future<void> fetchpassword(int userID, String password) async {
    isLoading.value = true;
    isLoaded.value = false;

    try {
      Map<String, dynamic> resp = await ApiServices.password(userId: userID, Password: password);

      if (resp['status'] == "ok") {
        print("--------Response: $resp-------");

        PasswordModel pass = PasswordModel.fromJson(resp);
        passwordApi.value = pass;
        isLoaded.value = true;
        // if(pass.message == "message"){
        //   print
        //
        //   ProductAppPopUps.submit(
        //       message: "SUCCESS",
        //       actionName: "Ok",
        //       iconData:Icons.done,
        //       iconColor: Colors.green);
        // }
        // else {
        //   ProductAppPopUps.submit(
        //       message: "INCORRECT PASSWORD",
        //       actionName: "tR",
        //       iconData:Icons.error_outline,
        //       iconColor: Colors.red);
        //
        // }
      }
    } catch (e) {
      isLoaded.value = false;
      Get.snackbar(
        'Failed', // Title
        'Api Issue in Password', // Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueGrey,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3), // Auto dismiss time
        icon: Icon(Icons.check_circle, color: Colors.white),
      );

      print("Error fetching battery data: $e");
    } finally {
      resetStatus();
    }
  }
}
