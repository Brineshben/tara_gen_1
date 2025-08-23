import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/prompt_controller.dart';
import 'package:ihub/Service/add_prompt_service.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/Utils/toast.dart';
import 'package:ihub/View/welcome/add_question_answer.dart';
import 'package:ihub/View/battery/controller/battery_config_controller.dart';
import 'package:shimmer/shimmer.dart';

class QuestionAnswerListScreen extends StatefulWidget {
  final String promptId;

  const QuestionAnswerListScreen({super.key, required this.promptId});

  @override
  State<QuestionAnswerListScreen> createState() =>
      _QuestionAnswerListScreenState();
}

class _QuestionAnswerListScreenState extends State<QuestionAnswerListScreen> {
  final PromptController controller = Get.find();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  String? editingQAId;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchQAs(widget.promptId);
    });
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  void _editQA(dynamic qa) {
    setState(() {
      isEditMode = true;
      editingQAId = qa.id.toString();
      questionController.text = qa.question ?? "";
      answerController.text = qa.answer ?? "";
    });
  }

  void _clearForm() {
    setState(() {
      isEditMode = false;
      editingQAId = null;
      questionController.clear();
      answerController.clear();
    });
  }

  void _showDeleteConfirmationDialog(dynamic qa) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Confirm Delete',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete this Q&A?\n\nQ: ${qa.question}',
          style: const TextStyle(fontSize: 16),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Close dialog first
              final response = await PromptService.deleteQA(
                qa.id.toString(),
              );
              if (response?['status'] == 'ok') {
                // Clear form if we're editing the deleted item
                if (editingQAId == qa.id.toString()) {
                  _clearForm();
                }
                controller.fetchQAs(widget.promptId);

                showTopRightToast(
                    context: context,
                    message: "Q&A deleted successfully",
                    color: Colors.green);
              } else {
                showTopRightToast(
                    context: context,
                    message: response?['message'] ?? "Something went wrong",
                    color: Colors.red);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _saveQA() async {
    if (questionController.text.trim().isEmpty ||
        answerController.text.trim().isEmpty) {
      showTopRightToast(
        context: context,
        message: "Please fill in both question and answer",
        color: Colors.orange,
      );
      return;
    }

    try {
      dynamic response;
      if (isEditMode && editingQAId != null) {
        // Update existing Q&A
        response = await PromptService.updateQA(
          answer: answerController.text.trim(),
          id: editingQAId!,
          question: questionController.text.trim(),
        );
      } else {
        // Add new Q&A
        response = await PromptService.createQA(
          answer: answerController.text.trim(),
          promptId: widget.promptId,
          question: questionController.text.trim(),
        );
      }

      if (response?['status'] == 'ok') {
        _clearForm();
        controller.fetchQAs(widget.promptId);

        showTopRightToast(
          context: context,
          message: isEditMode
              ? "Q&A updated successfully"
              : "Q&A added successfully",
          color: Colors.green,
        );
      } else {
        showTopRightToast(
          context: context,
          message: response?['message'] ?? "Something went wrong",
          color: Colors.red,
        );
      }
    } catch (e) {
      showTopRightToast(
        context: context,
        message: "An error occurred: $e",
        color: Colors.red,
      );
    }
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 110, 16, 20),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              }
              final qaList = controller.qaModel?.data ?? [];
              if (qaList.isEmpty) {
                return Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionAnswerScreen(
                              qid: '',
                              question: "",
                              answer: "",
                              isEdit: false,
                              promptid: widget.promptId,
                            ),
                          ));
                    },
                    child: ChildGlasmorphism(
                      borderRadius: 10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          'Add Q&A',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    Expanded(
                      child: GlassmorphismModal(
                        question: questionController,
                        answer: answerController,
                        isEditMode: isEditMode,
                        onSave: _saveQA,
                        onCancel: _clearForm,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ListView.separated(
                        itemCount: qaList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final qa = qaList[index];
                          final isCurrentlyEditing =
                              editingQAId == qa.id.toString();

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: BaseGlassmorphism(
                                padding: EdgeInsetsGeometry.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Q${index + 1}: ${qa.question}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "A: ${qa.answer}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                Colors.white.withOpacity(0.2),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                          ),
                                          onPressed: () {
                                            if (isCurrentlyEditing) {
                                              _clearForm();
                                            } else {
                                              _editQA(qa);
                                            }
                                          },
                                          child: Text(
                                            isCurrentlyEditing
                                                ? "Cancel"
                                                : "Edit",
                                            style: TextStyle(
                                                color: isCurrentlyEditing
                                                    ? Colors.orange
                                                    : Colors.blueAccent,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                Colors.white.withOpacity(0.2),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                          ),
                                          onPressed: () {
                                            _showDeleteConfirmationDialog(qa);
                                          },
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(
                                                color: Colors.red,
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
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 30),
            child: Row(
              children: [
               ChildGlasmorphism(
                  borderRadius: 10,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => Navigator.of(context).pop(),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "QUESTION & ANSWER",
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
}

class GlassmorphismModal extends StatelessWidget {
  final TextEditingController question;
  final TextEditingController answer;
  final bool isEditMode;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const GlassmorphismModal({
    super.key,
    required this.question,
    required this.answer,
    required this.isEditMode,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<BatteryConfigController>(
      builder: (provider) {
        return ChildGlasmorphism(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: SingleChildScrollView(
                    child: Center(
                      child: provider.isLoadingForFetch.value
                          ? Column(
                              children: List.generate(5, (_) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey.shade800,
                                    highlightColor: Colors.grey.shade600,
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade800,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Container(
                                        height: 15,
                                        width: 100,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    isEditMode ? 'Edit Q&A' : 'Add Q&A',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  'Question',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF3A4A4A).withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: question,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Enter question',
                                      hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.4),
                                        fontSize: 10,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Answer',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF3A4A4A).withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: answer,
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Enter answer',
                                      hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.4),
                                        fontSize: 10,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                Row(
                                  spacing: 10,
                                  children: [
                                    if (isEditMode)
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: onCancel,
                                          child: ChildGlasmorphism(
                                            borderRadius: 30,
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: onSave,
                                        child: ChildGlasmorphism(
                                          borderRadius: 30,
                                          child: SizedBox(
                                            height: 40,
                                            child: Center(
                                              child: provider
                                                      .isLoadingForUpdate.value
                                                  ? SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Text(
                                                      isEditMode
                                                          ? 'Update Q&A'
                                                          : 'Add Q&A',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
