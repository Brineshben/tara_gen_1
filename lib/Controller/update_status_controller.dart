import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/updateStatus_model.dart';
import '../Service/Api_Service.dart';

class UpdateStatusController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<UpdateStatusModel?> updatedatass = Rx(null);

  // void resetStatus() {
  //   isLoading.value = false;
  //   isError.value = false;
  // }

  Future<void> updatedata(bool value) async {
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.updateStatus(status: value);
      print("------resp------$resp");
      if (resp['status'] == "ok") {
        UpdateStatusModel sessionData = UpdateStatusModel.fromJson(resp);
        updatedatass.value = sessionData;
        print("---bebnebebe----${updatedatass.value?.status}--------");
        isLoaded.value = true;
      }
    } catch (e) {
      isLoaded.value = false;

      Get.snackbar(
        'Failed', // Title
        'Error in Robot Response Update Status Controller', // Message
        snackPosition: SnackPosition.BOTTOM, // Position (TOP or BOTTOM)
        backgroundColor: Colors.blueGrey,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3), // Auto dismiss time
        icon: Icon(Icons.check_circle, color: Colors.white),
      );

      print("--------session id not generated---------");
    } finally {
      print("--------session id not generated---------");
      // resetStatus();
    }
  }
}
