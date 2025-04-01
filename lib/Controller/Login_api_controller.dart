import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Model/login_model.dart';
import '../Service/Api_Service.dart';
import '../Service/sharedPreference.dart';
import '../Utils/popups.dart';

class UserAuthController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  Rx<LoginModel?> loginData = Rx(null);
  Rx<User?> userdata = Rx(null);



  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future<void> fetchUserData(
      {required String username, required String password}) async {
    isLoading.value = true;
    isLoaded.value = false;
    // try {
      Map<String, dynamic> resp =
          await ApiServices.userLogin(userName: username, psw: password);
    print("------resp------$resp");
      if (resp['status'] == "ok") {
        LoginModel loginApi = LoginModel.fromJson(resp);
        loginData.value = loginApi;
        await SharedPrefs().setLoginData(loginApi);


        print("------loginApi------${loginData.value?.user?.id}");
        isLoaded.value = true;


        // ProductAppPopUps.submit(
        //   title: "Success",
        //   message: "${resp['message'] ?? 'Login successful.'}",
        //   actionName: "Close",
        //   iconData: Icons.error_outline,
        //   iconColor:Colors.grey,
        // );

      } else {
        ProductAppPopUps.submit(
          title: "Failed",
          message: resp['message'] ?? 'Something went wrong.',
          actionName: "Close",
          iconData: Icons.error_outline,
          iconColor:Colors.red,
        );
      }
    // } catch (e) {
    //   isLoaded.value = false;
    //   Get.snackbar(
    //     'Failed', // Title
    //     'Error in Api Issue Login', // Message
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.blueGrey,
    //     colorText: Colors.white,
    //     borderRadius: 10,
    //     margin: EdgeInsets.all(10),
    //     duration: Duration(seconds: 3), // Auto dismiss time
    //     icon: Icon(Icons.check_circle, color: Colors.white),
    //   );
    //
    // } finally {
    //   resetStatus();
    // }
  }

  Future<void> getUserLoginSaved(LoginModel loginApi) async {
    loginData.value = loginApi;
    isLoaded.value = true;
  }
}
