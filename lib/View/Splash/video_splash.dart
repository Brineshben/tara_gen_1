import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/Login_api_controller.dart';
import 'package:ihub/Controller/battery_Controller.dart';
import 'package:ihub/Model/background_model.dart';
import 'package:ihub/Model/login_model.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Service/sharedPreference.dart';
import 'package:ihub/View/Login_Page/login.dart';
import 'package:ihub/View/Robot_Response/homepage.dart';
import 'package:ihub/View/Splash/Loading_Splash.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:video_player/video_player.dart';

class SplashVideoScreen extends StatefulWidget {
  const SplashVideoScreen({super.key});

  @override
  State<SplashVideoScreen> createState() => _SplashVideoScreenState();
}

class _SplashVideoScreenState extends State<SplashVideoScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/splash_video.mp4");
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    await _controller.initialize();
    _controller.setVolume(0);
    _controller.play();

    setState(() {
      _isInitialized = true;
    });

    _startAppLogic();
  }

  Future<void> _startAppLogic() async {
    Map<String, dynamic> resp = await ApiServices.loading();
    LoginModel? loginApi = await SharedPrefs().getLoginData();

    if (resp['status'] == "ON") {
      Future.delayed(const Duration(seconds: 10), () async {
        await fetchBackground(loginApi?.user?.id ?? 0);

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
      });
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoadingSplash()),
        (route) => false,
      );
    }
  }

  Future<void> fetchBackground(int userID) async {
    Map<String, dynamic> resp = await ApiServices.background(userId: userID);
    if (resp['status'] == "ok") {
      BackgroundModel backgrounddata = BackgroundModel.fromJson(resp);
      final imagePath = backgrounddata.backgroundImage;

      if (imagePath != null) {
        updateImageColor(imagePath);
      }
    }
  }

  Future<void> updateImageColor(String imageUrl) async {
    print('find color of image');
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
    );

    final dominantColor = paletteGenerator.dominantColor?.color ?? Colors.white;
    final brightness = ThemeData.estimateBrightnessForColor(dominantColor);

    Get.find<BatteryController>().foregroundColor.value =
        brightness == Brightness.dark ? Colors.white : Colors.black;

    print("Updated color: $dominantColor, brightness: $brightness");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isInitialized
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            )),
    );
  }
}
