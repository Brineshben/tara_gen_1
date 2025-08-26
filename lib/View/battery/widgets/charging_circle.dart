import 'package:flutter/material.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/glassmorphism.dart';
import 'package:ihub/View/battery/view/battery_config.dart';
import 'package:lottie/lottie.dart';

class CharginDock extends StatelessWidget {
  final bool onDock;
  final String percentage;
  const CharginDock({
    super.key,
    required this.onDock,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final containerSize = screenSize.width * 0.75;
    final circleSize = containerSize * 0.36;
    final fontSize = containerSize * 0.035;

    return ChildGlasmorphism(
      child: Container(
        height: containerSize,
        width: containerSize,
        padding: EdgeInsets.all(15),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: circleSize,
              height: circleSize,
              padding: EdgeInsets.all(circleSize * 0.10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: onDock
                      ? [Color(0xffFF3030), Color.fromARGB(109, 42, 42, 42)]
                      : [
                          Color.fromARGB(180, 18, 164, 103),
                          Color.fromARGB(109, 42, 42, 42),
                        ],
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFF1A2A26), width: 8),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: onDock
                          ? Color.fromARGB(255, 240, 99, 11)
                          : Color(0xff26452F),
                      width: 6,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color.fromARGB(255, 26, 42, 38),
                        width: 10,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: onDock
                              ? Color.fromARGB(255, 230, 230, 22)
                              : Color(0xff468953),
                          width: 6,
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(circleSize * 0.05),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: onDock
                              ? Color.fromARGB(133, 98, 73, 73)
                              : Color.fromARGB(67, 11, 26, 9),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 26, 42, 38),
                          ),
                          child: Center(
                            child: onDock
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset("assets/zap.png", width: 15),
                                      Text(
                                        "$percentage%",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    "$percentage%",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: containerSize * 0.05,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // // Bottom icons
            // Positioned(
            //   bottom: 20,
            //   left: containerSize * 0.25,
            //   right: containerSize * 0.25,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: const [
            //       Icon(Icons.sync_alt, color: Colors.white, size: 28),
            //       Icon(Icons.battery_full, color: Colors.white, size: 28),
            //     ],
            //   ),
            // ),

            // Charging pill
            Positioned(
              top: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BatteryConfig()));
                  },
                  child: Ink(
                    width: 200,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: onDock ? Colors.red[700] : Color(0xff236947),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/zap.png",
                          width: 20,
                          color: onDock ? Color(0xff0F2FA13) : Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Battery Config",
                          style: TextStyle(
                            color: onDock ? Color(0xffF2FA13) : Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
