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
    // return Row(
    //   mainAxisSize: MainAxisSize.min,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     // Battery Body (4 Segments)
    //     Container(
    //       // padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    //       decoration: BoxDecoration(
    //         border: Border.all(color: Colors.white, width: 2),
    //         borderRadius: BorderRadius.circular(5),
    //       ),
    //       // child: Row(
    //       //   children: List.generate(4, (index) {
    //       //     return Container(
    //       //       width: segmentWidth,
    //       //       height: segmentHeight,
    //       //       margin: const EdgeInsets.symmetric(horizontal: 1),
    //       //       decoration: BoxDecoration(
    //       //         color: index < filledSegments
    //       //             ? currentColor
    //       //             : Colors.transparent,
    //       //         border: Border.all(color: Colors.white, width: 1),
    //       //         borderRadius: BorderRadius.circular(2),
    //       //       ),
    //       //     );
    //       //   }),
    //       // ),
    //       child:
    //     ),

    //     // Battery Tip (Now on Right Side)
    //     // Container(
    //     //   width: segmentWidth * 0.4,
    //     //   height: segmentHeight * 0.5,
    //     //   margin: const EdgeInsets.only(left: 2),
    //     //   decoration: BoxDecoration(
    //     //     color: Colors.white,
    //     //     borderRadius: BorderRadius.circular(2),
    //     //   ),
    //     // ),
    //   ],
    // );

    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Text(
            "$batteryLevel%",
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          batteryLevel > 30
              ? Lottie.asset('assets/yellow.json',
                  height: MediaQuery.of(context).size.height * 0.2)
              : (batteryLevel > 60
                  ? Lottie.asset('assets/greeen.json',
                      height: MediaQuery.of(context).size.height * 0.2)
                  : Lottie.asset('assets/red.json',
                      height: MediaQuery.of(context).size.height * 0.2)),
        ],
      ),
    );
  }
}
