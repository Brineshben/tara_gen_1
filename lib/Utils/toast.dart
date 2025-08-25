
// import 'package:another_flushbar/flushbar.dart';
// import 'package:flutter/material.dart';

// Flushbar<dynamic>? _activeFlushbar;

// showTopRightToast({
//   required BuildContext context,
//   required String message,
//   required Color color,
// }) {
//   _activeFlushbar?.dismiss();

//   _activeFlushbar = Flushbar(
//     message: message,
//     icon: Icon(
//       color != Colors.red ? Icons.check_circle : Icons.info,
//       color: color,
//     ),
//     margin: const EdgeInsets.only(top: 40, right: 10),
//     borderRadius: BorderRadius.circular(8),
//     backgroundColor: Colors.white,
//     messageColor: color,
//     duration: const Duration(seconds: 3),
//     flushbarPosition: FlushbarPosition.TOP,
//     shouldIconPulse: false,
//     flushbarStyle: FlushbarStyle.FLOATING,
//     isDismissible: true,
//     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//     maxWidth: 350,
//     animationDuration: const Duration(milliseconds: 500),
//   )..show(context).then((_) {
//       _activeFlushbar = null;
//     });
// }



// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// showTopRightToast({
//   required String message,
//   required Color color,
// }) {
//   Fluttertoast.showToast(
//     msg: message,
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.TOP,
//     backgroundColor: Colors.white,
//     textColor: color,
//     fontSize: 16.0,
//   );
// }

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void showTopRightToast({
  required String message,
  required Color color,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP, // top only (no top-right support)
    backgroundColor: Colors.white.withOpacity(0.2), // semi-transparent
    textColor: color,
    fontSize: 14,
  );
}
