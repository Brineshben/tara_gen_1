import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/Login_api_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Utils/toast.dart';
import 'package:ihub/View/language/service/language_service.dart';

class LanguageController extends GetxController {
  /// Observables
  var languages = <String>[].obs;
  var selectedLanguage = "".obs;
  var isLoading = false.obs;

  /// Fetch all available languages from the API
  Future<void> fetchLanguages() async {
    isLoading.value = true;

    try {
      final data = await LanguageService.fetchLanguages();
      languages.value = List<String>.from(
        data['data'].map((item) => item['language']),
      );
    } catch (e) {
      debugPrint('Language Fetch Error: $e');
    }

    isLoading.value = false;
  }

  /// Set default/initial language
  void setInitialLanguage(String? defaultLang) {
    selectedLanguage.value = defaultLang ?? '';
    debugPrint('Currently selected language: ${selectedLanguage.value}');
  }

  /// Update selected language and sync with backend
  Future<void> updateLanguage({
    required String lang,
    required BuildContext context,
    required BatteryController batteryController,
    required String userId,
  }) async {
    selectedLanguage.value = lang;

    try {
      final response = await LanguageService.setLanguage(
        language: lang,
        robotId: batteryController.roboId,
      );

      showTopRightToast(
        
        message: "Language updated successfully",
        color: Colors.green,
      );

      if (response['status'] == 'ok') {
        await batteryController.fetchBattery(
            Get.find<UserAuthController>().loginData.value?.user?.id ?? 0,
            context);
      }
    } catch (e) {
      debugPrint('Update language error: $e');
      showTopRightToast(
        
        message: "$e",
        color: Colors.red,
      );
    }
  }
}
