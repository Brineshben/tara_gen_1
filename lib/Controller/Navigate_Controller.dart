import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/toast.dart';

import '../Model/Navigate_model.dart';

class NavigateController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<NavigationListModel?> Navifateedata = Rx(null);

  RxList<NavigationData?> dataList = RxList();

  Future<void> navigateData(BuildContext context) async {
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.navigateoffline();
      if (resp['status'] == 'ok') {
        Navifateedata.value = NavigationListModel.fromJson(resp);
        print(" Navifateedata.value${Navifateedata.value?.data}");
        dataList.value = Navifateedata.value?.data ?? [];
        isLoading.value = true;
      } else {
        isError.value = true;
      }
    } catch (e) {
      isLoaded.value = false;
      showTopRightToast( message: "", color: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
