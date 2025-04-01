import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/EnquirySubListModel.dart';
import '../../Controller/Login_api_controller.dart';
import 'Subdetails.dart';

class Subcategory extends StatefulWidget {
  final String data;
  final int enquiry;

  const Subcategory({Key? key, required this.enquiry, required this.data})
      : super(key: key);

  @override
  State<Subcategory> createState() => _SubcategoryState();
}

class _SubcategoryState extends State<Subcategory> {
  @override
  void initState() {
    _hideSystemUI();
    Get.find<EnquirySubListController>().fetchEnquirySubList(
        Get
            .find<UserAuthController>()
            .loginData
            .value
            ?.user
            ?.id ?? 0,
        widget.enquiry);
    super.initState();
  }
  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive); // Hide status bar again
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
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
                  imageUrl: controller.background.value?.backgroundImage ?? "",
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
                padding: const EdgeInsets.only(left: 20, top: 40, bottom: 30),
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
                            borderRadius: BorderRadius
                                .circular(15)
                                .r),
                        child: Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.data.toUpperCase(),
                      style: GoogleFonts.oxygen(
                          color: Colors.white,
                          fontSize: 25.h,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: GetX<EnquirySubListController>(
                  builder: (EnquirySubListController controller) {
                    if (controller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      );
                    } else {
                      return controller.enquiryList.isNotEmpty
                          ? Center(
                        child: Column(
                          children: List.generate(
                            controller.enquiryList.length,
                            // Change this to your dynamic list length
                                (index) =>
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return SubDetails(
                                                  subheading: controller
                                                      .enquiryList[index]
                                                      .enquiryDetails?.id ?? 0,
                                                  heading
                                                  : controller.enquiryList[index].enquiryDetails?.heading ?? "",
                                                  description: '',);
                                              },
                                            ));
                                      },
                                      child: buildInfoCard2(
                                          controller.enquiryList[index]
                                              .subheading ??
                                              " ",
                                          "sj")),
                                ),
                          ),
                        ),
                      )
                          : Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Center(
                            child: Text(
                              "Oops..No Data Found.",
                              style: TextStyle(
                                  fontSize: 10.w,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.red),
                            )),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard2(String title, String image) {
    final Size size = MediaQuery
        .of(context)
        .size;

    return Container(
      decoration: BoxDecoration(
        // color: Colors.white.withOpacity(0.2),

        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple], // Define gradient colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 0.01,
            offset: Offset(0, 0),
          ),
        ],
      ),
      width: size.width * 0.28,
      height: size.height * 0.080,
      child: Center(
        child: Padding(
          padding:
          const EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 4),
          child: Row(
            children: [
              Text(
                title,
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 18.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
