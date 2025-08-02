import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/foundation.dart';

class SharingHelper {
  static Future<void> shareText(String message) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final intent = AndroidIntent(
        action: 'android.intent.action.SEND',
        arguments: <String, dynamic>{
          'android.intent.extra.TEXT': message,
        },
        type: 'text/plain',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );

      await intent.launch();
    } else {
      debugPrint("Only works on Android.");
    }
  }
}
