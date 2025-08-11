import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

showTopRightToast({
  required BuildContext context,
  required String message,
  required Color color,
}) {
  Flushbar(
    message: message,

    icon: Icon(Icons.info, color: color,),
    margin: const EdgeInsets.only(top: 40, right: 10),
    borderRadius: BorderRadius.circular(8),
    backgroundColor: Colors.white,
    messageColor: color,
    duration: const Duration(seconds: 2),
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    isDismissible: true,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    maxWidth: 350,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(seconds: 2),
  ).show(context);
}
