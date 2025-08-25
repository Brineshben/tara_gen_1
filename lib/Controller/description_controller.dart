import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Model/description_model.dart';
import 'package:ihub/Service/add_description_service.dart';
import 'package:ihub/Utils/toast.dart';

class DescriptionController extends GetxController {
  var descriptionModel = Rxn<DescriptionModel>();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var submiting = false.obs;

  fetchDescription() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      descriptionModel.value = await DescriptionService.fetchDescription();
    } catch (e) {
      errorMessage.value = 'Failed to fetch data';
    } finally {
      isLoading.value = false;
    }
  }

  fetchDescriptionAgain() async {
    descriptionModel.value = await DescriptionService.fetchDescription();
  }

  Future<void> submitDescription({
    required String description,
    required String time,
    required BuildContext context,
  }) async {
    if (time.isEmpty || description.isEmpty) {
      showTopRightToast(
          color: Colors.red,
          message: "fields can not be empty");
      return;
    }

    submiting.value = true;

    Map<String, dynamic>? response = await DescriptionService.submitDescription(
      timeOfDay: time,
      description: description,
    );

    if (response != null) {
      if (response['status'] == 'ok') {
        await fetchDescriptionAgain();

        showTopRightToast(
            color: Colors.green,
            message:
                response['message'] ?? "Description submitted successfully");
      } else {
        showTopRightToast(
          color: Colors.red,
          message: response['message'] ?? "Something went wrong",
        );
      }
      submiting.value = false;
    }
  }

  // edit
  Future<void> editDescription({
    required String description,
    required String time,
    required String id,
    required BuildContext context,
  }) async {
    if (time.isEmpty || description.isEmpty) {
     
      showTopRightToast(
        color: Colors.red,
        
        message:   "Please fill all fields"
      );
      return;
    }

    submiting.value = true;

    Map<String, dynamic>? response = await DescriptionService.editDescription(
      timeOfDay: time,
      description: description,
      id: id,
    );

    if (response != null) {
      if (response['status'] == 'ok') {
        await fetchDescriptionAgain();
        showTopRightToast(
          color: Colors.green,
          
          message: response['message'] ?? "Description edited successfully",
        );
      } else {
        showTopRightToast(
          color: Colors.red,
          
          message: response['message'] ?? "Something went wrong",
        );
      }
      submiting.value = false;
    }
  }
}
