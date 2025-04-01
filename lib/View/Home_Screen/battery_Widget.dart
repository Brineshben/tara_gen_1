import 'package:flutter/material.dart';

class BatteryIcon extends StatelessWidget {
  final int batteryLevel; // Battery percentage (0 - 100)
  final double segmentHeight;
  final double segmentWidth;
  final Color highColor;
  final Color mediumColor;
  final Color lowColor;

  const BatteryIcon({
    Key? key,
    required this.batteryLevel,
    this.segmentHeight = 20,
    this.segmentWidth = 12,
    this.highColor = Colors.green,
    this.mediumColor = Colors.orange,
    this.lowColor = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int filledSegments = (batteryLevel / 25).ceil();

    // Determine color based on battery level
    Color currentColor = batteryLevel > 50
        ? highColor
        : (batteryLevel > 25 ? mediumColor : lowColor);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Battery Body (4 Segments)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: List.generate(4, (index) {
              return Container(
                width: segmentWidth,
                height: segmentHeight,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: index < filledSegments ? currentColor : Colors.transparent,
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        ),

        // Battery Tip (Now on Right Side)
        Container(
          width: segmentWidth * 0.4,
          height: segmentHeight * 0.5,
          margin: const EdgeInsets.only(left: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
