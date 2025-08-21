import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/Utils/toast.dart';
import 'package:ihub/View/battery/controller/battery_config_controller.dart';
import 'package:shimmer/shimmer.dart';

class GlassmorphismModal extends StatelessWidget {
  final TextEditingController lowBatteryController;
  final TextEditingController backHomeEntryController;
  const GlassmorphismModal({
    super.key,
    required this.lowBatteryController,
    required this.backHomeEntryController,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<BatteryConfigController>(
      builder: (provider) {
        return ChildGlasmorphism(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: SingleChildScrollView(
                    child: Center(
                      child: provider.isLoadingForFetch.value
                          ? Column(
                              children: List.generate(5, (_) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey.shade800,
                                    highlightColor: Colors.grey.shade600,
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade800,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Container(
                                        height: 15,
                                        width: 100,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    'Update Battery Config',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 30),
                                Text(
                                  'Low Battery entry',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),

                                SizedBox(height: 10),

                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF3A4A4A).withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: lowBatteryController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Enter low battery message',
                                      hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.4),
                                        fontSize: 10,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20),

                                Text(
                                  'Back to home entry',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),

                                SizedBox(height: 10),

                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF3A4A4A).withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: backHomeEntryController,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 16,
                                    ),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'Enter back to home message',
                                      hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.4),
                                        fontSize: 10,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 40),
                                GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();

                                    final batteryText =
                                        lowBatteryController.text;
                                    final homeText =
                                        backHomeEntryController.text;

                                    final batteryValue = double.tryParse(
                                      batteryText,
                                    );
                                    final homeValue = double.tryParse(homeText);

                                    if (batteryValue == null ||
                                        homeValue == null) {
                                      showTopRightToast(
                                        color: Colors.red,
                                        context: context,
                                        message: "Please enter valid numbers",
                                      );
                                      return;
                                    }

                                    if (batteryValue < 0 ||
                                        batteryValue > 100 ||
                                        homeValue < 0 ||
                                        homeValue > 100) {
                                      showTopRightToast(
                                        color: Colors.red,
                                        context: context,
                                        message:
                                            "Values must be between 0 and 100",
                                      );

                                      return;
                                    }

                                    if (batteryValue == homeValue) {
                                      showTopRightToast(
                                        color: Colors.red,
                                        context: context,
                                        message:
                                            "Battery and Home values must not be the same",
                                      );
                                      return;
                                    }

                                    if (batteryValue > homeValue) {
                                      showTopRightToast(
                                        color: Colors.red,
                                        context: context,
                                        message:
                                            "Battery value must be less than Home value",
                                      );
                                      return;
                                    }

                                    provider.lowBatteryEntry.value = batteryText;
                                    provider.backToHomeEntry.value = homeText;
                                    provider.updateChargeValues(context);
                                  
                                  },
                                  child: ChildGlasmorphism(
                                    borderRadius: 30,
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 40,
                                      child: ShaderMask(
                                        shaderCallback: (bounds) =>
                                            const LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color.fromARGB(
                                                  219,
                                                  255,
                                                  255,
                                                  255,
                                                ), // White
                                                Color(0xFF999999), // Grey
                                              ],
                                            ).createShader(bounds),
                                        child: Center(
                                          child: provider.isLoadingForUpdate.value
                                              ? SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                )
                                              : Text(
                                                  'Save Changes',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
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
          ),
        );
      },
    );
  }
}
