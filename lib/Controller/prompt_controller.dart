import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Model/qa_model.dart';
import 'package:ihub/Service/add_prompt_service.dart';
import 'package:ihub/Utils/toast.dart';

class PromptController extends GetxController {
  var isLoading = false.obs;
  Map<String, dynamic>? promptresponce = {};
  QAmodel? qaModel;

  fetchPrompt() async {
    try {
      isLoading.value = true;
      promptresponce = await PromptService.fetchPrompt();
    } catch (e) {
      print('getpromt error $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPrompt(
      {required String prompt, required BuildContext context}) async {
    if (prompt.isEmpty) {
      showTopRightToast(
           message: "Please enter Prompt", color: Colors.red);
      return;
    }
    isLoading.value = true;
    Map<String, dynamic>? response = await PromptService.addPrompt(
      prompt: prompt,
    );
    isLoading.value = false;
    print('Controller Response: $response');

    if (response?['status'] == 'ok') {
      await fetchPrompt();

      showTopRightToast(
          
          message: response?['message'] ?? "Prompt submitted successfully",
          color: Colors.green);
    } else {
      showTopRightToast(
          
          message: response?['message'] ?? "Something went wrong",
          color: Colors.red);
    }
  }

  // edit prompt
  Future<void> editPrompt(
      {required String prompt,
      required String id,
      required BuildContext context}) async {
    if (prompt.isEmpty) {
      showTopRightToast(
           message: "Please enter Prompt", color: Colors.red);
      return;
    }
    isLoading.value = true;
    Map<String, dynamic>? response = await PromptService.editPrompt(
      prompt: prompt,
      id: id,
    );
    isLoading.value = false;
    print('Controller Response: $response');

    if (response?['status'] == 'ok') {
      showTopRightToast(
          
          message: response?['message'] ?? "Prompt submitted successfully",
          color: Colors.green);
    } else {
      showTopRightToast(
          
          message: response?['message'] ?? "Something went wrong",
          color: Colors.red);
    }
  }

  //QA
  Future<void> fetchQAs(String promptId) async {
    if (promptId.isEmpty) {
      print("❌ Empty promptId");
      return;
    }
    try {
      isLoading.value = true;
      qaModel = await PromptService.fetchQAList(promptId);
    } catch (e) {
      print("Error fetching QAs: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createQA({
    required String promptId,
    required String question,
    required String answer,
  }) async {
    try {
      isLoading.value = true;
      final response = await PromptService.createQA(
        promptId: promptId,
        question: question,
        answer: answer,
      );
      if (response?['status'] == 'ok') {
        // Get.snackbar("Success", response?['message'] ?? "QA Created",
        //     backgroundColor: Colors.green, colorText: Colors.white);
        await fetchQAs(promptId); // Refresh
      } else {
        Get.snackbar("Failed", response?['message'] ?? "Something went wrong",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("Error creating QA: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateQA({
    required String qaId,
    required String question,
    required String answer,
    required String promptId,
  }) async {
    try {
      isLoading.value = true;
      final response = await PromptService.updateQA(
        id: qaId,
        question: question,
        answer: answer,
      );
      if (response?['status'] == 'ok') {
        // Get.snackbar("Success", response?['message'] ?? "QA Updated",
        //     backgroundColor: Colors.green, colorText: Colors.white);
        await fetchQAs(promptId);
      } else {
        Get.snackbar("Failed", response?['message'] ?? "Update Failed",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("Error updating QA: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
