import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Utils/header.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/Nav_description_controller.dart';
import '../../Service/Api_Service.dart';
import 'VideoPlayer.dart';

class PlaceDescription extends StatefulWidget {
  PlaceDescription({super.key});

  @override
  State<PlaceDescription> createState() => _PlaceDescriptionState();
}

class _PlaceDescriptionState extends State<PlaceDescription> {
  @override
  void initState() {
    Get.find<NavigateDescriptionController>().getNavigation();
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          controller.backgroundModel.value?.backgroundImage ??
                              "",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                          controller.defaultIMage,
                          fit: BoxFit.cover),
                      errorWidget: (context, url, error) => Image.asset(
                          controller.defaultIMage,
                          fit: BoxFit.cover),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 10.0, sigmaY: 10.0), // Adjust blur strength
                      child: Container(
                        color: Colors.black.withOpacity(
                            0), // Required for BackdropFilter to work
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Column(
            children: [
              Expanded(
                child: GetX<NavigateDescriptionController>(
                  builder: (NavigateDescriptionController controller) {
                    return controller.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : controller.dataList.isEmpty
                            ? Center(
                                child: Text(
                                "No description found",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                            : Padding(
                                padding: const EdgeInsets.only(top: 90),
                                child: ListView.builder(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    left: 150,
                                    right: 150,
                                    bottom: 10,
                                  ),
                                  itemCount: controller.isExpandedList.length,
                                  itemBuilder: (context, index) {
                                    return Obx(
                                      () => Card(
                                          color: Colors.white,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          elevation: 2,
                                          child: ExpansionTile(
                                            key: Key(
                                                '${controller.isExpandedList[index]}_$index'),
                                            initiallyExpanded: controller
                                                .isExpandedList[index],
                                            onExpansionChanged: (value) {
                                              FocusScope.of(context).unfocus();
                                              controller.isExpandedList[index] =
                                                  value;
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                side: BorderSide.none),
                                            collapsedShape:
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    side: BorderSide.none),
                                            title: Center(
                                              child: Text(
                                                  "${controller.dataList[index]?.name?.toUpperCase()}",
                                                  style: TextStyle(
                                                      fontSize: 20.h,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.black)),
                                            ),
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("DESCRIPTION",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                    SizedBox(height: 10),
                                                    Container(
                                                      height:
                                                          size.height * 0.25,
                                                      child: TextFormField(
                                                        controller: controller
                                                                .descriptionControllers[
                                                            index],
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                        minLines: null,
                                                        validator: (val) => val!
                                                                .trim()
                                                                .isEmpty
                                                            ? 'Please Enter Description.'
                                                            : null,
                                                        decoration:
                                                            InputDecoration(
                                                                hintStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white38),
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        vertical: 10
                                                                            .h,
                                                                        horizontal:
                                                                            10
                                                                                .w),
                                                                hintText:
                                                                    "Enter Description  ",
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                    Radius.circular(
                                                                        10.0),
                                                                  ).r,
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .blue,
                                                                      width:
                                                                          1.0),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                              .all(
                                                                              Radius.circular(10))
                                                                          .r,
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: Colors
                                                                          .blue,
                                                                      width:
                                                                          1.0),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                              .all(
                                                                              Radius.circular(10.0))
                                                                          .r,
                                                                ),
                                                                fillColor: Colors
                                                                        .blueGrey[
                                                                    900],
                                                                filled: true),
                                                        maxLines: 7,
                                                      ),
                                                    ),
                                                    // SizedBox(height: 20),
                                                    // Text(
                                                    //   "NAME",
                                                    //   style: TextStyle(
                                                    //       fontSize: 12,
                                                    //       fontWeight:
                                                    //           FontWeight.w500),
                                                    // ),
                                                    // SizedBox(height: 10),
                                                    // TextFormField(
                                                    //   controller: controller
                                                    //           .textControllers[
                                                    //       index],
                                                    //   style: const TextStyle(
                                                    //       color: Colors.white),
                                                    //   minLines: null,
                                                    //   validator: (val) => val!
                                                    //           .trim()
                                                    //           .isEmpty
                                                    //       ? 'Please Enter Name.'
                                                    //       : null,
                                                    //   decoration:
                                                    //       InputDecoration(
                                                    //           hintStyle: const TextStyle(
                                                    //               color: Colors
                                                    //                   .white38),
                                                    //           contentPadding:
                                                    //               EdgeInsets.symmetric(
                                                    //                   vertical:
                                                    //                       10.h,
                                                    //                   horizontal:
                                                    //                       10.w),
                                                    //           hintText:
                                                    //               "Enter Name",
                                                    //           border:
                                                    //               OutlineInputBorder(
                                                    //             borderRadius:
                                                    //                 const BorderRadius
                                                    //                     .all(
                                                    //               Radius
                                                    //                   .circular(
                                                    //                       10.0),
                                                    //             ).r,
                                                    //           ),
                                                    //           enabledBorder:
                                                    //               OutlineInputBorder(
                                                    //             borderSide:
                                                    //                 const BorderSide(
                                                    //                     color: Colors
                                                    //                         .blue,
                                                    //                     width:
                                                    //                         1.0),
                                                    //             borderRadius:
                                                    //                 const BorderRadius
                                                    //                         .all(
                                                    //                         Radius.circular(10))
                                                    //                     .r,
                                                    //           ),
                                                    //           focusedBorder:
                                                    //               OutlineInputBorder(
                                                    //             borderSide:
                                                    //                 const BorderSide(
                                                    //                     color: Colors
                                                    //                         .blue,
                                                    //                     width:
                                                    //                         1.0),
                                                    //             borderRadius:
                                                    //                 const BorderRadius
                                                    //                         .all(
                                                    //                         Radius.circular(10.0))
                                                    //                     .r,
                                                    //           ),
                                                    //           fillColor: Colors
                                                    //                   .blueGrey[
                                                    //               900],
                                                    //           filled: true),
                                                    // ),
                                                    SizedBox(height: 20),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        // controller
                                                        //             .dataList[
                                                        //                 index]
                                                        //             ?.video !=
                                                        //         null
                                                        //     ? GestureDetector(
                                                        //         child: Padding(
                                                        //           padding:
                                                        //               const EdgeInsets
                                                        //                   .only(
                                                        //                   top:
                                                        //                       4),
                                                        //           child:
                                                        //               Container(
                                                        //             decoration:
                                                        //                 BoxDecoration(
                                                        //               borderRadius:
                                                        //                   BorderRadius.circular(
                                                        //                       20.r),
                                                        //               color: Colors
                                                        //                   .deepPurple,
                                                        //             ),
                                                        //             width: 40.w,
                                                        //             height:
                                                        //                 40.h,
                                                        //             child:
                                                        //                 Center(
                                                        //               child:
                                                        //                   Text(
                                                        //                 'PLAY VIDEO',
                                                        //                 style: GoogleFonts.poppins(
                                                        //                     color: Colors
                                                        //                         .white,
                                                        //                     fontSize:
                                                        //                         12,
                                                        //                     fontWeight:
                                                        //                         FontWeight.bold),
                                                        //               ),
                                                        //             ),
                                                        //           ),
                                                        //         ),
                                                        //         onTap: () {
                                                        //           _showVideoDialog(
                                                        //               context,
                                                        //               "${controller.dataList[index]?.video}");
                                                        //         },
                                                        //       )
                                                        //     : SizedBox(),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            controller
                                                                    .isExpandedList[
                                                                index] = false;

                                                            Map<String, dynamic>
                                                                resp =
                                                                await ApiServices
                                                                    .navigateDescriptionSubmit(
                                                              description:
                                                                  controller
                                                                      .descriptionControllers[
                                                                          index]
                                                                      .text,
                                                              name: controller
                                                                  .textControllers[
                                                                      index]
                                                                  .text,
                                                              userId: controller
                                                                      .dataList[
                                                                          index]
                                                                      ?.id ??
                                                                  0,
                                                            );

                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();

                                                            if (resp[
                                                                    'status'] ==
                                                                'ok') {
                                                              Get.snackbar(
                                                                "Updated",
                                                                "Description submitted successfully.",
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                colorText:
                                                                    Colors
                                                                        .white,
                                                                snackPosition:
                                                                    SnackPosition
                                                                        .BOTTOM,
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            16),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                              );
                                                            } else {
                                                              Get.snackbar(
                                                                "Failed",
                                                                resp['message'] ??
                                                                    "Something went wrong.",
                                                                backgroundColor:
                                                                    Colors.red,
                                                                colorText:
                                                                    Colors
                                                                        .white,
                                                                snackPosition:
                                                                    SnackPosition
                                                                        .BOTTOM,
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            16),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                              );
                                                            }
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8),
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          20.w,
                                                                      vertical:
                                                                          10.h),
                                                              // width: 120.w,
                                                              // height: 45.h,
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    Colors.green
                                                                        .shade600,
                                                                    Colors.green
                                                                        .shade400
                                                                  ],
                                                                  begin: Alignment
                                                                      .topLeft,
                                                                  end: Alignment
                                                                      .bottomRight,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.r),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .green
                                                                        .withOpacity(
                                                                            0.4),
                                                                    blurRadius:
                                                                        10,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            4),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  'SUBMIT',
                                                                  style:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    letterSpacing:
                                                                        1.2,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    );
                                  },
                                ),
                              );
                  },
                ),
              ),
            ],
          ),
          Column(
            children: [
              Header(
                isBack: true,
                screenName: "PLACE DESCRIPTION LIST",
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
