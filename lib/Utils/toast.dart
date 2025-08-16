// import 'package:another_flushbar/flushbar.dart';
// import 'package:flutter/material.dart';

// showTopRightToast({
//   required BuildContext context,
//   required String message,
//   required Color color,
// }) {
//   Flushbar(
//     message: message,
//     icon: Icon(
//       color != Colors.red ? Icons.check_circle : Icons.info,
//       color: color,
//     ),
//     margin: const EdgeInsets.only(top: 40, right: 10),
//     borderRadius: BorderRadius.circular(8),
//     backgroundColor: Colors.white,
//     messageColor: color,
//     duration: const Duration(seconds: 2),
//     flushbarPosition: FlushbarPosition.TOP,
//     flushbarStyle: FlushbarStyle.FLOATING,
//     isDismissible: true,
//     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//     maxWidth: 350,
//     forwardAnimationCurve: Curves.easeOutBack,
//     reverseAnimationCurve: Curves.easeInBack,
//     animationDuration: const Duration(seconds: 2),
//   ).show(context);
// }

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Flushbar<dynamic>? _activeFlushbar;

showTopRightToast({
  required BuildContext context,
  required String message,
  required Color color,
}) {
  _activeFlushbar?.dismiss();

  _activeFlushbar = Flushbar(
    message: message,
    icon: Icon(
      color != Colors.red ? Icons.check_circle : Icons.info,
      color: color,
    ),
    margin: const EdgeInsets.only(top: 40, right: 10),
    borderRadius: BorderRadius.circular(8),
    backgroundColor: Colors.white,
    messageColor: color,
    duration: const Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.TOP,
    shouldIconPulse: false,
    flushbarStyle: FlushbarStyle.FLOATING,
    isDismissible: true,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    maxWidth: 350,
    animationDuration: const Duration(milliseconds: 500),
  )..show(context).then((_) {
      _activeFlushbar = null;
    });
}
