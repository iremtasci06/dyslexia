import 'package:flutter/material.dart';

class HousePainter extends CustomPainter {
  final Color wallColor;
  final Color roofColor;
  final Color doorColor;
  final Color treeColor;
  final Color windowColor; // pencere

  HousePainter(
      this.wallColor, this.roofColor, this.doorColor, this.treeColor, this.windowColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 3;

    // Duvar
    paint.color = wallColor;
    final wall = Rect.fromLTWH(80, 180, 240, 200);
    canvas.drawRect(wall, paint);
    canvas.drawRect(wall, border);

    // Çatı
    paint.color = roofColor;
    final roof = Path()
      ..moveTo(200, 80)
      ..lineTo(60, 180)
      ..lineTo(340, 180)
      ..close();
    canvas.drawPath(roof, paint);
    canvas.drawPath(roof, border);

    // Kapı
    paint.color = doorColor;
    final door = Rect.fromLTWH(180, 280, 40, 100);
    canvas.drawRect(door, paint);
    canvas.drawRect(door, border);

    // Pencere
    paint.color = windowColor;
    final window = Rect.fromLTWH(120, 220, 40, 60);
    canvas.drawRect(window, paint);
    canvas.drawRect(window, border);

    // Ağaç
    paint.color = Colors.brown;
    final trunk = Rect.fromLTWH(360, 280, 20, 80);
    canvas.drawRect(trunk, paint);
    canvas.drawRect(trunk, border);

    paint.color = treeColor;
    final leaves = Path()
      ..addOval(Rect.fromCircle(center: const Offset(370, 240), radius: 40));
    canvas.drawPath(leaves, paint);
    canvas.drawPath(leaves, border);

    // Sayılar
    _drawText(canvas, "0", Offset(200, 250));
    _drawText(canvas, "8", Offset(200, 150));
    _drawText(canvas, "3", Offset(200, 330));
    _drawText(canvas, "2", Offset(370, 240));
    _drawText(canvas, "5", Offset(140, 250)); // pencere
  }

  void _drawText(Canvas canvas, String text, Offset offset) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, offset - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant HousePainter oldDelegate) {
    return oldDelegate.wallColor != wallColor ||
        oldDelegate.roofColor != roofColor ||
        oldDelegate.doorColor != doorColor ||
        oldDelegate.treeColor != treeColor ||
        oldDelegate.windowColor != windowColor;
  }
}