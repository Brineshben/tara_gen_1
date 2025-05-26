import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/View/Settings/time_description_list_screen.dart';
import 'package:ihub/View/Settings/place_description.dart';
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
                            builder: (context) => PlaceDescription()),
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
                          builder: (context) => TimeDescription(),
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
                screenName: "DESCRIPTION OPTIONS",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
