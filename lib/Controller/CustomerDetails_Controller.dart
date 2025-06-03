import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/customer_model.dart';
import '../Service/Api_Service.dart';
import '../Utils/popups.dart';

class CustomerdetailsController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<CustomerDetailsModel?> customerDetails = Rx(null);
  Rx<Data?> userdata = Rx(null);

  // void resetStatus() {
  //   isLoading.value = false;
  //   isError.value = false;
  // }

  Future<void> customerData(
      {required String sessionId,
      required String username,
      required String purpose}) async {
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.customerDetails(
          sessionId: sessionId, userName: username, purPose: purpose);
      print("------respbwnenen------$resp");
      if (resp['status'] == "ok") {
        CustomerDetailsModel customerDetailsApi =
            CustomerDetailsModel.fromJson(resp);
        customerDetails.value = customerDetailsApi;
        userdata.value = customerDetails.value?.data;
        print("------respbwnenen------${userdata.value}");

        // isLoaded.value = true;
      } else {
        ProductAppPopUps.submit(
          title: "FAILED",
          message: 'Something went wrong.',
          actionName: "Close",
          iconData: Icons.error_outline,
          iconColor: Colors.red,
        );
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeeee$e");
      isLoaded.value = false;
      print("-----------login errsdsfsdfor-----------");
      Get.snackbar(
        'Failed', // Title
        'Error in Robot Response Customer Details ', // Message
        snackPosition: SnackPosition.BOTTOM, // Position (TOP or BOTTOM)
        backgroundColor: Colors.blueGrey,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3), // Auto dismiss time
        icon: Icon(Icons.check_circle, color: Colors.white),
      );
    } finally {
      // resetStatus();
    }
  }
}
