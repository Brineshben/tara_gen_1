import 'package:flutter/cupertino.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/Ipcontroller.dart';
import '../../Service/Api_Service.dart';
import '../../Utils/api_constant.dart';
import '../../Utils/popups.dart';
import 'maintanance.dart';

class ApiKey extends StatefulWidget {
  const ApiKey({Key? key}) : super(key: key);

  @override
  State<ApiKey> createState() => _ApiKeyState();
}

class _ApiKeyState extends State<ApiKey> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController NewIp = TextEditingController();

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

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
            ),

            GetX<BackgroudController>(
              builder: (BackgroudController controller) {
                return Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl:
                        controller.background.value?.backgroundImage ?? "",
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Image.asset("assets/images.jpg", fit: BoxFit.cover),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/images.jpg", fit: BoxFit.cover),
                  ),
                );
              },
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20,top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 60.h,
                          width: 60.h,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.grey.withOpacity(0.3),
                              //     blurRadius: 10,
                              //     spreadRadius: 0,
                              //   ),
                              // ],
                              borderRadius: BorderRadius.circular(15).r),
                          child: Icon(
                            Icons.arrow_back_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Center(
                        child: Text(
                          "ADD APIKEY",
                          style: GoogleFonts.oxygen(
                              color: Colors.white,
                              fontSize: 25.h,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),

                Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: 40.w, bottom: 15, right: 40.w,top: 50.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'NEW API KEY',
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
                              controller: NewIp,
                              validator: (val) => val!.trim().isEmpty
                                  ? 'Please Enter New API key'
                                  : null,
                              decoration: InputDecoration(
                                  hintStyle: const TextStyle(color: Colors.white38),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 10.w),
                                  hintText: "Enter New API key",
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
                          SizedBox(
                            height: 50,
                          ),
                          Material(
                            color: Colors.transparent,

                            child: InkWell(
                              splashColor: Colors.white,
                              highlightColor:Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20.r),                          onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                if(NewIp.text.isNotEmpty){

                                  Map<String, dynamic> resp =
                                  await ApiServices.ApiKey(Data:NewIp.text );

                                  if (resp['status'] == "ok") {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    ProductAppPopUps.submit2back(
                                      title: "SUCCESS",
                                      message: resp['message'].toString(),
                                      actionName: "Close",
                                      iconData: Icons.done,
                                      iconColor: Colors.green,
                                    );
                                  } else {
                                    ProductAppPopUps.submit(
                                      title: "FAILED",
                                      message: "Something went wrong.",
                                      actionName: "Close",
                                      iconData: Icons.info_outline,
                                      iconColor: Colors.red,
                                    );
                                  }
                                }
                                }
                              },
                              child: buildInfoCard(
                                  MediaQuery.of(context).size, 'SUBMIT'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
