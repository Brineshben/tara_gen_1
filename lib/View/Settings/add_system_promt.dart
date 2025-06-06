import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Controller/prompt_controller.dart';
import 'package:ihub/Utils/header.dart';

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
      body: SingleChildScrollView(
        child: Stack(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120),
              child: Column(
                children: [
                  const SizedBox(height: 120),
                  TextFormField(
                    maxLength: 300,
                    controller: promtTextController,
                    maxLines: 6,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Enter prompt",
                      labelStyle: const TextStyle(color: Colors.blue),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        final promptController = Get.find<PromptController>();

                        if (widget.isEdit) {
                          promptController.editPrompt(
                              id: widget.id, prompt: promtTextController.text);
                        } else {
                          promptController.addPrompt(
                              prompt: promtTextController.text);
                        }
                      },
                      child: widget.isEdit ? Text("UPDATE") : Text("CREATE"),
                    ),
                  )
                ],
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
      ),
    );
  }
}
