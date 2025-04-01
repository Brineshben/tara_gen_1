import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Utils/colors.dart';

class AddDescription extends StatelessWidget {
  AddDescription({super.key});

  final List<Map<String, String>> items = [
    {
      'name': 'Roy',
      'details': 'Anxiety Disorder | AGE : 25',
      'extra': 'Specialized in UI/UX and API integration'
    },
    {
      'name': 'Jane Smith',
      'details': 'Anxiety Disorder | AGE : 25',
      'extra': 'Expert in Node.js, Python, and Databases'
    },
    {
      'name': 'Alice Brown',
      'details': 'Anxiety Disorder | AGE : 25',
      'extra': 'Specialized in Flutter and React Native'
    },
    {
      'name': 'Alice Brown',
      'details': 'Anxiety Disorder | AGE : 25',
      'extra': 'Specialized in Flutter and React Native'
    },
    {
      'name': 'Alice Brown',
      'details': 'Anxiety Disorder | AGE : 25',
      'extra': 'Specialized in Flutter and React Native'
    },
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
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
                padding: const EdgeInsets.only(left: 20, top: 20,bottom: 40),
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
                        "ADD DESCRIPTION",
                        style: GoogleFonts.oxygen(
                            color: Colors.white,
                            fontSize: 25.h,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 150, right: 150, bottom: 1),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Card(
                        color: Colors.white.withOpacity(0.8),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 2,
                        child: ExpansionTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide.none),
                          collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide.none),
                          title: Center(
                            child: Text("SPOT 1",
                                style: TextStyle(
                                    fontSize: 15.h,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black)),
                          ),
                          // subtitle: Column(
                          //   children: [
                          //     Row(
                          //       children: [
                          //         Text("APPOINMENT DATE: ",
                          //             style: TextStyle(
                          //                 fontSize: 15.h,
                          //                 fontWeight: FontWeight.w500,
                          //                 color: Colors.black)),
                          //
                          //       ],
                          //     ),
                          //   ],
                          // ),
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("DESCRIPTION",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 10),
                                  Container(
                                    height: size.height * 0.1,
                                    child: TextFormField(

                                      style: const TextStyle(color: Colors.white),
                                      minLines: 1,

                                      validator: (val) => val!.trim().isEmpty
                                          ? 'Please Enter Description.'
                                          : null,
                                      decoration: InputDecoration(
                                          hintStyle: const TextStyle(color: Colors.white38),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.h, horizontal: 10.w),
                                          hintText: "Enter Description  ",
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [ColorUtils.userdetailcolor,ColorUtils.userdetailcolor],

                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                        width: 40.w,
                                        height: 40.h,
                                        child: Center(
                                          child: Text(
                                            'SUBMIT',
                                            style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 16.h,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
