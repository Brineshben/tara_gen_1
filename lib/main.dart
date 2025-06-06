import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ihub/Utils/api_constant.dart';
import 'package:ihub/View/Login_Page/login.dart';
import 'package:ihub/View/Splash/video_splash.dart';

import 'Service/controller_handling.dart';
import 'Service/sharedPreference.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ApiConstants.loadBaseUrl1();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  cameras = await availableCameras();
  final sharedPrefs = SharedPrefs();
  await sharedPrefs.initialize();

  HandleControllers.createGetControllers();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Tara',
          debugShowCheckedModeBanner: false,
          home: child,
        );
      },
      child: SplashVideoScreen(),
    );
  }
}
