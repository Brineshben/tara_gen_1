import 'package:flutter/services.dart';

class LockTaskService {
  static const platform = MethodChannel('com.ihub.tara/locktask');

  static Future<void> stopLockTask() async {
    try {
      await platform.invokeMethod('stopLockTask');
    } catch (e) {
      print("Error stopping lock task: $e");
    }
  }

  static Future<void> startLockTask() async {
    try {
      await platform.invokeMethod('startLockTask');
    } catch (e) {
      print("Error starting lock task: $e");
    }
  }
}
