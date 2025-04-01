import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/View/Face_detection/viewCustomer_details.dart';
import 'package:ihub/View/Login_Page/login.dart';

import '../../Controller/AddEmployeeDetailController.dart';
import '../../Controller/CustomerDetails_Controller.dart';
import '../../Controller/Login_api_controller.dart';
import '../../Controller/SessionId_controller.dart';
import '../../Utils/colors.dart';
import '../Home_Screen/home_page.dart';
import '../Robot_Response/robot_response.dart';

class AddEmployeedetails extends StatefulWidget {
  final String employeeId;

  const AddEmployeedetails({Key? key, required this.employeeId})
      : super(key: key);

  @override
  State<AddEmployeedetails> createState() => _AddEmployeedetailsState();
}

class _AddEmployeedetailsState extends State<AddEmployeedetails> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _employeeIdController;

  TextEditingController nameController = TextEditingController();
  TextEditingController designationController = TextEditingController();

  @override
  void initState() {
    _hideSystemUI();
    _employeeIdController = TextEditingController(text: widget.employeeId);

    super.initState();
  }
  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive); // Hide status bar again
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SizedBox(
            height: ScreenUtil().screenHeight,
            width: ScreenUtil().screenWidth,
            child: Container(
              margin: EdgeInsets.only(
                  left: 20.w, top: 15.h, right: 20.w, bottom: 10.h),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30.w),
                        child: Text(
                          'Hello !',
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 30.h,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30.w),
                        child: Text(
                          'Add Your Details',
                          style: GoogleFonts.roboto(
                              color: Colors.grey,
                              fontSize: 18.h,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30.w, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'EMPLOYEE ID ',
                              style: TextStyle(
                                  fontSize: 25.h,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30.w),
                        height: size.height * 0.12,
                        child: TextFormField(
                          readOnly: true,
                          style: const TextStyle(color: Colors.white),
                          maxLength: 20,
                          minLines: 1,
                          controller: _employeeIdController,
                          // validator: (val) => val!.trim().isEmpty
                          //     ? 'Please Enter Your Gender.'
                          //     : null,
                          decoration: InputDecoration(
                              hintStyle: const TextStyle(color: Colors.white38),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 10.w),
                              hintText: "Enter Your Gender   ",
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ).r,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 1.0),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10))
                                        .r,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 1.0),
                                borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0))
                                    .r,
                              ),
                              fillColor: Colors.blueGrey[900],
                              filled: true),
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30.w, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ENTER NAME',
                              style: TextStyle(
                                  fontSize: 25.h,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30.w),
                        height: size.height * 0.12,
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          maxLength: 30,
                          minLines: 1,
                          controller: nameController,
                          validator: (val) => val!.trim().isEmpty
                              ? 'Please Enter Your Name.'
                              : null,
                          decoration: InputDecoration(
                              hintStyle: const TextStyle(color: Colors.white38),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 10.w),
                              hintText: "Enter Your Name   ",
                              labelStyle: TextStyle(
                                  color: Colors.white, fontSize: 16.h),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ).r,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 1.0),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10))
                                        .r,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 1.0),
                                borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0))
                                    .r,
                              ),
                              fillColor: Colors.blueGrey[900],
                              filled: true),
                          maxLines: 5,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30.w, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ENTER DESIGNATION',
                              style: TextStyle(
                                  fontSize: 25.h,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30.w),
                        height: size.height * 0.2,
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          maxLength: 15,
                          minLines: 1,
                          controller: designationController,
                          validator: (val) => val!.trim().isEmpty
                              ? 'Please Enter Your Designation.'
                              : null,
                          decoration: InputDecoration(
                              hintStyle: const TextStyle(color: Colors.white38),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 10.w),
                              hintText: "Enter Your Designation   ",
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ).r,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 1.0),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10))
                                        .r,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 1.0),
                                borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0))
                                    .r,
                              ),
                              fillColor: Colors.blueGrey[900],
                              filled: true),
                          maxLines: 5,
                        ),
                      ),
                      Center(
                          child: Padding(
                        padding:
                            const EdgeInsets.only(left: 30, bottom: 50, top: 0)
                                .w,
                        child: GestureDetector(
                          onTap: () {
                            print("kab");
                            if (_formKey.currentState!.validate()) {
                              print("kab1");
                              String name =
                              nameController.text.trim();
                              String designation =
                              designationController.text.trim();

                              if (name.isNotEmpty && designation.isNotEmpty) {
                                print("kab2");
                                Get.find<AddEmployeeDetailsController>()
                                    .updateadddetailsemployee(
                                        data:
                                            "${Get.find<UserAuthController>().loginData.value?.user?.id ?? 0}",
                                        employeeID: widget.employeeId,
                                        employeeName: nameController.text,
                                        designation:
                                            designationController.text);
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [ColorUtils.userdetailcolor,ColorUtils.userdetailcolor],

                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            width: 150.w,
                            height: 60.h,
                            child: Center(
                              child: Text(
                                'SUBMIT',
                                style: GoogleFonts.orbitron(
                                    color: Colors.white,
                                    fontSize: 20.h,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
