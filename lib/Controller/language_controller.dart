import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Service/Api_Service.dart';

class LanguageController extends GetxController {
  final RxList<String> languages = <String>[].obs; // List of languages
  var selectedLanguage = ''.obs; // Selected language
  var isLoading = false.obs; // Loading indicator

  void fetchLanguages() async {
    try {
      isLoading.value = true;
      final data = await ApiServices.fetchLanguages();

      languages.value =
          List<String>.from(data['data'].map((item) => item['language']));
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  setLanguage() async {
    final batteryController = Get.find<BatteryController>();
    selectedLanguage.value =
        batteryController.background.value?.data?[0].robot?.language ?? '';
  }

  final batteryController = Get.find<BatteryController>();

  void setSelectedLanguage(String lang) async {
    selectedLanguage.value = lang;
    String id = batteryController.roboId.value;

    try {
      final response = await ApiServices.setLanguage(
        id: id,
        language: lang,
        robotId: batteryController.roboId.value,
      );

      // ✅ Show success message from API
      if (response['status'] == 'ok') {
        Get.snackbar(
          "Success",
          response['message'] ?? "Language updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // ❌ Show server error message
        Get.snackbar(
          "Failed",
          response['message'] ?? "Something went wrong",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      // ❌ Show exception error
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
