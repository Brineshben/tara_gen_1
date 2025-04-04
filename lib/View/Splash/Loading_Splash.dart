import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoadingSplash extends StatelessWidget {
  const LoadingSplash({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, top: 20),
            child: Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 60.h,
                        width: 60.h,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.3),
                            //     blurRadius: 10,
                            //     spreadRadius: 0,
                            //   ),
                            // ],
                            borderRadius:
                            BorderRadius.circular(15).r),
                        child: Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    // Center(
                    //   child: Text(
                    //     "NAVIGATION",
                    //     style: GoogleFonts.oxygen(
                    //         color: Colors.white,
                    //         fontSize: 25.h,
                    //         fontWeight: FontWeight.w700),
                    //   ),
                    // ),
                  ],
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Column(
              children: [
                // Center(
                //   child: Lottie.asset(
                //     "assets/loading.json",
                //     fit: BoxFit.fitHeight,
                //   ),
                // ),
                SizedBox(
                  height: 50.h,
                  width: 280.w,
                  child: DefaultTextStyle(
                    style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 30.h,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black
                                .withOpacity(0.7),
                            offset: Offset(2, 2),
                          ),
                        ]),
                    child: Center(
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'LOADING....',
                            speed: Duration(
                                milliseconds: 50),
                            // Adjust typing speed
                            cursor:
                            '|', // Optional cursor
                          ),
                        ],
                        repeatForever: true,
                        // Ensures continuous looping
                        isRepeatingAnimation: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
