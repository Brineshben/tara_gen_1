import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../Controller/description_controller.dart';
import '../../Utils/colors.dart';

class AddDescriptionPage extends StatefulWidget {
  const AddDescriptionPage({Key? key}) : super(key: key);

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
    'night'
  ];
  String? _selectedTime;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
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
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: SizedBox(
                width: size.width * 0.5,
                height: size.width * 0.5,
                child: Lottie.asset(
                  "assets/loginimage.json",
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.grey[900],
                    value: _selectedTime,
                    items: _timeOptions.map((time) {
                      return DropdownMenuItem(
                        value: time,
                        child: Text(
                          time[0].toUpperCase() + time.substring(1),
                          style: GoogleFonts.oxygen(color: Colors.white),
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
                        color: Colors.white,
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
                    style: GoogleFonts.oxygen(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Enter Description",
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.white,
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
                        descriptionController.submitDescription(
                          description: textController.text.trim(),
                          time: _selectedTime ?? '',
                        );
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
