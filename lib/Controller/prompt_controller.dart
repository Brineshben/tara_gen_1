import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Model/system_prompt_model.dart';
import 'package:ihub/Service/add_prompt_service.dart';

class PromptController extends GetxController {
  var promptModel = Rxn<SystemPromptModel>();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  fetchPrompt() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('iiiiiiiiiiiiiiiincrontrooler');

      promptModel.value = await PromptService.fetchPrompt();
    } catch (e) {
      errorMessage.value = 'Failed to fetch data';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPrompt({
    required String prompt,
    required String q,
    required String ans,
  }) async {
    if (prompt.isEmpty && (q.isEmpty || ans.isEmpty)) {
      if (prompt.isEmpty && q.isEmpty && ans.isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter Prompt or both Question and Answer",
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else if (prompt.isEmpty && q.isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter a question",
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else if (prompt.isEmpty && ans.isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter an answer",
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Please enter both Question and Answer",
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
      return;
    }

    isLoading.value = true;

    final response = await PromptService.addPrompt(
      answer: ans,
      prompt: prompt,
      question: q,
    );

    isLoading.value = false;

    print('Controller Response: $response');

    if (response != null) {
      if (response['status'] == 'ok') {
        await fetchPrompt();
        Get.back();
        Get.snackbar(
          margin: EdgeInsets.all(20),
          "Success",
          response['message'] ?? "Prompt submitted successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          margin: EdgeInsets.all(20),
          "Failed",
          snackPosition: SnackPosition.TOP,
          response['message'] ?? "Something went wrong",
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }

  // edit
  Future<void> editPrompt({
    required String prompt,
    required String id,
    required String q,
    required String ans,
  }) async {
    if (prompt.isEmpty && (q.isEmpty || ans.isEmpty)) {
      if (prompt.isEmpty && q.isEmpty && ans.isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter Prompt or both Question and Answer",
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else if (prompt.isEmpty && q.isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter a question",
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else if (prompt.isEmpty && ans.isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter an answer",
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Please enter both Question and Answer",
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
      return;
    }

    isLoading.value = true;

    final response = await PromptService.editPrompt(
      prompt: prompt,
      id: id,
      answer: ans,
      question: q,
    );

    isLoading.value = false;

    print('Controller Response: $response');

    if (response != null) {
      if (response['status'] == 'ok') {
        await fetchPrompt();
        Get.back();
        Get.snackbar(
          margin: EdgeInsets.all(20),
          "Success",
          response['message'] ?? "Prompt submitted successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          margin: EdgeInsets.all(20),
          "Failed",
          snackPosition: SnackPosition.TOP,
          response['message'] ?? "Something went wrong",
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }
}
