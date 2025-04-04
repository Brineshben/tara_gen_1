import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Service/Api_Service.dart';

import '../Model/Navigate_model.dart';
import '../Utils/popups.dart';

class NavigateDescriptionController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<NavigationListModel?> Navifateedata = Rx(null);
  List<TextEditingController> textControllers = [];

  RxList<NavigationData?> DataList = RxList();

  Future<void> NavigateData() async {
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.navigateoffline();

      if (resp['status'] == 'ok') {
        Navifateedata.value = NavigationListModel.fromJson(resp);

        if (Navifateedata.value != null) {
          DataList.assignAll(Navifateedata.value!.data ?? []);

          // Initialize TextEditingControllers with the existing description from API
          textControllers = List.generate(DataList.length, (index) =>
              TextEditingController(text: DataList[index]?.description ?? "No Data Found"));

          isLoaded.value = true;
          update(); // Notify UI to update
        }
      } else {
        isError.value = true;
      }
    }catch (e) {
      isLoaded.value = false;

      Get.snackbar(
        'Failed', // Title
        'Error in Robot Response Navigation Control', // Message
        snackPosition: SnackPosition.BOTTOM, // Position (TOP or BOTTOM)
        backgroundColor: Colors.blueGrey,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),

        duration: Duration(seconds: 3), // Auto dismiss time
        icon: Icon(Icons.check_circle, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
