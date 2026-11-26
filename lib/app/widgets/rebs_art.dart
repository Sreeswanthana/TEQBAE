import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/rebs_look.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..lineTo(0, size.height - 36);
    path.quadraticBezierTo(size.width * 0.45, size.height + 18, size.width, size.height - 48);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.light = true, this.compact = false});

  final bool light;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final title = light ? Colors.white : RebsLook.inkColor;
    final sub = light ? Colors.white70 : RebsLook.muteColor;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 42 : 54,
          height: compact ? 42 : 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(compact ? 12 : 16),
            gradient: const LinearGradient(
              colors: [Color(0xFF2F80ED), Color(0xFF1BC5A5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            'R',
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 24 : 30,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('REBS', style: TextStyle(color: title, fontSize: compact ? 16 : 20, fontWeight: FontWeight.w800, height: 1.05)),
            Text('HRMS', style: TextStyle(color: sub, fontSize: compact ? 16 : 20, fontWeight: FontWeight.w800, height: 1.05)),
          ],
        ),
      ],
    );
  }
}

class OfficeScene extends StatelessWidget {
  const OfficeScene({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 176,
      width: double.infinity,
      child: CustomPaint(painter: _OfficePainter()),
    );
  }
}

class _OfficePainter extends CustomPainter {
  const _OfficePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final sky = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFE7F4FF), Color(0xFFF7FBFF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & size);
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(24)), sky);

    final hill = Paint()..color = const Color(0xFFD7F3E4);
    final hillPath = Path()
      ..moveTo(0, size.height * 0.78)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.62, size.width * 0.62, size.height * 0.8)
      ..lineTo(size.width, size.height * 0.7)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hillPath, hill);

    void tree(double x, double y, double s) {
      canvas.drawCircle(Offset(x, y), s, Paint()..color = const Color(0xFF7ED0A0));
      canvas.drawCircle(Offset(x - s * 0.7, y + s * 0.2), s * 0.75, Paint()..color = const Color(0xFF5EBE8A));
      canvas.drawRect(Rect.fromCenter(center: Offset(x - 2, y + s), width: 4, height: s), Paint()..color = const Color(0xFF8D6A45));
    }

    tree(size.width * 0.12, size.height * 0.62, 16);
    tree(size.width * 0.88, size.height * 0.58, 18);
    tree(size.width * 0.78, size.height * 0.7, 12);

    final building = Paint()..color = const Color(0xFF4C8DDB);
    final left = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.28, size.height * 0.28, size.width * 0.22, size.height * 0.48),
      const Radius.circular(6),
    );
    final right = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.48, size.height * 0.18, size.width * 0.26, size.height * 0.58),
      const Radius.circular(6),
    );
    canvas.drawRRect(left, building);
    canvas.drawRRect(right, Paint()..color = const Color(0xFF3B78C9));

    final window = Paint()..color = const Color(0xFFD7ECFF);
    for (var r = 0; r < 3; r++) {
      for (var c = 0; c < 2; c++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.31 + c * 16, size.height * 0.34 + r * 18, 10, 10),
            const Radius.circular(2),
          ),
          window,
        );
      }
    }
    for (var r = 0; r < 4; r++) {
      for (var c = 0; c < 2; c++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.52 + c * 18, size.height * 0.24 + r * 18, 10, 10),
            const Radius.circular(2),
          ),
          window,
        );
      }
    }

    final pinX = size.width * 0.58;
    final pinY = size.height * 0.16;
    final pin = Path()
      ..addOval(Rect.fromCircle(center: Offset(pinX, pinY), radius: 12))
      ..moveTo(pinX - 8, pinY + 6)
      ..lineTo(pinX, pinY + 26)
      ..lineTo(pinX + 8, pinY + 6);
    canvas.drawPath(pin, Paint()..color = const Color(0xFFE45858));
    canvas.drawCircle(Offset(pinX, pinY), 4, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ClockScene extends StatelessWidget {
  const ClockScene({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 168,
      width: double.infinity,
      child: CustomPaint(painter: _ClockPainter()),
    );
  }
}

class _ClockPainter extends CustomPainter {
  const _ClockPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 4);
    canvas.drawCircle(center, 58, Paint()..color = const Color(0xFFE7F1FA));
    canvas.drawCircle(
      center,
      50,
      Paint()
        ..color = const Color(0xFF163E68)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );
    canvas.drawCircle(center, 44, Paint()..color = Colors.white);
    final hand = Paint()
      ..color = const Color(0xFF163E68)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, center + const Offset(0, -26), hand);
    canvas.drawLine(center, center + const Offset(18, 8), hand);
    canvas.drawCircle(center, 4, Paint()..color = const Color(0xFF163E68));

    final badge = center + const Offset(40, 28);
    canvas.drawCircle(badge, 16, Paint()..color = const Color(0xFF1F9D55));
    final check = Path()
      ..moveTo(badge.dx - 7, badge.dy)
      ..lineTo(badge.dx - 2, badge.dy + 5)
      ..lineTo(badge.dx + 8, badge.dy - 6);
    canvas.drawPath(
      check,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawCircle(Offset(size.width * 0.16, size.height * 0.72), 14, Paint()..color = const Color(0xFFB7E7C9));
    canvas.drawCircle(Offset(size.width * 0.84, size.height * 0.3), 10, Paint()..color = const Color(0xFFD7F0C8));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MapSketch extends StatelessWidget {
  const MapSketch({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: const SizedBox(
        height: 132,
        width: double.infinity,
        child: CustomPaint(painter: _MapPainter()),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  const _MapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFE7F0E4));
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(0, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.2, size.width, size.height * 0.45);
    canvas.drawPath(path, road);
    final path2 = Path()
      ..moveTo(size.width * 0.3, 0)
      ..lineTo(size.width * 0.55, size.height);
    canvas.drawPath(path2, road);

    final block = Paint()..color = const Color(0xFFD5E6C8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(12, size.height * 0.5, size.width * 0.28, 36), const Radius.circular(6)),
      block,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.62, 16, size.width * 0.28, 32), const Radius.circular(6)),
      block,
    );

    final office = Offset(size.width * 0.62, size.height * 0.48);
    canvas.drawCircle(office, 16, Paint()..color = const Color(0xFF1F9D55));
    canvas.drawCircle(office, 6, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SplashScene extends StatelessWidget {
  const SplashScene({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      painter: _SplashPainter(),
      child: SizedBox.expand(),
    );
  }
}

class _SplashPainter extends CustomPainter {
  const _SplashPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final skyline = Paint()..color = Colors.white.withValues(alpha: 0.12);
    final base = size.height * 0.72;
    final widths = [28.0, 18.0, 36.0, 16.0, 30.0, 22.0, 40.0];
    var x = 8.0;
    for (final w in widths) {
      final h = 30 + (w * 1.4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, base - h, w, h), const Radius.circular(3)),
        skyline,
      );
      x += w + 8;
    }

    final deskY = size.height * 0.78;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.18, deskY, size.width * 0.64, 14), const Radius.circular(6)),
      Paint()..color = Colors.white.withValues(alpha: 0.2),
    );

    final person = Offset(size.width * 0.38, size.height * 0.48);
    canvas.drawCircle(person, 16, Paint()..color = const Color(0xFFF3C7A5));
    canvas.drawArc(
      Rect.fromCircle(center: person.translate(0, -2), radius: 17),
      math.pi,
      math.pi,
      true,
      Paint()..color = const Color(0xFF1B2A4A),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: person.translate(8, 42), width: 54, height: 48),
        const Radius.circular(16),
      ),
      Paint()..color = const Color(0xFF1F4E89),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.52, person.dy + 18, 46, 30),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFD7E7F7),
    );

    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.62), 18, Paint()..color = const Color(0xFF8FE0B0));
    canvas.drawRect(
      Rect.fromCenter(center: Offset(size.width * 0.78, size.height * 0.78), width: 4, height: 22),
      Paint()..color = const Color(0xFFD8B07A),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
