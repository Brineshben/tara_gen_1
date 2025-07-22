import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  Future<void> fetchvolume(String RobotId, int volume) async {
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.volume(
        roboid: RobotId,
        volume: volume,
      );
      print("------respvolumecontrol------$resp");
      if (resp['current_volume'] != null) {
        roboVolume.value =
            resp['current_volume'] > 100 ? 100 : resp['current_volume'];
        isLoaded.value = true;
      }
    } catch (e) {
      isLoaded.value = false;
      Get.snackbar(
        'Failed', // Title
        'Error in Robot Response Volume Control', // Message
        snackPosition: SnackPosition.BOTTOM, // Position (TOP or BOTTOM)
        backgroundColor: Colors.blueGrey,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3), // Auto dismiss time
        icon: Icon(Icons.check_circle, color: Colors.white),
      );
      // ProductAppPopUps.submit(
      //   title: "Failed",
      //   message: "Issue in Volume Control1",
      //   actionName: "Close",
      //   iconData: Icons.error_outline,
      //   iconColor: Colors.grey,
      // );
      print("--------session id not generated---------");
    } finally {
      print("--------session id not generated---------");
      // resetStatus();
    }
  }

  Future<void> fetchinitialvolume(String RobotId) async {
    isLoading.value = true;
    isLoaded.value = false;

    try {
      Map<String, dynamic> resp =
          await ApiServices.volumeinitial(roboid: RobotId);
      print("------resp------$resp");
      if (resp['current_volume'] != null) {
        roboVolume.value =
            resp['current_volume'] > 100 ? 100 : resp['current_volume'];
        isLoaded.value = true;
      }
    } catch (e) {
      isLoaded.value = false;
      Get.snackbar(
        'Failed', // Title
        'Error in Robot Response Volume Control',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueGrey,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3), // Auto dismiss time
        icon: Icon(Icons.check_circle, color: Colors.white),
      );

      print("--------session id not generated---------");
    } finally {
      print("--------session id not generated---------");
      // resetStatus();
    }
  }
}
