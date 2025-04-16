import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/Nav_description_controller.dart';
import '../../Controller/Navigate_Controller.dart';
import '../../Service/Api_Service.dart';
import '../../Utils/colors.dart';
import '../../Utils/popups.dart';
import 'VideoPlayer.dart';

class AddDescription extends StatefulWidget {
  AddDescription({super.key});

  @override
  State<AddDescription> createState() => _AddDescriptionState();
}

class _AddDescriptionState extends State<AddDescription> {
  @override
  void initState() {
    Get.find<NavigateDescriptionController>().NavigateData();

    super.initState();
  }

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
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 40),
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
                child: GetX<NavigateDescriptionController>(
                  builder: (NavigateDescriptionController controller) {
                    return ListView.builder(
                      padding:
                          EdgeInsets.only(left: 150, right: 150, bottom: 1),
                      itemCount: controller.DataList.length,
                      itemBuilder: (context, index) {
                        return Card(
                            color: Colors.white.withOpacity(0.3),
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
                                child: Text(
                                    "${controller.DataList[index]?.name?.toUpperCase()}",
                                    style: TextStyle(
                                        fontSize: 20.h,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white)),
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
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("DESCRIPTION",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(height: 10),
                                      Container(
                                        height: size.height * 0.1,
                                        child: TextFormField(
                                          controller:
                                              controller.textControllers[index],
                                          style: const TextStyle(
                                              color: Colors.white),
                                          minLines: 1,
                                          validator: (val) =>
                                              val!.trim().isEmpty
                                                  ? 'Please Enter Description.'
                                                  : null,
                                          decoration: InputDecoration(
                                              hintStyle: const TextStyle(
                                                  color: Colors.white38),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10.h,
                                                      horizontal: 10.w),
                                              hintText: "Enter Description  ",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ).r,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.blue,
                                                    width: 1.0),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                            Radius.circular(10))
                                                        .r,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.blue,
                                                    width: 1.0),
                                                borderRadius: const BorderRadius
                                                        .all(
                                                        Radius.circular(10.0))
                                                    .r,
                                              ),
                                              fillColor: Colors.blueGrey[900],
                                              filled: true),
                                          maxLines: 7,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          controller.DataList[index]?.video !=
                                                  null
                                              ? GestureDetector(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            ColorUtils
                                                                .userdetailcolor,
                                                            ColorUtils
                                                                .userdetailcolor
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.r),
                                                      ),
                                                      width: 40.w,
                                                      height: 40.h,
                                                      child: Center(
                                                        child: Text(
                                                          'PLAY VIDEO',
                                                          style:
                                                              GoogleFonts.inter(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      16.h,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    _showVideoDialog(context,
                                                        "${controller.DataList[index]?.video}");
                                                  },
                                                )
                                              : SizedBox(),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 4),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      ColorUtils
                                                          .userdetailcolor,
                                                      ColorUtils.userdetailcolor
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.r),
                                                ),
                                                width: 40.w,
                                                height: 40.h,
                                                child: Center(
                                                  child: Text(
                                                    'SUBMIT',
                                                    style: GoogleFonts.inter(
                                                        color: Colors.white,
                                                        fontSize: 16.h,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () async {
                                              Map<String, dynamic> resp =
                                                  await ApiServices
                                                      .navigateDescriptionSubmit(
                                                          data: controller
                                                              .textControllers[
                                                                  index]
                                                              .text,
                                                          userId: controller
                                                                  .DataList[
                                                                      index]
                                                                  ?.id ??
                                                              0);

                                              if (resp['status'] == 'ok') {
                                                ProductAppPopUps.submit(
                                                  title: "Success",
                                                  message: resp['message'],
                                                  actionName: "Close",
                                                  iconData: Icons.done,
                                                  iconColor: Colors.green,
                                                );
                                              } else {
                                                ProductAppPopUps.submit(
                                                  title: "FAILED",
                                                  message:
                                                      "Something went wrong.",
                                                  actionName: "Close",
                                                  iconData: Icons.info_outline,
                                                  iconColor: Colors.red,
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      // floatingActionButton: Container(
      //   margin: EdgeInsets.only(
      //       left: 30.w, top: 120.h, right: 20.w, bottom: 20.h),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       Container(
      //         decoration: BoxDecoration(
      //           gradient: LinearGradient(
      //             colors: [
      //               Colors.red,
      //               Colors.red
      //             ],
      //             begin: Alignment.topLeft,
      //             end: Alignment.bottomRight,
      //           ),
      //           borderRadius: BorderRadius.circular(
      //               10), // Ensure proper border radius
      //         ),
      //         child: Material(
      //           color: Colors.transparent, // Ensure the gradient is visible
      //           borderRadius: BorderRadius.circular(10),
      //           child: FloatingActionButton.extended(
      //             backgroundColor: Colors.transparent,
      //             onPressed: () {
      //               _showVideoDialog(context);
      //             },
      //             icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
      //             label: Text("EXIT APP",
      //                 style: GoogleFonts.orbitron(
      //                   color: Colors.white,
      //                   fontSize: 18.h,
      //                   fontWeight: FontWeight.bold,
      //                 )),
      //           ),
      //         ),
      //       ),
      //
      //     ],
      //   ),
      // )
    );
  }
}

void _showVideoDialog(BuildContext context, String video) {
  showDialog(
    context: context,
    builder: (context) => VideoDialog(video),
  );
}
