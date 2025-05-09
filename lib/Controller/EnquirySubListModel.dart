import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/EnquirySubListModel.dart';
import '../Service/Api_Service.dart';

class EnquirySubListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  RxList<EnquirySubListModel> enquiryList = <EnquirySubListModel>[].obs;

  void resetStatus() {
    isError.value = false;
  }

  Future<void> fetchEnquirySubList(int userID, int enquiry) async {
    isLoading.value = true;
    isLoaded.value = false;
    enquiryList.value = [];
    // resetStatus(); // Reset error before making the API call

    try {
      List<dynamic> resp =
          await ApiServices.EnquiryListSub(userId: userID, enquiry: enquiry);

      if (resp.isNotEmpty) {
        enquiryList.value =
            resp.map((e) => EnquirySubListModel.fromJson(e)).toList();
        // enquiryData.value = enquiryList.value?.enquiryDetails ?? [];
        print("Error fetching enqui${enquiryList}");
        isLoaded.value = true;
      } else {
        isError.value = true;
      }
    } catch (e) {
      isError.value = true;
      Get.snackbar(
        'Failed', // Title
        'Error in Robot Response Enquiry SubList', // Message
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
