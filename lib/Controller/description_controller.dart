import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Model/description_model.dart';
import 'package:ihub/Service/add_description_service.dart';

class DescriptionController extends GetxController {
  var descriptionModel = Rxn<DescriptionModel>();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  fetchDescription() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('iiiiiiiiiiiiiiiincrontrooler');

      descriptionModel.value = await DescriptionService.fetchDescription();
    } catch (e) {
      errorMessage.value = 'Failed to fetch data';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitDescription({
    required String description,
    required String time,
  }) async {
    if (time.isEmpty || description.isEmpty) {
      Get.snackbar(
        margin: EdgeInsets.all(20),
        "Error",
        "Please fill all fields",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    Map<String, dynamic>? response = await DescriptionService.submitDescription(
      timeOfDay: time,
      description: description,
    );

    if (response != null) {
      if (response['status'] == 'ok') {
        await fetchDescription();
        Get.back();
        // Get.snackbar(
        //   margin: EdgeInsets.all(20),
        //   "Success",
        //   response['message'] ?? "Description submitted successfully",
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.TOP,
        // );
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
  Future<void> editDescription({
    required String description,
    required String time,
    required String id,
  }) async {
    if (time.isEmpty || description.isEmpty) {
      Get.snackbar(
        margin: EdgeInsets.all(20),
        "Error",
        "Please fill all fields",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    Map<String, dynamic>? response = await DescriptionService.editDescription(
      timeOfDay: time,
      description: description,
      id: id,
    );

    if (response != null) {
      if (response['status'] == 'ok') {
        await fetchDescription();
        Get.back();
        // Get.snackbar(
        //   margin: EdgeInsets.all(20),
        //   "Success",
        //   response['message'] ?? "Description edited successfully",
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.TOP,
        // );
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
