import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedTextGradient extends StatefulWidget {
  final String text;
  final double fontSize;

  const AnimatedTextGradient({
    super.key,
    required this.text,
    required this.fontSize,
  });

  @override
  _AnimatedTextGradientState createState() => _AnimatedTextGradientState();
}

class _AnimatedTextGradientState extends State<AnimatedTextGradient>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // faster than 2s
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // smoother movement
      ),
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                Color(0xFFFFFFFF), // bright white
                Color(0xFFCCCCCC), // light grey
                Color(0xFF595959), // dark grey
                Color(0xFFB0B0B0), // silver
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
              begin:
                  Alignment(-2.0 + 4 * _controller.value, 0), // travels wider
              end: Alignment(0.0 + 4 * _controller.value, 0),
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: GoogleFonts.poppins(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
