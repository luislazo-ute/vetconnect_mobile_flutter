import 'dart:math';

import 'package:flutter/material.dart';

class FondoHuellas extends CustomPainter {
  final Color color;
  final double opacidad;
  final int cantidad;

  FondoHuellas({
    this.color = Colors.white,
    this.opacidad = 0.06,
    this.cantidad = 16,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: opacidad);
    final rnd = Random(7);
    for (var i = 0; i < cantidad; i++) {
      final dx = rnd.nextDouble() * size.width;
      final dy = rnd.nextDouble() * size.height;
      final s = 16.0 + rnd.nextDouble() * 18;
      _huella(canvas, paint, Offset(dx, dy), s);
    }
  }

  void _huella(Canvas c, Paint p, Offset o, double s) {
    c.drawOval(
      Rect.fromCenter(
        center: o + Offset(0, s * 0.35),
        width: s * 0.95,
        height: s * 1.05,
      ),
      p,
    );
    c.drawCircle(o + Offset(-s * 0.45, -s * 0.18), s * 0.22, p);
    c.drawCircle(o + Offset(-s * 0.15, -s * 0.5), s * 0.22, p);
    c.drawCircle(o + Offset(s * 0.15, -s * 0.5), s * 0.22, p);
    c.drawCircle(o + Offset(s * 0.45, -s * 0.18), s * 0.22, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
