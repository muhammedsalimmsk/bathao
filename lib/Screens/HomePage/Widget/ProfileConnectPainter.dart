import 'package:flutter/material.dart';

class ProfileConnectorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine =
        Paint()
          ..color = const Color(0xFF1B2470)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round;

    final paintGlowCircle =
        Paint()
          ..color = const Color(0xFFECAB5D).withOpacity(0.9)
          ..style = PaintingStyle.fill;

    final path = Path();
    // Draw the circuit-like connector
    path.moveTo(0, 30);
    path.lineTo(50, 30);
    path.lineTo(50, size.height - 30);
    path.lineTo(0, size.height - 30);

    canvas.drawPath(path, paintLine);

    // Top glowing node
    canvas.drawCircle(const Offset(50, 30), 10, paintGlowCircle);

    // Bottom glowing node
    canvas.drawCircle(Offset(0, size.height - 30), 10, paintGlowCircle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
