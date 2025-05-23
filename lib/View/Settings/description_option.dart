import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Utils/header.dart';
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
                      Image.asset(controller.defaultIMage, fit: BoxFit.cover),
                  errorWidget: (context, url, error) =>
                      Image.asset(controller.defaultIMage, fit: BoxFit.cover),
                ),
              );
            },
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
          Column(
            children: [
              Header(
                isBack: true,
                screenName: "DESCRIPTION OPTIONS", page: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
