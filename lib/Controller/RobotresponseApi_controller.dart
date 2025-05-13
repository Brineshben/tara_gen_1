import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/robot_Response_Model.dart';
import '../Service/Api_Service.dart';

class RobotresponseapiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<Data> responseData = Data().obs;
  Rx<RobotResponseModel?> robotResponseModel = Rx(null);

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  RxString link = ''.obs;
  RxString name = ''.obs;

  getUrl() async {
    // Map<String, dynamic> responce = await UrlService.getUrls();
    // if (responce['status'] == "ok") {
    //   link.value = responce["data"]['url'];
    //   name.value = responce["data"]['name'];
    // }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    link.value = prefs.getString('url') ?? '';
    name.value = prefs.getString('name') ?? '';

    print('link ${link.value}');
    print('name ${name.value}');
  }

  Future<void> fetchObsResultList() async {
    isLoading.value = true;
    isLoaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.robotResponsee();
      if (resp['status'] == "OK") {
        RobotResponseModel observationResultApiModel =
            RobotResponseModel.fromJson(resp);

        robotResponseModel.value = observationResultApiModel;
        responseData.value = observationResultApiModel.data!;
        isLoaded.value = true;
      }
    } catch (e) {
      print("gxsgdsydg$e");
      // isLoaded.value = false;
      // Get.snackbar(
      //   'Failed', // Title
      //   'Issue in  Robot Response navigation', // Message
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.blueGrey,
      //   colorText: Colors.white,
      //   borderRadius: 10,
      //   margin: EdgeInsets.all(10),
      //   duration: Duration(seconds: 3), // Auto dismiss time
      //   icon: Icon(Icons.check_circle, color: Colors.white),
      // );

      print("---------list error-----------");
    } finally {
      resetStatus();
    }
  }
}
