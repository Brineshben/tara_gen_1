import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/View/Login_Page/login.dart';
import 'package:lottie/lottie.dart';

import '../../Service/Api_Service.dart';
import '../Robot_Response/robot_response.dart';

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
      try {
        Map<String, dynamic> resp =
        await ApiServices.loading();
        print("POWERPOWERPOWER$resp");
        if (resp['status'] == "ON") {
          FocusManager.instance.primaryFocus?.unfocus();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            timer.cancel();
            return LoginPage();
          },));
        } else {

        }
      } catch (e){


      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [

          Column(
            children: [


              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                  child: SizedBox(
                    width: size.width * 0.4,
                    height: size.width * 0.4,
                  child: Image.asset(
                        'assets/splash.jpg',
                        fit: BoxFit.cover,
                      ),),
                ),
              ),
SizedBox(height: 50,),
              SizedBox(
                height: 50.h,
                width: 280.w,
                child: DefaultTextStyle(
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 30.h,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black
                              .withOpacity(0.7),
                          offset: Offset(2, 2),
                        ),
                      ]),
                  child: Center(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'LOADING....',
                          speed: Duration(
                              milliseconds: 50),
                          // Adjust typing speed
                          cursor:
                          '|', // Optional cursor
                        ),
                      ],
                      repeatForever: true,
                      // Ensures continuous looping
                      isRepeatingAnimation: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// Center(
// child: Lottie.asset(
// "assets/loading.json",
// fit: BoxFit.fitHeight,
// ),
// ),