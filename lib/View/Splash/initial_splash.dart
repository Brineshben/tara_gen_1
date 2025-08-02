import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ihub/Controller/Login_api_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Model/login_model.dart';
import 'package:ihub/Service/sharedPreference.dart';
import 'package:ihub/Utils/toast.dart';
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

  // Future<void> fetchData() async {
  //   try {
  //     // Step 1: Get saved login data from SharedPreferences
  //     LoginModel? loginApi = await SharedPrefs().getLoginData();

  //     // // Step 2: Wait for splash effect (optional delay)
  //     // await Future.delayed(const Duration(seconds: 3));

  //     // Step 3: Check if user data exists
  //     if (loginApi != null && loginApi.user?.id != null) {
  //       final userId = loginApi.user!.id!;

  //       // Save login data to controller
  //       await Get.find<UserAuthController>().getUserLoginSaved(loginApi);

  //       // Fetch battery info using user ID
  //       await Get.find<BatteryController>().fetchBattery(userId, context);

  //       // Navigate to Homepage and remove all previous routes
  //       Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => Homepage()),
  //         (route) => false,
  //       );
  //     } else {
  //       // If login data not found, go to LoginPage
  //       Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => const LoginPage()),
  //         (route) => false,
  //       );
  //     }
  //   } catch (e) {
  //     print("Splash error: $e");

  //     // Optional: Show user-friendly error toast
  //     showTopRightToast(
  //       context: context,
  //       message: "Something went wrong. Please try again.",
  //       color: Colors.red,
  //     );

  //     // Navigate to LoginPage on error
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => const LoginPage()),
  //       (route) => false,
  //     );
  //   }
  // }

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
