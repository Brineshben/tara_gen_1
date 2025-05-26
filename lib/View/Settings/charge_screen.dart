import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Controller/charge_screen_controller.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/speed/view/speed_page.dart';

class ChargeEntryView extends StatefulWidget {
  ChargeEntryView({super.key});

  @override
  State<ChargeEntryView> createState() => _ChargeEntryViewState();
}

class _ChargeEntryViewState extends State<ChargeEntryView> {
  final TextEditingController _batteryController = TextEditingController();
  final TextEditingController _homeController = TextEditingController();

  final ChargeScreenController settingsController =
      Get.find<ChargeScreenController>();

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await settingsController.fetchChargeValues();
    _batteryController.text = settingsController.lowBatteryEntry.value;
    _homeController.text = settingsController.backToHomeEntry.value;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
            ),
            Positioned.fill(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset("assets/stockimage.jpg", fit: BoxFit.cover),
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5.0,
                      sigmaY: 5.0,
                    ), // Blur level
                    child: Container(color: Colors.blue.withOpacity(0.2)),
                  ),
                ],
              ),
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
            Obx(
              () => settingsController.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber,
                      ),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 90),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                              top: 30,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextField(
                                  controller: _batteryController,
                                  maxLength: 3,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Low Battery Entry',
                                    labelStyle: TextStyle(
                                        // color: AppColor.primary,
                                        ),
                                    filled: true,
                                    fillColor: Colors.blueGrey[100],
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      borderSide: BorderSide(
                                          // color: AppColor.primary,
                                          ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      borderSide: BorderSide(
                                        // color: AppColor.primary,
                                        width: 2,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _homeController,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Back to Home Entry',
                                    labelStyle: TextStyle(
                                        // color: AppColor.primary,
                                        ),
                                    filled: true,
                                    fillColor: Colors.blueGrey[100],
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      borderSide: BorderSide(
                                          // color: AppColor.primary,
                                          ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      borderSide: BorderSide(
                                        // color: AppColor.primary,
                                        width: 2,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      final batteryValue = double.tryParse(
                                        _batteryController.text,
                                      );
                                      final homeValue = double.tryParse(
                                        _homeController.text,
                                      );

                                      if (batteryValue == null ||
                                          homeValue == null) {
                                        Get.snackbar(
                                          margin: EdgeInsets.all(20),
                                          'Invalid Input',
                                          'Please enter valid numbers',
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                        return;
                                      }
                                      if (batteryValue < 0 ||
                                          batteryValue > 100 ||
                                          homeValue < 0 ||
                                          homeValue > 100) {
                                        Get.snackbar(
                                          margin: EdgeInsets.all(20),
                                          'Invalid Value',
                                          'Values must be between 0 and 100',
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                        return;
                                      }

                                      settingsController.updateChargeValues(
                                        batteryEntry: _batteryController.text,
                                        homeEntry: _homeController.text,
                                      );
                                    },
                                    child: Ink(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF0F2027),
                                            Color(0xFF203A43),
                                            Color(0xFF2C5364),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
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
                      ),
                    ),
            ),
            Column(
              children: [
                Header(
                  isBack: true,
                  screenName: "BATTERY CONFIG",
                ),
              ],
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GetX<BatteryController>(
              builder: (controller) {
                return GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpeedControllerPage(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/speedometer.png",
                        width: 90,
                      ),
                      Text(
                        "Speed",
                        style: TextStyle(
                          fontSize: 16,
                          color: controller.foregroundColor.value,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
