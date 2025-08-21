import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Controller/prompt_controller.dart';
import 'package:ihub/Utils/glassmorphism.dart';

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
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF608878).withOpacity(0.2), // light green
                  Color(0xFF18221E).withOpacity(0.2), // dark green
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.transparent),
            ),
          ),
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
                    InkWell(
                        onTap: () async {
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
                        child: ChildGlasmorphism(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            widget.isEdit ? "UPDATE QA" : "CREATE QA",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        )))
                  ],
                )
              ],
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 30),
            child: Row(
              children: [
                ChildGlasmorphism(
                    borderRadius: 40,
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ))),
                const SizedBox(width: 10),
                Text(
                  widget.isEdit ? "EDIT Q&A" : "ADD Q&A",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
