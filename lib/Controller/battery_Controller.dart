import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Model/battery_offline_model.dart';
import 'package:ihub/Utils/toast.dart';
import 'package:lottie/lottie.dart';

import '../Model/batteryModel.dart';
import '../Service/Api_Service.dart';

class BatteryController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<BatteryModel?> batteryModel = Rx(null);
  Rx<OfflineBatteryModel?> offlineBatteryModel = Rx(null);
  bool popupshow = false;

  var roboId;
  Rx<Color> foregroundColor = Colors.white.obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  RxBool isRotale = false.obs;
  RxInt batteryStatus = 0.obs;
  Future<void> fetchBattery(int userID, BuildContext context) async {
    isLoading.value = true;
    isLoaded.value = false;

    try {
      Map<String, dynamic>? onlineBatteryResponse;
      Map<String, dynamic>? offlineBatteryResponse;

      // Try fetching offline data
      try {
        offlineBatteryResponse = await ApiServices.batteryOffline();

        if (offlineBatteryResponse['status'] == 'ok') {
          offlineBatteryModel.value =
              OfflineBatteryModel.fromJson(offlineBatteryResponse);

          String? offlineBattery =
              offlineBatteryModel.value?.data?.batteryStatus ?? '0';

          batteryStatus.value = int.tryParse(offlineBattery) ?? 0;

          if (batteryStatus <= 30 && batteryStatus >= 0 && !popupshow) {
            popupshow = true;
            _showLowBatteryDialog(context);
          }
        } else {
          print("Offline battery status not OK");
          offlineBatteryResponse = null;
        }
      } catch (e) {
        print('Error fetching offline battery: $e');
        offlineBatteryResponse = null;
        showTopRightToast(
          context: context,
          message:
              "Can't load battery info from robot. Please check the Wi-Fi or IP settings.",
          color: Colors.red,
        );
      }

      // Try fetching online data
      try {
        onlineBatteryResponse = await ApiServices.battery(userId: userID);

        if (onlineBatteryResponse['status'] == 'ok') {
          batteryModel.value = BatteryModel.fromJson(onlineBatteryResponse);
          roboId = batteryModel.value?.data?.first.robot?.roboId;
          print("Robo ID: $roboId");
        } else {
          print("Online battery status not OK");
          onlineBatteryResponse = null;
        }
      } catch (e) {
        print('Error fetching online battery: $e');
        onlineBatteryResponse = null;
      }

      print("API Online Battery Response: $onlineBatteryResponse");
      print("API Offline Battery Response: $offlineBatteryResponse");

      print("Final Battery Level: ${batteryStatus.value}");

      isLoaded.value = true;
    } catch (e) {
      print("Unexpected error in fetchBattery(): $e");
      isLoaded.value = false;
      showTopRightToast(
        context: context,
        message: "Something went wrong while fetching battery data.",
        color: Colors.red,
      );
    } finally {
      resetStatus();
    }
  }

  Future<void> _showLowBatteryDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(
        0.3,
      ), // Darker background for glass effect
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Lottie Animation
                      Container(
                        width: 120,
                        height: 120,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Lottie.asset("assets/batterylottie.json"),
                      ),

                      const SizedBox(height: 20),

                      // Title
                      Text(
                        "BATTERY LOW",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Content
                      Text(
                        "Hey there! My energy levels are running low. I need a recharge soon to keep assisting you.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          height: 1.4,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Button
                      Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => Navigator.pop(context),
                            child: Center(
                              child: Text(
                                "OK PROCEED",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
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
        );
      },
    );
  }
}
