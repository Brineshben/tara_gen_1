import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/Add_EmployeeModel.dart';
import '../Service/Api_Service.dart';
import '../Utils/popups.dart';

class AddEmployeeController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<EmployeeaddListModel?> updatedatass = Rx(null);

  // void resetStatus() {
  //   isLoading.value = false;
  //   isError.value = false;
  // }

  Future<void> updateaddemployee(
      {required String data, required String employeeID}) async {
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.updateEmployee(
          userId: data, employeeID: employeeID);
      print("------resp------$resp");
      if (resp['status'] == "ok") {
        EmployeeaddListModel sessionData = EmployeeaddListModel.fromJson(resp);
        updatedatass.value = sessionData;
        isLoaded.value = true;
      } else {
        isLoaded.value = false;
        ProductAppPopUps.submit(
          title: "Failed",
          message: "Employee with this Employee ID Already Exists.",
          actionName: "Close",
          iconData: Icons.error_outline,
          iconColor: Colors.red,
        );
      }
    } catch (e) {
      isLoaded.value = false;
      Get.snackbar(
        'Failed', // Title
        'Error in Robot Response Add Employee', // Message
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
      isLoading.value = false;
      // resetStatus();
    }
  }
}
