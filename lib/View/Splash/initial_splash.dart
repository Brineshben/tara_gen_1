import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/Login_api_controller.dart';
import 'package:ihub/Model/login_model.dart';
import 'package:ihub/Service/sharedPreference.dart';
import 'package:ihub/View/Login_Page/login.dart';
import 'package:ihub/View/Robot_Response/homepage.dart';
import 'package:lottie/lottie.dart';

class InitialSplashScreen extends StatefulWidget {
  const InitialSplashScreen({super.key});

  @override
  State<InitialSplashScreen> createState() => _InitialSplashScreenState();
}

class _InitialSplashScreenState extends State<InitialSplashScreen> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // fetchData() async {
  //   LoginModel? loginApi = await SharedPrefs().getLoginData();
  //   await Future.delayed(Duration(seconds: 3));

  //   if (loginApi != null) {
  //     await Get.find<UserAuthController>().getUserLoginSaved(loginApi);
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => Homepage()),
  //       (route) => false,
  //     );
  //   } else {
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => const LoginPage()),
  //       (route) => false,
  //     );
  //   }
  // }

  fetchData() async {
    try {
      LoginModel? loginApi = await SharedPrefs().getLoginData();
      await Future.delayed(Duration(seconds: 3));

      if (loginApi != null && loginApi.user?.id != null) {
        await Get.find<UserAuthController>().getUserLoginSaved(loginApi);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Homepage()),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      print("Splash error: $e");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
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
                'assets/taraLogo.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'T          A          R          A',
              style: GoogleFonts.robotoCondensed(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Lottie.asset("assets/loading.json", width: 100),
          ],
        ),
      ),
    );
  }
}
