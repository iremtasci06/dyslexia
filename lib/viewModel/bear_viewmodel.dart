import 'package:flutter/material.dart';

class BearViewModel extends ChangeNotifier {
  Color faceColor = Colors.white;
  Color earColor = Colors.white;
  Color innerEarColor = Colors.white;
  Color noseColor = Colors.black;
  Color noseBgColor = Colors.white;

  int totalClicks = 0;
  final int correctClicks = 4;

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
    totalClicks++;
    if (selectedNumber == null) return;

    final center = Offset(size.width / 2, size.height / 2);
    final headRadius = size.width * 0.35;
    final earRadius = headRadius * 0.4;
    final innerEarRadius = earRadius * 0.9;
    final noseBgRadius = headRadius * 0.45;

    final leftEarCenter =
    Offset(center.dx - headRadius * 0.7, center.dy - headRadius * 0.7);
    final rightEarCenter =
    Offset(center.dx + headRadius * 0.7, center.dy - headRadius * 0.7);
    final noseBgCenter = Offset(center.dx, center.dy + headRadius * 0.2);

    // 🔹 Bölge kontrolü
    bool isInFace = (pos - center).distance <= headRadius &&
        (pos - noseBgCenter).distance > noseBgRadius; // 8 hariç
    bool isInEar = ((pos - leftEarCenter).distance <= earRadius * 1.3 ||
        (pos - rightEarCenter).distance <= earRadius * 1.3);
    bool isInInnerEar = ((pos - leftEarCenter).distance <= innerEarRadius ||
        (pos - rightEarCenter).distance <= innerEarRadius);
    bool isInNoseBg = (pos - noseBgCenter).distance <= noseBgRadius;

    if (selectedNumber == 8 && isInNoseBg) {
      noseBgColor = numberColors[8]!;
    } else if (selectedNumber == 6 && isInFace) {
      faceColor = numberColors[6]!;
    } else if (selectedNumber == 0 && isInEar) {
      earColor = numberColors[0]!;
    } else if (selectedNumber == 9 && isInInnerEar) {
      innerEarColor = numberColors[9]!;
    }

    notifyListeners();

    if (_isAllColored()) {
      onAllColored();
    }
  }

  bool _isAllColored() {
    return faceColor == numberColors[6]! &&
        earColor == numberColors[0]! &&
        innerEarColor == numberColors[9]! &&
        noseBgColor == numberColors[8]!;
  }
}