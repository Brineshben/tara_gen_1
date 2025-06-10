import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Controller/prompt_controller.dart';
import 'package:ihub/Utils/header.dart';
import 'package:ihub/View/Settings/settings.dart';

class PromptInputScreen extends StatefulWidget {
  final String id;
  final String initialPrompt;
  final bool isEdit;

  const PromptInputScreen({
    super.key,
    required this.id,
    required this.initialPrompt,
    required this.isEdit,
  });

  @override
  State<PromptInputScreen> createState() => _PromptInputScreenState();
}

class _PromptInputScreenState extends State<PromptInputScreen> {
  final TextEditingController promtTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    promtTextController.text = widget.initialPrompt;
  }

  @override
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
              padding: const EdgeInsets.symmetric(horizontal: 120),
              child: Column(
                children: [
                  const SizedBox(height: 120),
                  GetX<BatteryController>(
                    builder: (batteryController) {
                      return TextFormField(
                        maxLength: 300,
                        controller: promtTextController,
                        maxLines: 6,
                        style: TextStyle(
                            color: batteryController.foregroundColor.value),
                        decoration: InputDecoration(
                          labelText: "Enter prompt",
                          labelStyle: const TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  buildInfoCard(
                    onTap: () {
                      final promptController = Get.find<PromptController>();

                      if (widget.isEdit) {
                        promptController.editPrompt(
                            id: widget.id, prompt: promtTextController.text);
                      } else {
                        promptController.addPrompt(
                            prompt: promtTextController.text);
                      }
                    },
                    MediaQuery.of(context).size,
                    widget.isEdit ? "UPDATE" : "CREATE",
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Header(
                isBack: true,
                screenName: widget.isEdit ? "EDIT PROMPT" : "ADD PROMPT",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
