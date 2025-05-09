import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/View/Home_Screen/battery_Widget.dart';
import 'package:ihub/View/Settings/description_list_screen.dart';
import 'package:ihub/View/Settings/description_time.dart';
import 'package:ihub/View/Settings/settings.dart';

class DescriptionOption extends StatelessWidget {
  const DescriptionOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                      "Description Options",
                      style: GoogleFonts.poppins(
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
                          batteryController.background.value?.data?.first.robot
                                  ?.batteryStatus ??
                              "0",
                        ) ??
                        0;
                    return BatteryIcon(batteryLevel: batteryLevel);
                  },
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.white,
                    highlightColor: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20.r),
                    child: buildInfoCard(
                        MediaQuery.of(context).size, 'Place Description'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddDescription()),
                      );
                      ;
                    },
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.white,
                    highlightColor: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20.r),
                    child: buildInfoCard(
                        MediaQuery.of(context).size, 'Time Description'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DescriptionListScreen(),
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
