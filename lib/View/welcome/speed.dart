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
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: GetX<SpeedController>(
                        builder: (SpeedController controller) {
                          if (controller.isLoading.value) {
                            return const CircularProgressIndicator(
                              color: Colors.white,
                            );
                          }
                          return _buildSpeedSlider(controller);
                        },
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              ChildGlasmorphism(
              borderRadius: 15,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSpeedLabel('SLOW', 0.1, 0.3, controller.speed.value),
                    const SizedBox(width: 20),
                    _buildSpeedLabel(
                        'NORMAL', 0.4, 0.5, controller.speed.value),
                    const SizedBox(width: 20),
                    _buildSpeedLabel('FAST', 0.6, 0.7, controller.speed.value),
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return ChildGlasmorphism(
                  borderRadius: 30,
                  child: Container(
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
                            Icon(
                              Icons.speed,
                              size: 40,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              speedValue.toString(),
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.white.withOpacity(0.3),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'LEVEL',
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
                  ),
                );
              },
            ),
          ],
        ),

        const SizedBox(height: 60),

        // Vertical Slider
        ChildGlasmorphism(
          borderRadius: 25,
          child: Container(
            width: 80,
            height: 480,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: RotatedBox(
              quarterTurns: 3, // Rotate slider to be vertical
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white.withOpacity(0.8),
                  inactiveTrackColor: Colors.white.withOpacity(0.2),
                  thumbColor: Colors.white,
                  overlayColor: Colors.white.withOpacity(0.2),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 12.0,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 20.0,
                  ),
                  trackHeight: 6.0,
                  activeTickMarkColor: Colors.white.withOpacity(0.6),
                  inactiveTickMarkColor: Colors.white.withOpacity(0.1),
                ),
                child: Slider(
                  value: controller.speed.value,
                  min: 0.1,
                  max: 0.7,
                  divisions: 6,
                  onChanged: (value) {
                    controller.speed.value = value;
                    controller.updateSpeed(value);
                    HapticFeedback.selectionClick();
                  },
                ),
              ),
            ),
          ),
        ),


      
      ],
    );
  }

  Widget _buildSpeedLabel(
      String label, double minSpeed, double maxSpeed, double currentSpeed) {
    final isActive = currentSpeed >= minSpeed && currentSpeed <= maxSpeed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
          fontSize: 12,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          letterSpacing: 1,
        ),
      ),
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
