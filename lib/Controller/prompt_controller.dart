import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Model/qa_model.dart';
import 'package:ihub/Service/add_prompt_service.dart';

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

  Future<void> addPrompt({
    required String prompt,
  }) async {
    if (prompt.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter Prompt",
        margin: EdgeInsets.all(20),
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
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
      Get.back();
      Get.snackbar(
        margin: EdgeInsets.all(20),
        "Success",
        response?['message'] ?? "Prompt submitted successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.snackbar(
        margin: EdgeInsets.all(20),
        "Failed",
        snackPosition: SnackPosition.TOP,
        response?['message'] ?? "Something went wrong",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // edit prompt
  Future<void> editPrompt({
    required String prompt,
    required String id,
  }) async {
    if (prompt.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter Prompt",
        margin: EdgeInsets.all(20),
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
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
      await fetchPrompt();
      Get.back();
      Get.snackbar(
        margin: EdgeInsets.all(20),
        "Success",
        response?['message'] ?? "Prompt submitted successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.snackbar(
        margin: EdgeInsets.all(20),
        "Failed",
        snackPosition: SnackPosition.TOP,
        response?['message'] ?? "Something went wrong",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
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
