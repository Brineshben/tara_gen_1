import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/robot_Response_Model.dart';
import '../Service/Api_Service.dart';
import '../Utils/popups.dart';

class RobotresponseapiController extends GetxController {

  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<Data> responseData = Data().obs;


  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }



  Future<void> fetchObsResultList() async {

    isLoading.value = true;
    isLoaded.value = false;
    try {

      Map<String, dynamic> resp = await ApiServices.robotResponsee();
      if (resp['status']== "OK") {

        robotResponseModel observationResultApiModel = robotResponseModel.fromJson(resp);
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