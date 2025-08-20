import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/Utils/toast.dart';

import '../../Service/Api_Service.dart';

class ApiKey extends StatefulWidget {
  const ApiKey({Key? key}) : super(key: key);

  @override
  State<ApiKey> createState() => _ApiKeyState();
}

class _ApiKeyState extends State<ApiKey> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController ip = TextEditingController();

  bool isLading = false;

  @override
  void initState() {
    super.initState();
    _hideSystemUI();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive); // Hide status bar again
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF608878).withOpacity(0.2), // light green
                  Color(0xFF18221E).withOpacity(0.2), // dark green
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.transparent),
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GetX<BatteryController>(
                    builder: (controller) {
                      return Container(
                        margin: EdgeInsets.only(
                            left: 40.w, bottom: 15, right: 40.w, top: 50.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'NEW API KEY',
                              style: TextStyle(
                                fontSize: 25.h,
                                fontWeight: FontWeight.bold,
                                color: controller.foregroundColor.value,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40.w, right: 40.w),
                    height: size.height * 0.2,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: ip,
                      validator: (val) => val!.trim().isEmpty
                          ? 'Please Enter New API key'
                          : null,
                      decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.white38),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                          hintText: "Enter New API key",
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
                                const BorderRadius.all(Radius.circular(10.0)).r,
                          ),
                          fillColor: Colors.blueGrey[900],
                          filled: true),
                      maxLines: 5,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    splashColor: Colors.white,
                    highlightColor: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20.r),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          if (ip.text.isNotEmpty) {
                            isLading = true;
                            setState(() {});
                            Map<String, dynamic> resp =
                                await ApiServices.ApiKey(Data: ip.text);

                            isLading = false;
                            setState(() {});

                            if (resp['status'] == "ok") {
                              Navigator.of(context).pop();

                              FocusManager.instance.primaryFocus?.unfocus();
                              showTopRightToast(
                                context: context,
                                message: "${resp['message']}",
                                color: Colors.green,
                              );
                            } else {
                              showTopRightToast(
                                context: context,
                                message: "Something went wrong.",
                                color: Colors.red,
                              );
                            }
                          }
                        }
                      },
                      child: ChildGlasmorphism(
                        child: Container(
                          width: size.width * 0.22,
                          height: 55,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: isLading
                                ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 20,
                                  children: [
                                    SizedBox(
                                      width: 25, height: 25,
                                      child: CircularProgressIndicator(color: Colors.white,strokeWidth: 2,),),
                                      Text(
                                        'SUBMIT',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                  ],
                                )
                                : Text(
                                    'SUBMIT',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Back Button
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 30),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 10),
                const Text(
                  'API KEY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
