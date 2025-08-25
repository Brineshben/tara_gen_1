import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/Login_api_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/toast.dart';

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
        batteryController.batteryModel.value?.data?[0].robot?.language ?? '';
    print('currently selected language ${selectedLanguage.value} ');
  }

  void setSelectedLanguage(String lang, BuildContext context) async {
    final batteryController = Get.find<BatteryController>();

    selectedLanguage.value = lang;

    try {
      final response = await ApiServices.setLanguage(
        language: lang,
        robotId: batteryController.roboId ?? "RB10",
      );

      if (response['status'] == 'ok') {
        showTopRightToast(
            message: response['message'] ?? "Language updated successfully",
            color: Colors.green,
            );

        Get.find<BatteryController>().fetchBattery(
            Get.find<UserAuthController>().loginData.value?.user?.id ?? 0,
            context);
      } else {
        showTopRightToast(
            message: response['message'] ?? "Something went wrong",
            color: Colors.green,
            );
      }
    } catch (e) {
      print('updatelan $e');

      showTopRightToast(
          message: "Something went wrong", color: Colors.red,);
    }
  }
}
