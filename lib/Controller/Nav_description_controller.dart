import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/toast.dart';
import '../Model/Navigate_model.dart';

class NavigateDescriptionController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;

  /// Loading flag for submit
  RxBool isSubmitting = false.obs;

  Rx<NavigationListModel?> navigationData = Rx(null);
  List<TextEditingController> descriptionControllers = [];

  RxList<bool> isExpandedList = <bool>[].obs;
  RxList<NavigationData?> dataList = RxList();

// get navigation
  Future<void> getNavigation(BuildContext context) async {
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.navigateoffline();

      if (resp['status'] == 'ok') {
        navigationData.value = NavigationListModel.fromJson(resp);

        if (navigationData.value != null) {
          dataList.assignAll(navigationData.value!.data ?? []);

          descriptionControllers = List.generate(
            dataList.length,
            (index) => TextEditingController(
              text: dataList[index]?.description ?? "",
            ),
          );

          isExpandedList.value = List.filled(dataList.length, false);

          isLoaded.value = true;
          update();
        }
      } else {
        isError.value = true;
      }
    } catch (e) {
      isLoaded.value = false;
      showTopRightToast(
          color: Colors.red,
          message: "something went wrong!");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAgain(BuildContext context) async {
    try {
      Map<String, dynamic> resp = await ApiServices.navigateoffline();

      if (resp['status'] == 'ok') {
        navigationData.value = NavigationListModel.fromJson(resp);

        if (navigationData.value != null) {
          dataList.assignAll(navigationData.value!.data ?? []);

          descriptionControllers = List.generate(
            dataList.length,
            (index) => TextEditingController(
              text: dataList[index]?.description ?? "",
            ),
          );

          isExpandedList.value = List.filled(dataList.length, false);
        }
      }
    } catch (e) {
      showTopRightToast(
          color: Colors.red,
          message: "something went wrong!");
    }
  }

// submit
  Future<void> submitNavigationUpdate(
      {required int userId,
      required String description,
      required BuildContext context}) async {
    if (description.isEmpty) {
      showTopRightToast(
          color: Colors.red,
          
          message: "Description cannot be empty");
      return;
    }

    isSubmitting.value = true;

    try {
      Map<String, dynamic> resp = await ApiServices.navigateDescriptionSubmit(
        userId: userId,
        description: description,
      );
      if (resp['status'] == 'ok') {
        showTopRightToast(
            color: Colors.green,
            message: "Navigation updated successfully");
        await fetchAgain(context);
      } else {
        showTopRightToast(
            color: Colors.red,
            message: resp['message'] ?? 'Unknown error');
      }
    } catch (e) {
      showTopRightToast(
        color: Colors.red,
        
        message: e.toString(),
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
