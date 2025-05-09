import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/EnquiryListModel.dart';
import '../Service/Api_Service.dart';

class Enquirylistcontroller extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<EnquiryListModel?> enquiryList = Rx(null);
  RxList<Data> enquiryData = <Data>[].obs;

  void resetStatus() {
    isError.value = false;
  }

  Future<void> fetchEnquiryList(int userID) async {
    isLoading.value = true;
    isLoaded.value = false;
    // resetStatus(); // Reset error before making the API call

    try {
      Map<String, dynamic> resp = await ApiServices.EnquiryList(userId: userID);

      if (resp['status'] == "ok") {
        print("nenhehjehjeh");
        enquiryList.value = EnquiryListModel.fromJson(resp);
        enquiryData.value = enquiryList.value?.data ?? [];

        isLoaded.value = true;
      } else {
        isError.value = true;
      }
    } catch (e) {
      isError.value = true;
      Get.snackbar(
        'Failed', // Title
        'Error in Robot Response Enquiry List ', // Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueGrey,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3), // Auto dismiss time
        icon: Icon(Icons.check_circle, color: Colors.white),
      );

      print("Error fetching enquiry list: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
