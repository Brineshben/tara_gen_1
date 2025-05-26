import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Controller/description_controller.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/colors.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/View/Settings/add_time_description.dart';

class TimeDescription extends StatefulWidget {
  const TimeDescription({Key? key}) : super(key: key);

  @override
  State<TimeDescription> createState() => _TimeDescriptionState();
}

class _TimeDescriptionState extends State<TimeDescription> {
  final controller = Get.find<DescriptionController>();

  @override
  void initState() {
    super.initState();
    Get.find<DescriptionController>().fetchDescription();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white, // makes it white
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddDescriptionPage(
                          id: 0,
                          isEdit: false,
                          description: '',
                          time: null,
                        )));
          },
          child: Icon(Icons.add, color: Colors.black), // icon color
        ),
        body: Stack(
          children: [
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
                  child: GetX<DescriptionController>(
                    builder: (controller) {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final dataList =
                          controller.descriptionModel.value?.data ?? [];

                      if (dataList.isEmpty) {
                        return const Center(
                          child: Text(
                            'No descriptions found',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }

                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 90),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: ListView.builder(
                              itemCount: dataList.length,
                              itemBuilder: (context, index) {
                                final item = dataList[index];
                                return Card(
                                  color: Colors.white.withOpacity(0.8),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: ListTile(
                                    onTap: () {
                                      Get.dialog(
                                        barrierDismissible: false,
                                        AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                          ),
                                          title: Column(
                                            children: [
                                              Icon(
                                                Icons.warning,
                                                color: Colors.red,
                                                size: 50.h,
                                              ),
                                            ],
                                          ),
                                          content: Text(
                                            'Are you sure you want to delete or edit this description?',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16.h),
                                          ),
                                          actionsAlignment:
                                              MainAxisAlignment.center,
                                          actions: [
                                            OutlinedButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(
                                                    color: Colors.black),
                                              ),
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.h),
                                              ),
                                            ),
                                            OutlinedButton(
                                              onPressed: () {
                                                Get.back();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddDescriptionPage(
                                                      id: item.id ?? 0,
                                                      isEdit: true,
                                                      description:
                                                          item.description ??
                                                              '',
                                                      time: item.timeOfDay,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                "Edit",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 16.h),
                                              ),
                                            ),
                                            FilledButton(
                                              onPressed: () async {
                                                final response =
                                                    await ApiServices
                                                        .deleteDescription(
                                                            item.id ?? 0);

                                                if (response['status'] ==
                                                    "ok") {
                                                  Get.back();
                                                  Get.snackbar(
                                                    margin: EdgeInsets.all(20),
                                                    "Success",
                                                    response['message'] ??
                                                        "Description deleted successfully",
                                                    backgroundColor:
                                                        Colors.green,
                                                    colorText: Colors.white,
                                                    snackPosition:
                                                        SnackPosition.TOP,
                                                    duration:
                                                        Duration(seconds: 3),
                                                  );

                                                  Get.find<
                                                          DescriptionController>()
                                                      .fetchDescription();
                                                } else {
                                                  Get.back();
                                                  Get.snackbar(
                                                    margin: EdgeInsets.all(20),
                                                    "Error",
                                                    response['message'] ??
                                                        "Something went wrong",
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white,
                                                    snackPosition:
                                                        SnackPosition.TOP,
                                                  );
                                                }
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                        ColorUtils
                                                            .userdetailcolor),
                                              ),
                                              child: Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.h),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    title: Text(
                                        item.description ?? 'No Description'),
                                    subtitle: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(item.timeOfDayDisplay ?? ''),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
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
                  screenName: "TIME DESCRIPTION LIST",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
