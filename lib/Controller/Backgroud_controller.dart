import 'package:get/get.dart';

import '../Model/background_model.dart';
import '../Service/Api_Service.dart';

class BackgroudController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<BackgroundModel?> backgroundModel = Rx(null);

  String defaultIMage = "assets/default_image.jpg";

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future<void> fetchBackground(int userID) async {
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.background(userId: userID);
      if (resp['status'] == "ok") {
        BackgroundModel backgrounddata = BackgroundModel.fromJson(resp);
        backgroundModel.value = backgrounddata;
        print('backgrouodimageis ${backgroundModel.value?.backgroundImage}');
        isLoaded.value = true;
      }
    } catch (e) {
      isLoaded.value = false;
      print("---------list error----------- $e");

      print(e);
    } finally {
      resetStatus();
    }
  }
}
