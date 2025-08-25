import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ihub/Controller/speed_controller.dart';
import 'package:ihub/Utils/glassmorphism.dart';

class SpeedControllerPage extends StatefulWidget {
  const SpeedControllerPage({super.key});

  @override
  _SpeedControllerPageState createState() => _SpeedControllerPageState();
}

class _SpeedControllerPageState extends State<SpeedControllerPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    _hideSystemUI();
    Get.find<SpeedController>().fetchSpeed();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    super.initState();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.transparent),
            ),
          ),
          GetX<SpeedController>(
            builder: (SpeedController controller) {
              return controller.isLoading.value
                  ? Center(child: CircularProgressIndicator(color: Colors.white,))
                  : Column(
                      children: [
                        _buildHeader(),
                        _buildSpeedSlider(controller),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Row(
        children: [
          ChildGlasmorphism(
            borderRadius: 10,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          const Text(
            'SPEED CONTROLLER',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedSlider(SpeedController controller) {
    final speedValue = (controller.speed.value * 10).toInt();

    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: 400,
              height: 400,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Speed indicator ring
                  CustomPaint(
                    size: const Size(300, 300),
                    painter: SpeedRingPainter(
                      controller.speed.value,
                      _glowAnimation.value,
                    ),
                  ),
                  // Center content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        speedValue.toString(),
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'SPEED LEVEL',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                          letterSpacing: 2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  double newSpeed = controller.speed.value - 0.1;
                  if (newSpeed >= 0.1) {
                    controller.speed.value = newSpeed;
                    controller.updateSpeed(newSpeed);
                    HapticFeedback.mediumImpact();
                  }
                },
                child: ChildGlasmorphism(
                  borderRadius: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    child: Icon(
                      Icons.remove,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 30),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  double newSpeed = controller.speed.value + 0.1;
                  if (newSpeed <= 0.7) {
                    controller.speed.value = newSpeed;
                    controller.updateSpeed(newSpeed);
                    HapticFeedback.mediumImpact();
                  }
                },
                child: ChildGlasmorphism(
                  borderRadius: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    child: Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SpeedRingPainter extends CustomPainter {
  final double speed;
  final double glowIntensity;

  SpeedRingPainter(this.speed, this.glowIntensity);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background arc
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = Colors.white.withOpacity(0.6 * glowIntensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final sweepAngle = ((speed - 0.1) / 0.6) * 2 * pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Speed dots
    for (int i = 0; i < 8; i++) {
      final angle = (i / 7) * 2 * pi - pi / 2;
      final dotX = center.dx + cos(angle) * radius;
      final dotY = center.dy + sin(angle) * radius;

      final isActive = i <= ((speed - 0.1) / 0.6 * 7);
      final dotPaint = Paint()
        ..color = isActive
            ? Colors.white.withOpacity(0.8)
            : Colors.white.withOpacity(0.2);

      canvas.drawCircle(
        Offset(dotX, dotY),
        isActive ? 4 : 2,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
