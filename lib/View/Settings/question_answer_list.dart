import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ihub/Controller/Backgroud_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Controller/prompt_controller.dart';
import 'package:ihub/Service/add_prompt_service.dart';
import 'package:ihub/View/Settings/add_question_answer.dart';
import 'package:ihub/Utils/header.dart';

class QuestionAnswerListScreen extends StatefulWidget {
  final String promptId;

  const QuestionAnswerListScreen({super.key, required this.promptId});

  @override
  State<QuestionAnswerListScreen> createState() =>
      _QuestionAnswerListScreenState();
}

class _QuestionAnswerListScreenState extends State<QuestionAnswerListScreen> {
  final PromptController controller = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchQAs(widget.promptId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => QuestionAnswerScreen(
                qid: '',
                question: "",
                answer: "",
                isEdit: false,
                promptid: widget.promptId,
              ));
        },
        label: const Text(
          "Add Q&A",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.green.shade700,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        splashColor: Colors.greenAccent.withOpacity(0.3),
        extendedPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 110, 16, 20),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final qaList = controller.qaModel?.data ?? [];
              if (qaList.isEmpty) {
                return GetX<BatteryController>(builder: (batteryController) {
                  return Center(
                    child: Text(
                      "No Q&A found",
                      style: TextStyle(
                        fontSize: 16,
                        color: batteryController.foregroundColor.value,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                });
              }

              return ListView.separated(
                padding:
                    const EdgeInsets.only(bottom: 100, left: 100, right: 100),
                itemCount: qaList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final qa = qaList[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Q${index + 1}: ${qa.question}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "A: ${qa.answer}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Colors.blueAccent.withOpacity(0.2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                  onPressed: () {
                                    Get.to(() => QuestionAnswerScreen(
                                          qid: qa.id.toString(),
                                          question: qa.question ?? "",
                                          answer: qa.answer ?? "",
                                          isEdit: true,
                                          promptid: widget.promptId,
                                        ));
                                  },
                                  child: const Text(
                                    "Edit",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Colors.redAccent.withOpacity(0.2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                  onPressed: () async {
                                    final response =
                                        await PromptService.deleteQA(
                                      qa.id.toString(),
                                    );
                                    if (response?['status'] == 'ok') {
                                      controller.fetchQAs(widget.promptId);
                                    } else {
                                      Get.snackbar(
                                        "Failed",
                                        response?['message'] ??
                                            "Something went wrong",
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    }
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Column(
            children: [
              const Header(
                isBack: true,
                screenName: "QUESTION & ANSWER",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
