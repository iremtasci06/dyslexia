import 'package:flutter/material.dart';
import 'base_game_view_model.dart';

class BearViewModel extends BaseGameViewModel {
  BearViewModel() : super(correctClicks: 4);

  Color faceColor = Colors.white;
  Color earColor = Colors.white;
  Color innerEarColor = Colors.white;
  Color noseColor = Colors.black;
  Color noseBgColor = Colors.white;

  final Map<int, Color> numberColors = {
    6: const Color(0xffB77466), // yüz
    0: const Color(0xffBB6653), // kulak dışı
    8: const Color(0xffE2B59A), // burun arka
    9: const Color(0xffF08FC0), // kulak içi
  };

  int? selectedNumber;

  void selectNumber(int number) {

    selectedNumber = number;
    notifyListeners();
  }

  void handleTap(Offset pos, Size size, VoidCallback onAllColored) {
    incrementTotalClicks();
    if (selectedNumber == null) return;

    final center = Offset(size.width / 2, size.height / 2);
    final headRadius = size.width * 0.35;
    final earRadius = headRadius * 0.4;
    final innerEarRadius = earRadius * 0.6;
    final noseBgRadius = headRadius * 0.45;

    final leftEarCenter =
    Offset(center.dx - headRadius * 0.7, center.dy - headRadius * 0.7);
    final rightEarCenter =
    Offset(center.dx + headRadius * 0.7, center.dy - headRadius * 0.7);
    final noseBgCenter = Offset(center.dx, center.dy + headRadius * 0.2);
    final isInFaceCircle = (pos - center).distance <= headRadius;

    // 🔹 Bölge kontrolü
    final isInLeftEar = (pos - leftEarCenter).distance <= earRadius;
    final isInRightEar = (pos - rightEarCenter).distance <= earRadius;
    final isInEar = isInLeftEar || isInRightEar;

    final isInLeftInnerEar = (pos - leftEarCenter).distance <= innerEarRadius;
    final isInRightInnerEar = (pos - rightEarCenter).distance <= innerEarRadius;
    final isInInnerEar = (isInLeftInnerEar || isInRightInnerEar) && !isInFaceCircle;

    bool isInNoseBg = (pos - noseBgCenter).distance <= noseBgRadius;
    final isInNoseTriangle = _isPointInTriangle(
      pos,
      Offset(center.dx, center.dy),
      Offset(center.dx - 10, center.dy + 10),
      Offset(center.dx + 10, center.dy + 10),
    );
    final isInNoseArea = isInNoseBg || isInNoseTriangle;

    bool isInFace = isInFaceCircle && !isInNoseArea && !isInEar;

    final isInOuterEar = isInEar && !isInInnerEar && !isInFaceCircle;

    if (selectedNumber == 8 && isInNoseArea) {
      noseBgColor = numberColors[8]!;
    } else if (selectedNumber == 6 && isInFace) {
      faceColor = numberColors[6]!;
    } else if (selectedNumber == 0 && isInOuterEar) {
      earColor = numberColors[0]!;
    } else if (selectedNumber == 9 && isInInnerEar) {
      innerEarColor = numberColors[9]!;
    }

    notifyListeners();

    if (_isAllColored()) {
      onAllColored();
    }
  }

  bool _isPointInTriangle(Offset point, Offset p1, Offset p2, Offset p3) {
    final denominator =
        (p2.dy - p3.dy) * (p1.dx - p3.dx) + (p3.dx - p2.dx) * (p1.dy - p3.dy);
    if (denominator == 0) return false;

    final a = ((p2.dy - p3.dy) * (point.dx - p3.dx) +
            (p3.dx - p2.dx) * (point.dy - p3.dy)) /
        denominator;
    final b = ((p3.dy - p1.dy) * (point.dx - p3.dx) +
            (p1.dx - p3.dx) * (point.dy - p3.dy)) /
        denominator;
    final c = 1 - a - b;

    return a >= 0 && b >= 0 && c >= 0;
  }

  bool _isAllColored() {
    return faceColor == numberColors[6]! &&
        earColor == numberColors[0]! &&
        innerEarColor == numberColors[9]! &&
        noseBgColor == numberColors[8]!;
  }
}