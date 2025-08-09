  import 'dart:ui';
  import 'package:flutter/material.dart';

  class BaseGlassmorphism extends StatelessWidget {
    final Widget child;
    final double borderRadius;
    final EdgeInsetsGeometry padding;
    final EdgeInsetsGeometry margin;

    const BaseGlassmorphism({
      super.key,
      required this.child,
      this.borderRadius = 24.0,
      this.padding = const EdgeInsets.all(24.0),
      this.margin = const EdgeInsets.all(0),
    });

    @override
    Widget build(BuildContext context) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            margin: margin,
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: child,
          ),
        ),
      );
    }
  }




class ChildGlasmorphism extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final Color borderColor;

  const ChildGlasmorphism({
    super.key,
    required this.child,
    this.borderRadius = 20.0,
    this.margin,
    this.borderColor = const Color.fromRGBO(255, 255, 255, 0.15),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          margin: margin,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor),
          ),
          child: child,
        ),
      ),
    );
  }
}

