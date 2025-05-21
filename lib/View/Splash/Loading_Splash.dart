import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ihub/View/Login_Page/login.dart';
import 'package:ihub/View/Splash/video_splash.dart';
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
      Map<String, dynamic> resp = await ApiServices.loading();
      if (resp['status'] == "ON") {
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            timer.cancel();
            // return LoginPage();
            return SplashVideoScreen();
          },
        ));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
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
              Lottie.asset("assets/loading.json", width: 80),
            ],
          ),
        ),
      ),
    );
  }
}
