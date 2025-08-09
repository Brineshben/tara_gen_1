
import 'package:flutter/material.dart';
import 'package:ihub/Service/Api_Service.dart';
import 'package:ihub/Utils/glassmorphism.dart';
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
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          child: Container(
                            width: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(33),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF1A2A26).withOpacity(0.95),
                                  Color(0xFF0F1F1C).withOpacity(0.95),
                                ],
                              ),
                              border: Border.all(
                                color: Color(0xff26452F).withOpacity(0.6),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xff236947).withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 15,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.05),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: Center(
                                        child: Lottie.asset(
                                          'assets/char.json',
                                          width: 80,
                                          height: 80,
                                          repeat: true,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // Description
                                    Text(
                                       onDock
                                          ? "Robot is charging. Do you want to stop charging?"
                                          : "Robot is not charging. Send it to the dock now?",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white.withOpacity(0.9),
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    const SizedBox(height: 28),

                                    // Action Buttons
                                    Row(
                                      children: [
                                        // Cancel Button
                                        Expanded(
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.red.withOpacity(0.8),
                                                  Colors.red.shade700
                                                      .withOpacity(0.9),
                                                ],
                                              ),
                                              border: Border.all(
                                                color: Colors.red.shade400
                                                    .withOpacity(0.6),
                                                width: 1,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.red.withOpacity(
                                                    0.3,
                                                  ),
                                                  blurRadius: 8,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          25,
                                                        ),
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.white
                                                            .withOpacity(0.1),
                                                        Colors.transparent,
                                                      ],
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 6),
                                                        Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        // Confirm Button
                                        Expanded(
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Color(0xff236947),
                                                  Color(0xff468953),
                                                ],
                                              ),
                                              border: Border.all(
                                                color: Color(0xff26452F),
                                                width: 1,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(
                                                    0xff236947,
                                                  ).withOpacity(0.4),
                                                  blurRadius: 12,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                onTap: () async {
                                                  if (onDock) {
                                                    final responce =
                                                        await ApiServices.setChargingStatus(
                                                          false,
                                                        );
                                                    if (responce['status'] ==
                                                        false) {
                                                      Navigator.pop(context);
                                                    }
                                                  } else {
                                                    final responce =
                                                        await ApiServices
                                                            .setChargingStatus(
                                                          true,
                                                        );
                                                    if (responce['status'] ==
                                                        true) {
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          25,
                                                        ),
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.white
                                                            .withOpacity(0.15),
                                                        Colors.transparent,
                                                      ],
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          "assets/zap.png",
                                                          width: 18,
                                                          height: 18,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                       onDock?"Stop Charging":   "Start Charging",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Ink(
                    width: 150,
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
                          onDock ? "Charging..." : "Charge Now",
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
