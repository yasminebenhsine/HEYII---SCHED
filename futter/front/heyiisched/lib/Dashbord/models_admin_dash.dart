import 'package:flutter/material.dart';

class LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  LineChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Path path = Path();
    double xStep = size.width / (data.length - 1);
    for (int i = 0; i < data.length; i++) {
      if (i == 0) {
        path.moveTo(0, size.height - data[i] * 5); // Mise à l'échelle
      } else {
        path.lineTo(i * xStep, size.height - data[i] * 5); // Mise à l'échelle
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
