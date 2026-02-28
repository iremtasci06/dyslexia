import 'package:flutter/material.dart';

class CuteBearPainter extends CustomPainter {
  final Color faceColor;
  final Color earColor;
  final Color innerEarColor;
  final Color noseColor;
  final Color noseBgColor;

  CuteBearPainter({
    required this.faceColor,
    required this.earColor,
    required this.innerEarColor,
    required this.noseColor,
    required this.noseBgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = Colors.black;

    final center = Offset(size.width / 2, size.height / 2);
    final headRadius = size.width * 0.35;

    // 🎨 Kulaklar (arkada)
    final earRadius = headRadius * 0.4;
    final leftEarCenter = Offset(center.dx - headRadius * 0.7, center.dy - headRadius * 0.7);
    final rightEarCenter = Offset(center.dx + headRadius * 0.7, center.dy - headRadius * 0.7);

    final earPaint = Paint()..color = earColor;
    canvas.drawCircle(leftEarCenter, earRadius, earPaint);
    canvas.drawCircle(rightEarCenter, earRadius, earPaint);
    canvas.drawCircle(leftEarCenter, earRadius, outline);
    canvas.drawCircle(rightEarCenter, earRadius, outline);

    // Kulak içi
    final innerEarPaint = Paint()..color = innerEarColor;
    canvas.drawCircle(leftEarCenter, earRadius * 0.6, innerEarPaint);
    canvas.drawCircle(rightEarCenter, earRadius * 0.6, innerEarPaint);
    canvas.drawCircle(leftEarCenter, earRadius * 0.6, outline);
    canvas.drawCircle(rightEarCenter, earRadius * 0.6, outline);

    // 🎨 Yüz (ön planda)
    final facePaint = Paint()..color = faceColor;
    canvas.drawCircle(center, headRadius, facePaint);
    canvas.drawCircle(center, headRadius, outline);

    // Burun arka planı
    final noseBgPaint = Paint()..color = noseBgColor;
    canvas.drawOval(
      Rect.fromCircle(center: Offset(center.dx, center.dy + headRadius * 0.2), radius: headRadius * 0.45),
      noseBgPaint,
    );
    canvas.drawOval(
      Rect.fromCircle(center: Offset(center.dx, center.dy + headRadius * 0.2), radius: headRadius * 0.45),
      outline,
    );

    // Burun
    final nosePaint = Paint()..color = noseColor;
    final nose = Path()
      ..moveTo(center.dx, center.dy)
      ..relativeLineTo(-10, 10)
      ..relativeLineTo(20, 0)
      ..close();
    canvas.drawPath(nose, nosePaint);
    canvas.drawPath(nose, outline);

    // Gözler
    final eyePaint = Paint()..color = Colors.black;
    final eyeOffsetY = center.dy - headRadius * 0.2;
    final eyeOffsetX = headRadius * 0.3;
    canvas.drawCircle(Offset(center.dx - eyeOffsetX, eyeOffsetY), 10, eyePaint);
    canvas.drawCircle(Offset(center.dx + eyeOffsetX, eyeOffsetY), 10, eyePaint);

    // Numara yazıları
    final drawText = (String text, Offset offset) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, offset);
    };

    drawText("6", Offset(center.dx - 100, center.dy - 10)); // yüz
    drawText("0", Offset(leftEarCenter.dx - 50, leftEarCenter.dy - 10)); // sol kulak
    drawText("0", Offset(rightEarCenter.dx + 40, rightEarCenter.dy - 10)); // sağ kulak
    drawText("9", Offset(leftEarCenter.dx - 9, leftEarCenter.dy - 25)); // sol kulak içi
    drawText("9", Offset(rightEarCenter.dx - 2, rightEarCenter.dy - 25)); // sağ kulak içi
    drawText("8", Offset(center.dx - 5, center.dy + headRadius * 0.2 - 10)); // burun arka plan
  }

  @override
  bool shouldRepaint(covariant CuteBearPainter oldDelegate) {
    return oldDelegate.faceColor != faceColor ||
        oldDelegate.earColor != earColor ||
        oldDelegate.innerEarColor != innerEarColor ||
        oldDelegate.noseColor != noseColor ||
        oldDelegate.noseBgColor != noseBgColor;
  }
}
