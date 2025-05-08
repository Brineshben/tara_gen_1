import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Controller/description_controller.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/colors.dart';
import 'package:ihub/View/Home_Screen/battery_Widget.dart';
import 'package:ihub/View/Settings/Add_Description.dart';

class DescriptionListScreen extends StatefulWidget {
  const DescriptionListScreen({Key? key}) : super(key: key);

  @override
  State<DescriptionListScreen> createState() => _DescriptionListScreenState();
}

class _DescriptionListScreenState extends State<DescriptionListScreen> {
  final controller = Get.find<DescriptionController>();

  @override
  void initState() {
    super.initState();
    Get.find<DescriptionController>().fetchDescription();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white, // makes it white
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddDescriptionPage()));
        },
        child: Icon(Icons.add, color: Colors.black), // icon color
      ),
      body: Stack(
        children: [
          // Background image
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

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button and Title
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: 60.h,
                              width: 60.h,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15).r,
                              ),
                              child: const Icon(Icons.arrow_back_outlined,
                                  color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "DESCRIPTION LIST",
                            style: GoogleFonts.oxygen(
                              color: Colors.white,
                              fontSize: 25.h,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      // Battery Icon
                      GetX<BatteryController>(
                        builder: (batteryController) {
                          int batteryLevel = int.tryParse(
                                batteryController.background.value?.data?.first
                                        .robot?.batteryStatus ??
                                    "0",
                              ) ??
                              0;
                          return BatteryIcon(batteryLevel: batteryLevel);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Description List
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
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return SizedBox(
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
                                        'Are you sure you want to delete this description',
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
                                                color: Colors
                                                    .black), // Border color
                                          ),
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                              color: Colors.black, // Text color
                                              fontSize: 16.h,
                                            ),
                                          ),
                                        ),
                                        FilledButton(
                                          onPressed: () async {
                                            final response = await ApiServices
                                                .deleteDescription(
                                                    item.id ?? 0);

                                            if (response['status'] == "ok") {
                                              Get.back();
                                              Get.snackbar(
                                                margin: EdgeInsets.all(20),
                                                "Success",
                                                response['message'] ??
                                                    "Description deleted successfully",
                                                backgroundColor: Colors.green,
                                                colorText: Colors.white,
                                                snackPosition:
                                                    SnackPosition.TOP,
                                                duration: Duration(seconds: 3),
                                              );

                                              Get.find<DescriptionController>()
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
                                                    ColorUtils.userdetailcolor),
                                          ),
                                          child: Text(
                                            "Yes",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.h),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                title:
                                    Text(item.description ?? 'No Description'),
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
                      );
                    },
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
