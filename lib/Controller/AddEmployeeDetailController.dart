// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// import '../Model/AddEmployeeDetailsModel.dart';
// import '../Service/Api_Service.dart';
// import '../Utils/popups.dart';

// class AddEmployeeDetailsController extends GetxController {
//   RxBool isLoading = false.obs;
//   RxBool isLoaded = false.obs;
//   RxBool isError = false.obs;
//   Rx<EmployeeDetailsListModel?> updatedatass = Rx(null);

//   // void resetStatus() {
//   //   isLoading.value = false;
//   //   isError.value = false;
//   // }

//   Future<void> updateadddetailsemployee(
//       {required String data,
//       required String employeeID,
//       required String employeeName,
//       required String designation}) async {
//     isLoading.value = true;
//     isLoaded.value = false;
//     try {
//       print("jedifcj");
//       Map<String, dynamic> resp = await ApiServices.updateEmployeeDetails(
//           userId: data,
//           employeeID: employeeID,
//           employeeName: employeeName,
//          designatioon: designation);
//       print("------resp------$resp");
//       if (resp['status'] == "ok") {
//         EmployeeDetailsListModel sessionData = EmployeeDetailsListModel.fromJson(resp);
//         updatedatass.value = sessionData;
//         isLoaded.value = true;
//         ProductAppPopUps.submit3back(
//           title: "SUCCESS",
//           message: "Employee Details Added Successfully",
//           actionName: "Close",
//           iconData: Icons.done,
//           iconColor: Colors.green,
//         );

//       } else {
//         isLoaded.value = false;
//         ProductAppPopUps.submit(
//           title: "Failed",
//           message: "Something Went Wrong",
//           actionName: "Close",
//           iconData: Icons.error_outline,
//           iconColor: Colors.red,
//         );
//       }
//     } catch (e) {
//       isLoaded.value = false;
//       Get.snackbar(
//         'Failed', // Title
//         'Error in Robot Response Add Employee Details', // Message
//         snackPosition: SnackPosition.BOTTOM, // Position (TOP or BOTTOM)
//         backgroundColor: Colors.blueGrey,
//         colorText: Colors.white,
//         borderRadius: 10,
//         margin: EdgeInsets.all(10),
//         duration: Duration(seconds: 3), // Auto dismiss time
//         icon: Icon(Icons.check_circle, color: Colors.white),
//       );

//       print("--------session id not dsgdfgenerated---------");
//     } finally {
//       print("--------session id not cvnbgfgn generated---------");
//       isLoading.value = false;
//       // resetStatus();
//     }
//   }
// }
