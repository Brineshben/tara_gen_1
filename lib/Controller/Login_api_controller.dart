import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Utils/toast.dart';
import 'package:ihub/View/welcome/welcome_screen.dart';

import '../Model/login_model.dart';
import '../Service/Api_Service.dart';
import '../Service/sharedPreference.dart';

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
      if (resp['status'] == "ok") {
        LoginModel loginApi = LoginModel.fromJson(resp);
        loginData.value = loginApi;
        await SharedPrefs().setLoginData(loginApi);

        isLoading.value = false;

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) =>
                WelcomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      } else {
        showTopRightToast(
            color: Colors.red,
            message: resp['message'] ?? 'Something went wrong.',
            context: context);
        isLoading.value = false;
      }
    } on SocketException {
      showTopRightToast(
        color: Colors.red,
        message: "No Internet Connection",
        context: context,
      );
    } catch (e) {
      showTopRightToast(
          color: Colors.red, message: "Error in IP Address", context: context);
    } finally {
      resetStatus();
    }
  }

  Future<void> getUserLoginSaved(LoginModel loginApi) async {
    loginData.value = loginApi;
  }
}
