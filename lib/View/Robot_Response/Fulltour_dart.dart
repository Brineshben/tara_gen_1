import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Service/Api_Service.dart';

import '../../Controller/Backgroud_controller.dart';
import '../../Controller/FulltourController.dart';
import '../../Model/Navigate_model.dart';
import '../../Utils/colors.dart';
import '../../Utils/popups.dart';
import '../Settings/settings.dart';

class ListAnimationdData extends StatefulWidget {
  @override
  _ListAnimationdDataState createState() => _ListAnimationdDataState();
}

class _ListAnimationdDataState extends State<ListAnimationdData> {
  @override
  void initState() {
    Get.find<FullTourControllerNew>().fetchFullTourData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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

          /// Main Content
          Column(
            children: [
              GetX<BatteryController>(builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Row(
                    children: [
                      Row(
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
                                  color: Colors.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15).r),
                              child: Icon(
                                Icons.arrow_back_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Center(
                            child: Text(
                              "ADD NEW NAVIGATION LIST",
                              style: GoogleFonts.oxygen(
                                  color: controller.foregroundColor.value,
                                  fontSize: 25.h,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      // Obx(
                      //   () => Material(
                      //     color: Colors.transparent,
                      //     child: InkWell(
                      //       borderRadius: BorderRadius.circular(12),
                      //       onTap: () {
                      //         // fullTourController.pickTime(context);
                      //       },
                      //       child: Ink(
                      //         padding: EdgeInsets.symmetric(
                      //           horizontal: 12,
                      //           vertical: 8,
                      //         ),
                      //         decoration: BoxDecoration(
                      //           color: Colors.white54,
                      //           borderRadius: BorderRadius.circular(12),
                      //         ),
                      //         child: Text(
                      //           // "⏰ ${fullTourController.selectedTime.value.format(context)}",
                      //           'time',
                      //           style: TextStyle(
                      //             color: Colors.black,
                      //             fontSize: 14,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                );
              }),
              GetX<BatteryController>(builder: (controller) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              Text("DESTINATIONS LIST",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: controller.foregroundColor.value,
                                  )),
                              const SizedBox(height: 30),
                              Expanded(
                                child: Obx(() {
                                  FullTourControllerNew controller =
                                      Get.find<FullTourControllerNew>();
                                  return controller.dataNavigation.isNotEmpty
                                      ? ListView.builder(
                                          itemCount:
                                              controller.dataNavigation.length,
                                          itemBuilder: (context, index) {
                                            final item = controller
                                                .dataNavigation[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  splashColor: Colors.blue
                                                      .withOpacity(0.3),
                                                  highlightColor: Colors.green
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  onTap: () {
                                                    controller.addData(item);
                                                  },
                                                  child: buildInfoCard(size,
                                                      item.name ?? "No Name"),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : const Center(
                                          // Centering "no data found"
                                          child: Text(
                                            "No Data Found",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        );
                                }),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(
                            thickness: 0.5, color: Colors.grey, width: 30),
                        Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              Text("SELECTED DESTINATIONS LIST",
                                  style: TextStyle(
                                    color: controller.foregroundColor.value,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(height: 30),
                              Expanded(
                                child: Obx(() {
                                  FullTourControllerNew controller =
                                      Get.find<FullTourControllerNew>();

                                  return controller.newDataNavigation.isNotEmpty
                                      ? ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              SizedBox(height: 10),
                                          itemCount: controller
                                              .newDataNavigation.length,
                                          itemBuilder: (context, index) {
                                            final item = controller
                                                .newDataNavigation[index];

                                            return Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                splashColor: Colors.blue
                                                    .withOpacity(0.3),
                                                highlightColor: Colors.green
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                                onTap: () {
                                                  controller.removeData(item);
                                                },
                                                child: buildInfoCardDelete(size,
                                                    item.name ?? "No Name"),
                                              ),
                                            );
                                          },
                                        )
                                      : const Center(
                                          // Centering "no data found"
                                          child: Text(
                                            "No Data Found",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        );
                                }),
                              ),
                              const SizedBox(height: 30),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    splashColor: Colors.green.withOpacity(0.3),
                                    highlightColor:
                                        Colors.green.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20.r),
                                    onTap: () async {
                                      try {
                                        print("bennn");
                                        List<NavigationData> selectedData =
                                            Get.find<FullTourControllerNew>()
                                                .newDataNavigation;
                                        List<int> dataz = [];
                                        print("bennn$dataz");
                                        for (var element in selectedData) {
                                          // int parsedId = int.tryParse(element. ?? "0");
                                          int parsedId = element.id ?? 0;
                                          dataz.add(parsedId);
                                        }
                                        Map<String, dynamic> resp =
                                            await ApiServices.navigationSubmit(
                                                navigationData: dataz);

                                        if (resp['status'] == "ok") {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
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
                                      } catch (e) {
                                        print(
                                            "-----------------errrrr------------------${e.toString()}");
                                      }
                                    },
                                    child: buildInfoCard(
                                      size,
                                      "Submit",
                                      color: Colors.green,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

Widget buildInfoCardDelete(Size size, String title,
    {Color color = Colors.black}) {
  return Ink(
    width: size.width * 0.20,
    padding: EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      border: Border.all(color: Colors.blue),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade400,
          spreadRadius: 1,
          blurRadius: 5,
        ),
      ],
    ),
    height: 55,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Icon(
          Icons.delete,
          color: Colors.black,
          size: 20,
        ),
      ],
    ),
  );
}

Widget buildInfoCard2(Size size, String title) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [ColorUtils.userdetailcolor, ColorUtils.userdetailcolor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [
        BoxShadow(
          color: Colors.white,
          spreadRadius: 0,
          blurRadius: 0,
          offset: Offset(0, 0),
        ),
      ],
    ),
    width: size.width * 0.40,
    height: size.height * 0.075,
    child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 18.h,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.delete,
            color: Colors.red,
            size: 20,
          )
        ],
      ),
    ),
  );
}

// Widget buildInfoCardDelete(Size size, String title) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Ink(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [ColorUtils.userdetailcolor, ColorUtils.userdetailcolor],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.white,
//             spreadRadius: 0,
//             blurRadius: 0,
//             offset: Offset(0, 0),
//           ),
//         ],
//       ),
//       width: size.width * 0.20,
//       height: size.height * 0.075,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 20, right: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               title,
//               style: GoogleFonts.orbitron(
//                 color: Colors.white,
//                 fontSize: 18.h,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Icon(
//               Icons.delete,
//               color: Colors.white,
//               size: 20,
//             )
//           ],
//         ),
//       ),
//     ),
//   );
// }
