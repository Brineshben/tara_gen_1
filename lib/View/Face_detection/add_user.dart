// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:ihub/View/Face_detection/viewCustomer_details.dart';

// import '../../Controller/CustomerDetails_Controller.dart';
// import '../../Controller/SessionId_controller.dart';
// import '../../Utils/colors.dart';

// class AddUser extends StatefulWidget {
//   final String sessionId;

//   const AddUser({Key? key, required this.sessionId}) : super(key: key);

//   @override
//   State<AddUser> createState() => _AddUserState();
// }

// class _AddUserState extends State<AddUser> {
//   final _formKey = GlobalKey<FormState>();
//   Timer? messageTimerface;

//   TextEditingController nameController = TextEditingController();
//   TextEditingController remarksController = TextEditingController();

//   @override
//   void initState() {
//     _hideSystemUI();
//     messageTimerface = Timer.periodic(const Duration(seconds: 3), (timer) {
//       Get.find<SessionIDController>().sessionDataid();
//     });
//     super.initState();
//   }

//   void _hideSystemUI() {
//     SystemChrome.setEnabledSystemUIMode(
//         SystemUiMode.immersive); // Hide status bar again
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;

//     return GestureDetector(
//       onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.black,
//           body: SizedBox(
//             height: ScreenUtil().screenHeight,
//             width: ScreenUtil().screenWidth,
//             child: Padding(
//               padding: EdgeInsets.only(
//                   left: 20.w, top: 15.h, right: 20.w, bottom: 10.h),
//               child: SingleChildScrollView(
//                 // Removed Expanded
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Greeting Text
//                       Padding(
//                         padding: EdgeInsets.only(left: 30.w),
//                         child: Text(
//                           'Hello !',
//                           style: GoogleFonts.roboto(
//                               color: Colors.white,
//                               fontSize: 30.h,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(left: 30.w),
//                         child: Text(
//                           'Add Your Details',
//                           style: GoogleFonts.roboto(
//                               color: Colors.grey,
//                               fontSize: 18.h,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       SizedBox(height: 25.h),

//                       // Name Field
//                       _buildTextFieldLabel('NAME'),
//                       _buildTextField(nameController, "Enter Your Name",
//                           maxLines: 1),

//                       // Purpose of Visit Field
//                       _buildTextFieldLabel('PURPOSE OF VISIT'),
//                       _buildTextField(
//                           remarksController, "Enter The Purpose of Visit",
//                           maxLines: 5),

//                       // Submit Button
//                       Center(
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                               left: 30.w, bottom: 50.h, top: 10.h),
//                           child: GestureDetector(
//                             onTap: () {
//                               if (_formKey.currentState!.validate()) {
//                                 if (nameController.text.trim().isNotEmpty &&
//                                     remarksController.text.trim().isNotEmpty) {
//                                   Get.find<CustomerdetailsController>()
//                                       .customerData(
//                                     sessionId: Get.find<SessionIDController>()
//                                             .sessionDatas
//                                             .value
//                                             ?.latestSessionId ??
//                                         "",
//                                     username: nameController.text,
//                                     purpose: remarksController.text,
//                                   );

//                                   Navigator.pushReplacement(
//                                     context,
//                                     PageRouteBuilder(
//                                       transitionDuration:
//                                           Duration(milliseconds: 300),
//                                       pageBuilder: (context, animation,
//                                               secondaryAnimation) =>
//                                           ViewCustomerDetails(),
//                                       transitionsBuilder: (context, animation,
//                                           secondaryAnimation, child) {
//                                         return FadeTransition(
//                                             opacity: animation, child: child);
//                                       },
//                                     ),
//                                   );
//                                 }
//                               }
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     ColorUtils.userdetailcolor,
//                                     ColorUtils.userdetailcolor
//                                   ],
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                 ),
//                                 borderRadius: BorderRadius.circular(20.r),
//                               ),
//                               width: 150.w,
//                               height: 60.h,
//                               child: Center(
//                                 child: Text(
//                                   'SUBMIT',
//                                   style: GoogleFonts.orbitron(
//                                       color: Colors.white,
//                                       fontSize: 20.h,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Function to create section labels
//   Widget _buildTextFieldLabel(String text) {
//     return Padding(
//       padding: EdgeInsets.only(left: 30.w, bottom: 15.h),
//       child: Text(
//         text,
//         style: TextStyle(
//             fontSize: 25.h, fontWeight: FontWeight.bold, color: Colors.blue),
//       ),
//     );
//   }

//   // Function to create text fields
//   Widget _buildTextField(TextEditingController controller, String hintText,
//       {int maxLines = 1}) {
//     return Padding(
//       padding: EdgeInsets.only(left: 30.w, bottom: 15.h),
//       child: TextFormField(
//         style: const TextStyle(color: Colors.white),
//         maxLength: maxLines == 1 ? 30 : 100,
//         minLines: 1,
//         maxLines: maxLines,
//         controller: controller,
//         validator: (val) =>
//             val!.trim().isEmpty ? 'Please enter $hintText.' : null,
//         decoration: InputDecoration(
//           hintStyle: const TextStyle(color: Colors.white38),
//           contentPadding:
//               EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
//           hintText: hintText,
//           border: OutlineInputBorder(
//             borderRadius: const BorderRadius.all(Radius.circular(10.0)).r,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.blue, width: 1.0),
//             borderRadius: const BorderRadius.all(Radius.circular(10)).r,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.blue, width: 1.0),
//             borderRadius: const BorderRadius.all(Radius.circular(10.0)).r,
//           ),
//           fillColor: Colors.blueGrey[900],
//           filled: true,
//         ),
//       ),
//     );
//   }
// }
