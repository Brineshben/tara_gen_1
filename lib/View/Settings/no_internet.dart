import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  String _statusText = '';

  Future<void> _retryConnection() async {
    setState(() {
      _statusText = "Checking connection...";
    });

    // bool isConnected = await InternetConnectionChecker().hasConnection;
    bool isConnected =
        await InternetConnectionChecker.createInstance().hasConnection;

    if (isConnected) {
      Get.back();
    } else {
      setState(() {
        _statusText = "Still no internet. Try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, size: 80, color: Colors.redAccent),
                const SizedBox(height: 20),
                const Text(
                  "No Internet",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "You're offline. Please check your connection.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _retryConnection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Retry",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                if (_statusText.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    _statusText,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
