import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
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
  String? _errorText;

  @override
  void initState() {
    super.initState();
    messageTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      _startAppLogic();
    });
  }

  Future<void> _startAppLogic() async {
    try {
      Map<String, dynamic> resp = await ApiServices.loading();
      if (resp['status'] == "ON") {
        messageTimer?.cancel(); // Stop further checks
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Homepage()),
          (route) => false,
        );
      }
    } on SocketException catch (_) {
      setState(() {
        _errorText = "No internet connection";
      });
    } on HttpException catch (_) {
      setState(() {
        _errorText = "Couldn't reach the server";
      });
    } catch (e) {
      setState(() {
        _errorText = "Something went wrong";
      });
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
            if (_errorText != null) ...[
              const SizedBox(height: 20),
              Text(
                _errorText!,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    messageTimer?.cancel();
    super.dispose();
  }
}
