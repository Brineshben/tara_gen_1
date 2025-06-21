// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';

// import '../Model/battery_offline_model.dart';
// import '../Service/Api_Service.dart';
// import '../Utils/colors.dart';

// class BatteryOfflineController extends GetxController {
//   RxBool isLoading = false.obs;
//   RxBool isLoaded = false.obs;
//   RxBool isError = false.obs;
//   bool popupshow = false;
//   bool popupshow2 = false;

//   void resetStatus() {
//     isLoading.value = false;
//     isError.value = false;
//   }

//   Future<void> fetchOfflineBattery() async {
//     isLoading.value = true;
//     isLoaded.value = false;

//     try {

//       if (resp['status'] == "ok") {

//         String? batteryStatusStr =
//             offlineBatteryModel.value?.data?.batteryStatus;

//         int batteryStatus = int.tryParse(batteryStatusStr ?? "-1") ?? -1;

//         if (batteryStatus <= 30 && batteryStatus >= 0) {
//           if (!popupshow2) {
//             popupshow2 = true;
//             await Get.dialog(
//               AlertDialog(
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                 ),
//                 title: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         GestureDetector(
//                           onTap: () => Get.back(),
//                           child: const Icon(Icons.close_outlined,
//                               color: Colors.grey),
//                         )
//                       ],
//                     ),
//                     Center(
//                       child: SizedBox(
//                         width: 120.w,
//                         height: 120.h,
//                         child: Lottie.asset(
//                           "assets/batterylottie.json",
//                           fit: BoxFit.fitHeight,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       "BATTERY LOW",
//                       style: GoogleFonts.oxygen(
//                         color: Colors.black,
//                         fontSize: 18.h,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 content: Container(
//                   width: 150.w,
//                   child: const Text(
//                     "Hey there! My energy levels are running low. I need a recharge soon to keep assisting you.",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//                 actionsAlignment: MainAxisAlignment.center,
//                 actions: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       FilledButton(
//                         onPressed: () => Get.back(),
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all(
//                               ColorUtils.userdetailcolor),
//                         ),
//                         child: Text(
//                           "Cancel",
//                           style: TextStyle(color: Colors.white, fontSize: 16.h),
//                         ),
//                       ),
//                       FilledButton(
//                         onPressed: () => Get.back(),
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all(
//                               ColorUtils.userdetailcolor),
//                         ),
//                         child: Text(
//                           "OK PROCEED",
//                           style: TextStyle(color: Colors.white, fontSize: 16.h),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             );
//           }
//         }

//         isLoaded.value = true;
//       }
//     } catch (e) {
//       isLoaded.value = false;
//       print("bennn");
//       // Get.snackbar(
//       //   'Failed', // Title
//       //   'Error in Robot Response Battery Details',
//       //   snackPosition: SnackPosition.BOTTOM,
//       //   backgroundColor: Colors.blueGrey,
//       //   colorText: Colors.white,
//       //   borderRadius: 10,
//       //   margin: EdgeInsets.all(10),
//       //   duration: Duration(seconds: 3), // Auto dismiss time
//       //   icon: Icon(Icons.check_circle, color: Colors.white),
//       // );

//       print("Error fetching battery data: $e");
//     } finally {
//       resetStatus();
//     }
//   }
// }
