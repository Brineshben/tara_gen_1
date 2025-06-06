import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Controller/language_controller.dart';
import 'package:ihub/Utils/header.dart';

class LanguageList extends StatefulWidget {
  const LanguageList({super.key});

  @override
  State<LanguageList> createState() => _LanguageListState();
}

class _LanguageListState extends State<LanguageList> {
  final languageController = Get.find<LanguageController>();

  @override
  @override
  void initState() {
    super.initState();
    languageController.fetchLanguages();
    languageController.setLanguage();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
          ),
          GetX<BackgroudController>(
            builder: (BackgroudController controller) {
              final bgImage = controller.backgroundModel.value?.backgroundImage;
              return Positioned.fill(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    (bgImage != null && bgImage.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: bgImage,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                                controller.defaultIMage,
                                fit: BoxFit.cover),
                            errorWidget: (context, url, error) => Image.asset(
                                controller.defaultIMage,
                                fit: BoxFit.cover),
                          )
                        : Image.asset(controller.defaultIMage,
                            fit: BoxFit.cover),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        color: Colors.black.withOpacity(0),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Obx(() {
            if (languageController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Expanded(
                  child: GetX<LanguageController>(
                    builder: (controller) {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 90, bottom: 20),
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.sizeOf(context).width * 0.2,
                          ),
                          itemCount: controller.languages.length,
                          itemBuilder: (context, index) {
                            final lang = controller.languages[index];
                            return Card(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              child: RadioListTile(
                                value: lang,
                                groupValue: controller.selectedLanguage.value,
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.setSelectedLanguage(value);
                                    setState(() {});
                                  }
                                },
                                title: Text(
                                  lang,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: controller.selectedLanguage.value ==
                                            lang
                                        ? Colors.green
                                        : Colors.black87,
                                  ),
                                ),
                                activeColor: Colors.green,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
          Column(
            children: const [
              Header(
                isBack: true,
                screenName: "SELECT LANGUAGE",
                isLanguage: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
