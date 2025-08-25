import 'dart:math';
import 'package:flutter/material.dart';

class InteractiveParticleSphere extends StatefulWidget {
  const InteractiveParticleSphere({
    super.key,
    this.size = 300,
    this.particleCount = 900,
  });

  final double size;
  final int particleCount;

  @override
  State<InteractiveParticleSphere> createState() =>
      InteractiveParticleSphereState();
}

class InteractiveParticleSphereState extends State<InteractiveParticleSphere>
    with TickerProviderStateMixin {
  late final AnimationController _orbit; // rotation
  late final AnimationController _scale; // collapse/restore
  late final List<_P3> _basePoints; // target 3D positions
  late final List<_Particle> _particles; // simulated dots

  Offset? _touchPos;
  double _touchStrength = 0.2;

  static const double _spring = 0.010;
  static const double _damping = 0.92;
  static const double _repelRadius = 70;
  static const double _repelForce = 220;

  @override
  void initState() {
    super.initState();

    _orbit = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )
      ..addListener(_tick)
      ..repeat();

    _scale = AnimationController(
      vsync: this,
      lowerBound: 0.6,
      upperBound: 1.0,
      value: 1.0,
      duration: const Duration(milliseconds: 260),
    )..addListener(() => setState(() {}));

    _basePoints = _fibonacciSphere(widget.particleCount);

    // ✅ Initialize particles at their correct positions
    final double r = widget.size / 2;
    final Offset center = Offset(r, r);
    _particles = List.generate(widget.particleCount, (i) {
      final p3 = _basePoints[i];
      final proj = _project(p3, r, center);
      return _Particle()
        ..pos = proj
        ..depth = (p3.z + 1) * 0.5;
    });
  }

  @override
  void dispose() {
    _orbit.dispose();
    _scale.dispose();
    super.dispose();
  }

  void expand() => _scale.forward();
  void collapse() => _scale.reverse();

  /// 👇 Function to simulate a touch at the center
  void simulateTouchAtCenter() {
    final center = Offset(widget.size / 2, widget.size / 2);
    _onDown(center);
    Future.delayed(const Duration(milliseconds: 500), () {
      _onUpCancel();
    });
  }

  void _tick() {
    setState(() {
      final double t = _orbit.value * 2 * pi;
      final double tilt = sin(_orbit.value * 2 * pi) * 0.3;

      final double r = widget.size / 2;
      final Offset center = Offset(r, r);

      for (int i = 0; i < _particles.length; i++) {
        final p3 = _basePoints[i].rotateY(t).rotateX(tilt);
        final proj = _project(p3, r * _scale.value, center);

        final dot = _particles[i];
        final Offset delta = proj - dot.pos;
        dot.vel += delta * _spring;

        if (_touchPos != null && _touchStrength > 0) {
          final Offset d = dot.pos - _touchPos!;
          final double dist = d.distance;
          if (dist < _repelRadius) {
            final double k = (1 - dist / _repelRadius);
            final double push = _repelForce * k * _touchStrength / (dist + 6);
            dot.vel += (d / (dist + 1e-6)) * push;
          }
        }

        dot.vel *= _damping;
        dot.pos += dot.vel;
        dot.depth = (p3.z + 1) * 0.5;
      }

      _touchStrength *= 0.92;
      if (_touchStrength < 0.01) _touchStrength = 0.0;
    });
  }

  Offset _project(_P3 p, double radius, Offset center) {
    final double z = (p.z + 2.2);
    final double persp = 1 / z;
    final double x = p.x * radius * persp;
    final double y = p.y * radius * persp;
    return center + Offset(x, y);
  }

  void _onDown(Offset localPos) {
    _touchPos = localPos;
    _touchStrength = 1.0;
    _scale.reverse();
  }

  void _onMove(Offset localPos) {
    _touchPos = localPos;
    _touchStrength = 0.9;
  }

  void _onUpCancel() {
    _touchPos = null;
    _scale.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Listener(
        onPointerDown: (e) => _onDown(e.localPosition),
        onPointerMove: (e) => _onMove(e.localPosition),
        onPointerUp: (_) => _onUpCancel(),
        onPointerCancel: (_) => _onUpCancel(),
        child: CustomPaint(
          painter: _SpherePainter(_particles),
        ),
      ),
    );
  }

  void listening() async {
    final double r = widget.size / 2;
    final Offset center = Offset(r, r);

    for (int cycle = 0; cycle < 3; cycle++) {
      for (int i = 0; i < 20; i++) {
        final angle = i / 20 * 2 * pi;
        final pos = Offset(
          center.dx + cos(angle) * (r * 0.6),
          center.dy + sin(angle) * (r * 0.6),
        );
        _onDown(pos);
        await Future.delayed(const Duration(milliseconds: 30));
        _onMove(center);
      }
      _onUpCancel();
      await Future.delayed(const Duration(milliseconds: 150));
    }
  }

  // speaking
  void speaking() async {
    final double r = widget.size / 2;
    final double y = r; // keep drag along the vertical center line

    Offset start = Offset(20, y);
    Offset end = Offset(widget.size - 20, y);
    int steps = 30;

    _onDown(start);

    for (int i = 0; i <= steps; i++) {
      final dx = start.dx + (end.dx - start.dx) * (i / steps);
      final pos = Offset(dx, y);

      _onMove(pos);

      await Future.delayed(const Duration(milliseconds: 20));
    }

    _onUpCancel();
  }
}

class _SpherePainter extends CustomPainter {
  _SpherePainter(this.particles);
  final List<_Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dot = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 0);

    final idx = List<int>.generate(particles.length, (i) => i)
      ..sort((a, b) => particles[a].depth.compareTo(particles[b].depth));

    for (final i in idx) {
      final p = particles[i];
      final double s = lerpDouble(0.3, 0.8, p.depth)!;
      dot.color = const Color.fromARGB(255, 191, 188, 188);
      canvas.drawCircle(p.pos, s, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _SpherePainter oldDelegate) => true;
}

class _Particle {
  Offset pos = Offset.zero;
  Offset vel = Offset.zero;
  double depth = 0.0;
}

class _P3 {
  final double x, y, z;
  const _P3(this.x, this.y, this.z);

  _P3 rotateY(double a) {
    final ca = cos(a), sa = sin(a);
    return _P3(ca * x + sa * z, y, -sa * x + ca * z);
  }

  _P3 rotateX(double a) {
    final ca = cos(a), sa = sin(a);
    return _P3(x, ca * y - sa * z, sa * y + ca * z);
  }
}

List<_P3> _fibonacciSphere(int n) {
  double phi = (1 + sqrt(5)) / 2;
  final double ga = 2 * pi * (1 - 1 / phi);
  final List<_P3> pts = [];

  for (int i = 0; i < n; i++) {
    final double t = (i + 0.5) / n;
    final double y = 1 - 2 * t;
    final double r = sqrt(max(0, 1 - y * y));
    final double th = ga * i;
    final double x = cos(th) * r;
    final double z = sin(th) * r;
    pts.add(_P3(x, y, z));
  }
  return pts;
}

double? lerpDouble(double a, double b, double t) => a + (b - a) * t;
