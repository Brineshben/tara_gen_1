import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/prompt_controller.dart';
import 'package:lottie/lottie.dart';

class AddSystemPrompt extends StatefulWidget {
  final String id;
  final String prompt;
  final bool isEdit;
  const AddSystemPrompt(
      {super.key,
      required this.id,
      required this.prompt,
      required this.isEdit});

  @override
  State<AddSystemPrompt> createState() => _AddSystemPromptState();
}

class _AddSystemPromptState extends State<AddSystemPrompt> {
  final TextEditingController textController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final promptController = Get.find<PromptController>();

  @override
  void initState() {
    super.initState();
    textController.text = widget.prompt;
  }

  @override
  void dispose() {
    textController.dispose();
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: Text(
          "BEHAVIOUR PROTOCOL",
          style: GoogleFonts.oxygen(
            color: Colors.white,
            fontSize: 25.h,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: SizedBox(
                width: size.width * 0.5,
                height: size.width * 0.5,
                child: Lottie.asset(
                  "assets/loginimage.json",
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  TextFormField(
                    maxLength: 300,
                    controller: textController,
                    maxLines: 6,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Enter prompt",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: questionController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Enter question",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: answerController,
                    maxLength: 200,
                    maxLines: 3,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Enter answer",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (widget.isEdit) {
                          await promptController.editPrompt(
                            id: widget.id,
                            prompt: textController.text,
                            q: questionController.text,
                            ans: answerController.text,
                          );
                        } else {
                          await promptController.addPrompt(
                            prompt: textController.text,
                            q: questionController.text,
                            ans: answerController.text,
                          );
                        }
                      },
                      icon: Icon(Icons.send),
                      label: Text("Submit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
