import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/View/Robot_Response/homepage.dart';

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

  Future<void> login({
    required String username,
    required String password,
    required BuildContext context,
  }) async {
    isLoading.value = true;
    try {
      Map<String, dynamic> resp =
          await ApiServices.userLogin(userName: username, psw: password);
      print("------resp------$resp");
      if (resp['status'] == "ok") {
        LoginModel loginApi = LoginModel.fromJson(resp);
        loginData.value = loginApi;
        await SharedPrefs().setLoginData(loginApi);

        print("------loginApi------${loginData.value?.user?.id}");
        isLoading.value = false;

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) => Homepage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      } else {
        ProductAppPopUps.submit(
          title: "Failed",
          message: resp['message'] ?? 'Something went wrong.',
          actionName: "Try again",
          iconData: Icons.error_outline,
          iconColor: Colors.red,
        );
        isLoading.value = false;
      }
    } catch (e) {
      Get.snackbar(
        'Failed', // Title
        'Error in Api Issue Login', // Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3), // Auto dismiss time
        icon: Icon(Icons.check_circle, color: Colors.white),
      );
    } finally {
      resetStatus();
    }
  }

  Future<void> getUserLoginSaved(LoginModel loginApi) async {
    loginData.value = loginApi;
  }
}
