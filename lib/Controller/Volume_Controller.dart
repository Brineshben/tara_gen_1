import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Utils/toast.dart';

import '../Model/volume_Model.dart';
import '../Service/Api_Service.dart';

class VolumeController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  RxInt roboVolume = RxInt(0);
  Rx<volume_model?> updatedatass = Rx(null);

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future<void> fetchvolume(
      String roboId, int volume, BuildContext context) async {
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.volume(
        roboid: roboId,
        volume: volume,
      );

      print('volume_response ${resp}');
      if (resp['current_volume'] != null) {
        roboVolume.value =
            resp['current_volume'] > 100 ? 100 : resp['current_volume'];
        isLoaded.value = true;
      }
    } catch (e) {
      isLoaded.value = false;

      showTopRightToast(
          context: context,
          message: "Error in Robot Response Volume Control",
          color: Colors.red);
    }
  }

  Future<void> fetchinitialvolume(String roboId, BuildContext context) async {
    isLoading.value = true;
    isLoaded.value = false;

    try {
      Map<String, dynamic> resp =
          await ApiServices.volumeinitial(roboid: roboId);
           print('volume_response ${resp}');

      if (resp['current_volume'] != null) {
        roboVolume.value =
            resp['current_volume'] > 100 ? 100 : resp['current_volume'];
        isLoaded.value = true;
      }
    } catch (e) {
      isLoaded.value = false;

      showTopRightToast(
          context: context,
          message: "Error in Robot Response Volume Control",
          color: Colors.red);
    }
  }
}
