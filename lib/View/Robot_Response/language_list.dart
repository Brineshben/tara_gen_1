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

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                          vertical: 100,
                          horizontal: MediaQuery.sizeOf(context).width * 0.2,
                        ),
                        itemCount: controller.languages.length,
                        itemBuilder: (context, index) {
                          final lang = controller.languages[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: RadioListTile(
                              value: lang,
                              groupValue: controller.selectedLanguage.value,
                              onChanged: (value) {
                                if (value != null) {
                                  controller.setSelectedLanguage(value
                                      .toString()); // ✅ only this line needed
                                  setState(() {});
                                }
                              },
                              title: Text(
                                lang,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color:
                                      controller.selectedLanguage.value == lang
                                          ? Colors.green
                                          : Colors.black87,
                                ),
                              ),
                              activeColor: Colors.green,
                            ),
                          );
                        },
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
                isLanguage: false, page: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
