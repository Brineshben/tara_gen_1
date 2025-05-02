import 'package:get/get.dart';

import '../Model/batteryModel.dart';
import '../Service/Api_Service.dart';

class BatteryController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<BatteryModel?> background = Rx(null);
  bool popupshow = false;
  bool popupshow2 = false;
  var roboId;
  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future<void> fetchBattery(int userID) async {
    isLoading.value = true;
    isLoaded.value = false;

    try {
      Map<String, dynamic> resp = await ApiServices.battery(userId: userID);

      print(resp);
      if (resp['status'] == 'ok') {
        print("--------Responsessssss: $resp-------");
        BatteryModel batteryData = BatteryModel.fromJson(resp);
        print("background.value: ${batteryData}");
        print("background.id: ${batteryData.data?.first.robot?.roboId}");

        background.value = batteryData;

        roboId = batteryData.data?.first.robot?.roboId;

        print('robot id ${roboId}');
      }
    } catch (e) {
      isLoaded.value = false;
      print("bennn");
      // Get.snackbar(
      //   'Failed', // Title
      //   'Error in Robot Response Battery Details',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.blueGrey,
      //   colorText: Colors.white,
      //   borderRadius: 10,
      //   margin: EdgeInsets.all(10),
      //   duration: Duration(seconds: 3), // Auto dismiss time
      //   icon: Icon(Icons.check_circle, color: Colors.white),
      // );

      print("Error fetching battery data: $e");
    } finally {
      resetStatus();
    }
  }

  Future<bool?> fetchCharging(int userID) async {
    isLoading.value = true;
    isLoaded.value = false;

    try {
      Map<String, dynamic> resp = await ApiServices.battery(userId: userID);

      if (resp['status'] == "ok") {
        print("--------Responsessssss: $resp-------");
        BatteryModel batteryData = BatteryModel.fromJson(resp);
        background.value = batteryData;
        print("background.value: ${batteryData}");

        bool? charge = background.value?.data?.first.robot?.charging;

        print("BATTERT-IS-CHARGING $charge");
        if (charge == true) {
          return true;
        } else {
          return false;
        }

        isLoaded.value = true;
      }
    } catch (e) {
      isLoaded.value = false;
      print("bennn");
      // Get.snackbar(
      //   'Failed', // Title
      //   'Error in Robot Response Battery Details',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.blueGrey,
      //   colorText: Colors.white,
      //   borderRadius: 10,
      //   margin: EdgeInsets.all(10),
      //   duration: Duration(seconds: 3), // Auto dismiss time
      //   icon: Icon(Icons.check_circle, color: Colors.white),
      // );

      print("Error fetching battery data: $e");
    } finally {
      resetStatus();
    }
    return null;
  }
}
