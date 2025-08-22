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
  late AnimationController _rotationController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    _hideSystemUI();
    Get.find<SpeedController>().fetchSpeed();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    super.initState();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  Color _getSpeedColor(double speed) {
    if (speed <= 0.3) return const Color(0xFF00FF88); // Neon Green
    if (speed <= 0.5) return Colors.orange; // Neon Orange
    return  const Color.fromARGB(255, 255, 17, 0); // Neon Pink/Red
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
            decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [
              //     const Color(0xFF608878).withOpacity(0.1),
              //     const Color(0xFF18221E).withOpacity(0.1),
              //   ],
              // ),
            ),
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
                  child: Center(
                    child: GetX<SpeedController>(
                      builder: (SpeedController controller) {
                        if (controller.isLoading.value) {
                          return CircularProgressIndicator(color: Colors.white,);
                        }
                        return _buildSpeedDisplay(controller);
                      },
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
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedDisplay(SpeedController controller) {
    final speedColor = _getSpeedColor(controller.speed.value);
    final speedValue = (controller.speed.value * 10).toInt();

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_pulseAnimation, _glowAnimation]),
            builder: (context, child) {
              return Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      speedColor.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: speedColor.withOpacity(_glowAnimation.value),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                        speedColor.withOpacity(0.2),
                      ],
                    ),
                    border: Border.all(
                      color: speedColor,
                      width: 3,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Rotating outer ring
                      AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: CustomPaint(
                              size: const Size(200, 200),
                              painter: SpeedRingPainter(
                                speedColor,
                                controller.speed.value,
                              ),
                            ),
                          );
                        },
                      ),
                      // Center content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.settings_input_antenna,
                            size: 60,
                            color: speedColor,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            speedValue.toString(),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: speedColor,
                              shadows: [
                                Shadow(
                                  color: speedColor.withOpacity(0.5),
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
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          // Speed status

          _buildControlButtons(controller, speedColor),
          // _buildSpeedStatus(controller.speed.value, speedColor),



          // Control buttons
        ],
      ),
    );
  }

  Widget _buildSpeedStatus(double speed, Color speedColor) {
    String status;
    String description;
    IconData icon;

    if (speed <= 0.3) {
      status = 'LOW POWER';
      description = 'Energy Conservation Mode';
      icon = Icons.eco;
    } else if (speed <= 0.5) {
      status = 'OPTIMAL';
      description = 'Balanced Performance';
      icon = Icons.tune;
    } else {
      status = 'HIGH PERFORMANCE';
      description = 'Maximum Efficiency';
      icon = Icons.flash_on;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            speedColor.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: speedColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: speedColor, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: TextStyle(
                  color: speedColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons(SpeedController controller, Color speedColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          icon: Icons.remove,
          label: 'DECREASE',
          color: speedColor,
          onTap: () {
            double newSpeed = controller.speed.value - 0.1;
            if (newSpeed >= 0.1) {
              controller.speed.value = newSpeed;
              controller.updateSpeed(newSpeed);
              HapticFeedback.mediumImpact();
            }
          },
        ),
        _buildControlButton(
          icon: Icons.add,
          label: 'INCREASE',
          color: speedColor,
          onTap: () {
            double newSpeed = controller.speed.value + 0.1;
            if (newSpeed <= 0.7) {
              controller.speed.value = newSpeed;
              controller.updateSpeed(newSpeed);
              HapticFeedback.mediumImpact();
            }
          },
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(60),
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                        color.withOpacity(0.2),
                      ],
                    ),
                    border: Border.all(
                      color: color.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: color, size: 30),
                      const SizedBox(height: 8),
                      Text(
                        label,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SpeedRingPainter extends CustomPainter {
  final Color color;
  final double speed;

  SpeedRingPainter(this.color, this.speed);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw speed indicators
    for (int i = 0; i < 12; i++) {
      final angle = i * 30 * (pi / 180);
      final startX = center.dx + cos(angle) * (radius - 15);
      final startY = center.dy + sin(angle) * (radius - 15);
      final endX = center.dx + cos(angle) * radius;
      final endY = center.dy + sin(angle) * radius;

      final opacity = i < (speed * 12) ? 1.0 : 0.2;
      paint.color = color.withOpacity(opacity);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
