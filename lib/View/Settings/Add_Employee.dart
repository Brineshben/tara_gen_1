import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/AddEmployeeController.dart';
import '../../Controller/Backgroud_controller.dart';
import '../../Controller/Login_api_controller.dart';
import '../../Utils/popups.dart';
import '../../main.dart';
import 'Add_Employeedetails.dart';
import 'settings.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({Key? key}) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController employeeidcontoller = TextEditingController();
  late CameraController cameraController;
  int cameraIndex = 1;
  int currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Get.find<PopupController>().isHomepage.value = false;
    _hideSystemUI();
    cameraController =
        CameraController(cameras[cameraIndex], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive); // Hide status bar again
  }

  @override
  void dispose() {
    // Get.find<PopupController>().isHomepage.value = true;

    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
            ),
            // Positioned.fill(
            //   child: Image.asset(
            //     'assets/images.jpg',
            //     fit: BoxFit.cover,
            //   ),
            // ),
            GetX<BackgroudController>(
              builder: (BackgroudController controller) {
                return Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl:
                        controller.backgroundModel.value?.backgroundImage ?? "",
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Image.asset("assets/images.jpg", fit: BoxFit.cover),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/images.jpg", fit: BoxFit.cover),
                  ),
                );
              },
            ),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 50,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ADD EMPLOYEE",
                            style: GoogleFonts.oxygen(
                                color: Colors.white,
                                fontSize: 25.h,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (cameraController.value.isInitialized)
                      Align(
                        alignment: Alignment.topCenter,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000).r,
                          child: Container(
                            width: size.width * 0.35,
                            height: size.width * 0.35,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                              backgroundBlendMode: BlendMode.srcOut,
                            ),
                            child: OverflowBox(
                              maxWidth: ScreenUtil().screenWidth,
                              maxHeight: double.infinity,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(
                                    cameras[cameraIndex].lensDirection ==
                                            CameraLensDirection.front
                                        ? math.pi
                                        : 0),
                                child: Transform.rotate(
                                  angle: math.pi / 2,
                                  child: CameraPreview(
                                    cameraController,
                                    child: Stack(
                                      children: [
                                        ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              Colors.black
                                                  .withValues(alpha: 0.8),
                                              BlendMode.srcOut),
                                          // This one will create the magic
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.black,
                                                    backgroundBlendMode:
                                                        BlendMode.dstOut),
                                              ),
                                              Center(
                                                child: CircleAvatar(
                                                  radius: 130.w,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            // margin:
                                            // EdgeInsets.only(top: 12.h),
                                            height: size.width * 0.35,
                                            width: size.width * 0.35,
                                            child: SvgPicture.asset(
                                              "assets/Ellipse 460.svg",
                                              color: Colors.green.shade300,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    Container(
                      margin:
                          EdgeInsets.only(left: 40.w, bottom: 15, right: 40.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'EMPLOYEE ID',
                            style: TextStyle(
                                fontSize: 25.h,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 40.w, right: 40.w),
                      height: size.height * 0.2,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        maxLength: 30,
                        minLines: 1,
                        controller: employeeidcontoller,
                        validator: (val) => val!.trim().isEmpty
                            ? 'Please Enter Your Employee ID'
                            : null,
                        decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.white38),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 10.w),
                            hintText: "Enter Your Employee ID",
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 16.h),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ).r,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 1.0),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)).r,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 1.0),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0))
                                      .r,
                            ),
                            fillColor: Colors.blueGrey[900],
                            filled: true),
                        maxLines: 5,
                      ),
                    ),
                    GestureDetector(
                      child: buildInfoCard(size, 'SUBMIT'),
                      onTap: () async {
                        String user = employeeidcontoller.text.trim();
                        if (_formKey.currentState!.validate()) {
                          if (user.isNotEmpty) {
                            await Get.find<AddEmployeeController>()
                                .updateaddemployee(
                                    data:
                                        "${Get.find<UserAuthController>().loginData.value?.user?.id ?? 0}",
                                    employeeID: employeeidcontoller.text);

                            if (Get.find<AddEmployeeController>()
                                .isLoaded
                                .value) {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return AddEmployeedetails(
                                    employeeId: employeeidcontoller.text,
                                  );
                                },
                              ));

                              ProductAppPopUps.submit(
                                title: "Success",
                                message: "Employee Detail Added Successfully",
                                actionName: "Close",
                                iconData: Icons.done,
                                iconColor: Colors.green,
                              );
                            }
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        // floatingActionButton: Container(
        //   margin:
        //       EdgeInsets.only(left: 30.w, top: 120.h, right: 20.w, bottom: 20.h),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Container(
        //         decoration: BoxDecoration(
        //           color: Colors.red,
        //           borderRadius: BorderRadius.circular(20.r),
        //           boxShadow: [
        //             BoxShadow(
        //               color: Colors.black.withOpacity(0.2),
        //               spreadRadius: 1,
        //               blurRadius: 6,
        //             ),
        //           ],
        //         ),
        //         width: size.width * 0.28,
        //         height: 50.h,
        //         child: Center(
        //           child: Text(
        //             "Stop",
        //             style: GoogleFonts.inter(
        //               color: Colors.white,
        //               fontSize: 18.h,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //         ),
        //       )
        //       // FloatingActionButton(
        //       //   backgroundColor: Colors.red,
        //       //   onPressed: () {},
        //       //   child: TextButton(onPressed: () {  },
        //       //   child: Text("STOP"),),
        //       // ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}

// submit({
//   itle,
//   required String message,
//   required String actionName,
//   required IconData iconData,
//   required Color iconColor,
// }) {
//   return Get.dialog(
//     AlertDialog(
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(20.0)),
//       ),
//       title: Column(
//         children: [
//           Icon(
//             iconData,
//             color: iconColor,
//             size: 50.h,
//           ),
//           if (title != null) SizedBox(height: 10.w),
//           if (title != null)
//             Text(
//               title,
//               style: GoogleFonts.oxygen(
//                   color: Colors.black,
//                   fontSize: 18.h,
//                   fontWeight: FontWeight.bold),
//             ),
//         ],
//       ),
//       content: Text(
//         message,
//         textAlign: TextAlign.center,
//         style: TextStyle(fontSize: 16.h),
//       ),
//       actionsAlignment: MainAxisAlignment.center,
//       actions: [
//         FilledButton(
//           onPressed: () {
//             Get.to(
//                   () => Face(),
//               preventDuplicates: false,
//             );
//           },
//           style: ButtonStyle(
//             backgroundColor:
//             WidgetStateProperty.all(ColorUtils.userdetailcolor),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 actionName,
//                 style: TextStyle(color: Colors.white, fontSize: 16.h),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
// String? t
