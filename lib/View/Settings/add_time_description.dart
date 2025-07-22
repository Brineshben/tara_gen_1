import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Utils/header.dart';

import '../../Controller/description_controller.dart';
import '../../Utils/colors.dart';

class AddDescriptionPage extends StatefulWidget {
  final bool isEdit;
  final int id;
  final String? time;
  final String description;
  const AddDescriptionPage({
    Key? key,
    required this.id,
    required this.isEdit,
    required this.time,
    required this.description,
  }) : super(key: key);

  @override
  State<AddDescriptionPage> createState() => _AddDescriptionPageState();
}

class _AddDescriptionPageState extends State<AddDescriptionPage> {
  final TextEditingController textController = TextEditingController();
  final descriptionController = Get.find<DescriptionController>();

  final List<String> _timeOptions = [
    'morning',
    'afternoon',
    'evening',
    'night',
    // 'all time'
  ];
  String? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.time;
    textController.text = widget.description;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Color getOppositeColor(Color color) {
    return Color.fromARGB(
      color.alpha,
      255 - color.red,
      255 - color.green,
      255 - color.blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: GetX<BatteryController>(builder: (controller) {
                return Column(
                  children: [
                    SizedBox(height: 120),
                    DropdownButtonFormField<String>(
                      dropdownColor:
                          getOppositeColor(controller.foregroundColor.value),
                      value: _selectedTime,
                      items: _timeOptions.map((time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text(
                            time[0].toUpperCase() + time.substring(1),
                            style: GoogleFonts.poppins(
                              color: controller.foregroundColor.value,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTime = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Select Time of Day",
                        labelStyle: GoogleFonts.poppins(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorUtils.userdetailcolor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    /// Description Field
                    TextFormField(
                      controller: textController,
                      maxLines: 6,
                      style: GoogleFonts.oxygen(
                          color: controller.foregroundColor.value),
                      decoration: InputDecoration(
                        labelText: "Enter Description",
                        labelStyle: GoogleFonts.poppins(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorUtils.userdetailcolor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),

                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.isEdit) {
                            descriptionController.editDescription(
                              description: textController.text.trim(),
                              time: _selectedTime ?? '',
                              id: widget.id.toString(),
                            );
                          } else {
                            descriptionController.submitDescription(
                              description: textController.text.trim(),
                              time: _selectedTime ?? '',
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                );
              }),
            ),
          ),
          Column(
            children: [
              Header(
                isBack: true,
                screenName:
                    widget.isEdit ? "UPDATE DESRIPTION" : "ADD DESRIPTION",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
