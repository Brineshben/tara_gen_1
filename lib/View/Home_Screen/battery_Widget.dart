import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BatteryIcon extends StatelessWidget {
  final int batteryLevel;
  final Color color;

  const BatteryIcon({
    required this.batteryLevel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Text(
            "$batteryLevel%".toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (batteryLevel > 60)
            Lottie.asset('assets/greeen.json',
                height: MediaQuery.of(context).size.height * 0.2)
          else if (batteryLevel >= 30 && batteryLevel <= 60)
            Lottie.asset('assets/yellow.json',
                height: MediaQuery.of(context).size.height * 0.2)
          else
            Lottie.asset('assets/red.json',
                height: MediaQuery.of(context).size.height * 0.2)
        ],
      ),
    );
  }
}
