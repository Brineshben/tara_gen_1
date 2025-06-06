import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class RobotCommunicationStatus extends StatelessWidget {
  final String text;
  const RobotCommunicationStatus({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Lottie.asset(
            "assets/Animation - 1739525563341.json",
          ),
        ),
        DefaultTextStyle(
          style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 30.h,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.black.withOpacity(0.7),
                  offset: Offset(2, 2),
                ),
              ]),
          child: Center(
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  text,
                  speed: Duration(milliseconds: 50),
                  cursor: '|',
                ),
              ],
              repeatForever: true,
              isRepeatingAnimation: true,
            ),
          ),
        ),
      ],
    );
  }
}
