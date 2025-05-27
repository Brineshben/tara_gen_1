import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/Login_api_controller.dart';
import 'package:ihub/Model/login_model.dart';
import 'package:ihub/Service/sharedPreference.dart';
import 'package:ihub/View/Login_Page/login.dart';
import 'package:ihub/View/Robot_Response/homepage.dart';
import 'package:lottie/lottie.dart';

import '../../Service/Api_Service.dart';

class LoadingSplash extends StatefulWidget {
  const LoadingSplash({super.key});

  @override
  State<LoadingSplash> createState() => _LoadingSplashState();
}

class _LoadingSplashState extends State<LoadingSplash> {
  Timer? messageTimer;

  @override
  void initState() {
    messageTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      _startAppLogic();
    });
    super.initState();
  }

  Future<void> _startAppLogic() async {
    Map<String, dynamic> resp = await ApiServices.loading();
    LoginModel? loginApi = await SharedPrefs().getLoginData();

    if (resp['status'] == "ON") {
      if (loginApi != null) {
        await Get.find<UserAuthController>().getUserLoginSaved(loginApi);
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Homepage()),
          (route) => false,
        );
      } else {
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width * 0.3,
              height: size.width * 0.3,
              child: Image.asset(
                'assets/splash.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Lottie.asset("assets/loading.json", width: 100),
          ],
        ),
      ),
    );
  }
}
