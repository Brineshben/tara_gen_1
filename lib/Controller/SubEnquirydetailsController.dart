// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../Model/EnquirySublistDetailModel.dart';
// import '../Service/Api_Service.dart';

// class Subenquirydetailscontroller extends GetxController {
//   RxBool isLoading = false.obs;
//   RxBool isLoaded = false.obs;
//   RxBool isError = false.obs;
//   Rx<SubEnquirydetailsModel?> enquiryList = Rx(null);
//   Rx<Data?> enquiryData = Rx(null);

//   void resetStatus() {
//     isError.value = false;
//   }

//   Future<void> fetchEnquirySubDetails(
//       int subheading, String heading, String description) async {
//     isLoading.value = true;
//     isLoaded.value = false;
//     // resetStatus(); // Reset error before making the API call

//     try {
//       Map<String, dynamic> resp = await ApiServices.EnquiryListSubDetails(
//           subheading: subheading, heading: heading, description: description);

//       if (resp['status'] == "ok") {
//         print("nenhehjehjeh");
//         enquiryList.value = SubEnquirydetailsModel.fromJson(resp);
//         enquiryData.value = enquiryList.value?.data;

//         isLoaded.value = true;
//       } else {
//         isError.value = true;
//       }
//     } catch (e) {
//       isError.value = true;
//       Get.snackbar(
//         'Failed', // Title
//         'Api Response Issue SubEnquiry Details', // Message
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.blueGrey,
//         colorText: Colors.white,
//         borderRadius: 10,
//         margin: EdgeInsets.all(10),
//         duration: Duration(seconds: 3), // Auto dismiss time
//         icon: Icon(Icons.check_circle, color: Colors.white),
//       );

//       print("Error fetching enquiry list: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
