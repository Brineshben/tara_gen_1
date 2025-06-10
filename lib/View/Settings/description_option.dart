import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/View/Settings/place_description.dart';
import 'package:ihub/View/Settings/settings.dart';
import 'package:ihub/View/Settings/time_description_list_screen.dart';

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
                buildInfoCard(onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlaceDescription()),
                  );
                }, MediaQuery.of(context).size, 'Place Description'),
                buildInfoCard(onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimeDescription(),
                    ),
                  );
                }, MediaQuery.of(context).size, 'Time Description'),
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

  Widget optionMenu(Size size, String title, {Color color = Colors.black}) {
    return Ink(
      width: size.width * 0.30,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(color: Colors.blue),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      height: 55,
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
