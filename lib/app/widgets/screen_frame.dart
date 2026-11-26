import 'package:flutter/material.dart';

/// Shared sizing so screens and buttons fit small phones and wide tablets.
class Responsive {
  static bool compact(BuildContext context) => MediaQuery.sizeOf(context).width < 360;

  static bool wide(BuildContext context) => MediaQuery.sizeOf(context).width >= 840;

  static double buttonHeight(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final scale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.35);
    final base = height < 680 ? 46.0 : 52.0;
    return base * scale;
  }

  static double mapHeight(BuildContext context) {
    return (MediaQuery.sizeOf(context).height * 0.28).clamp(170.0, 280.0);
  }
}

/// Keeps a screen's content from stretching edge to edge on tablets.
class ScreenFrame extends StatelessWidget {
  const ScreenFrame({super.key, required this.child, this.maxWidth = 880});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
