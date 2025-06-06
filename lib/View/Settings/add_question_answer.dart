import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Controller/prompt_controller.dart';
import 'package:ihub/Utils/header.dart';

class QuestionAnswerScreen extends StatefulWidget {
  final String qid;
  final String promptid;
  final String question;
  final String answer;
  final bool isEdit;

  const QuestionAnswerScreen({
    super.key,
    required this.question,
    required this.answer,
    required this.isEdit,
    required this.qid,
    required this.promptid,
  });

  @override
  State<QuestionAnswerScreen> createState() => _QuestionAnswerScreenState();
}

class _QuestionAnswerScreenState extends State<QuestionAnswerScreen> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final promptController = Get.find<PromptController>();

  @override
  void initState() {
    super.initState();
    questionController.text = widget.question;
    answerController.text = widget.answer;
  }

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

          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 130),
            child: Column(
              children: [
                _buildTextField(
                  controller: questionController,
                  label: "Enter question",
                  maxLines: 2,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: answerController,
                  label: "Enter answer",
                  maxLines: 4,
                  maxLength: 200,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final question = questionController.text.trim();
                        final answer = answerController.text.trim();

                        if (widget.isEdit) {
                          await promptController.updateQA(
                            qaId: widget.qid,
                            question: question,
                            answer: answer,
                            promptId: widget.promptid,
                          );
                        } else {
                          await promptController.createQA(
                            promptId: widget.promptid,
                            question: question,
                            answer: answer,
                          );
                        }

                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.save),
                      label: const Text("Submit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          // Header
          Column(
            children: [
              Header(
                isBack: true,
                screenName: widget.isEdit ? "EDIT Q&A" : "ADD Q&A",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    int? maxLength,
  }) {
    return GetX<BatteryController>(builder: (batteryController) {
      return TextFormField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        style: TextStyle(color: batteryController.foregroundColor.value),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: batteryController.foregroundColor.value),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.greenAccent),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
    });
  }
}
