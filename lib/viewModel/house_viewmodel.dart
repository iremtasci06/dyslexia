import 'package:flutter/material.dart';

class HouseViewModel extends ChangeNotifier {
  Color wallColor = Colors.white;
  Color roofColor = Colors.white;
  Color doorColor = Colors.white;
  Color treeColor = Colors.white;
  Color windowColor = Colors.white;

  int? selectedNumber;
  int totalClicks = 0;
  int correctClicks = 5;

  final Map<int, Color> numberColors = {
    0: const Color(0xffF75270), // duvar
    8: const Color(0xffEB5B00), // çatı
    3: Colors.amber, // kapı
    2: Colors.lightGreen, // ağaç
    5: const Color(0xff78C841), // pencere
  };

  void selectNumber(int number) {
    totalClicks++;
    selectedNumber = number;
    notifyListeners();
  }

  void handleTap(Offset pos, Size size, VoidCallback onAllColored) {
    final wallRect = Rect.fromLTWH(80, 180, 240, 200);
    final roofPath = Path()
      ..moveTo(200, 80)
      ..lineTo(60, 180)
      ..lineTo(340, 180)
      ..close();
    final doorRect = Rect.fromLTWH(180, 280, 40, 100);
    final treeRect = Rect.fromLTWH(350, 220, 40, 120);
    final windowRect = Rect.fromLTWH(120, 220, 40, 60);

    // 🔹 Duvar alanı = duvar dikdörtgeni içinde ama pencere veya kapıda değilse
    bool isInWall = wallRect.contains(pos) &&
        !doorRect.contains(pos) &&
        !windowRect.contains(pos);

    bool isInRoof = _isPointInPath(pos, roofPath);
    bool isInDoor = doorRect.contains(pos);
    bool isInTree = treeRect.contains(pos);
    bool isInWindow = windowRect.contains(pos);

    if (selectedNumber == 0 && isInWall) {
      wallColor = numberColors[0]!;
    } else if (selectedNumber == 8 && isInRoof) {
      roofColor = numberColors[8]!;
    } else if (selectedNumber == 3 && isInDoor) {
      doorColor = numberColors[3]!;
    } else if (selectedNumber == 2 && isInTree) {
      treeColor = numberColors[2]!;
    } else if (selectedNumber == 5 && isInWindow) {
      windowColor = numberColors[5]!;
    }

    notifyListeners();

    if (_isAllColored()) onAllColored();
  }

  bool _isAllColored() {
    return wallColor == numberColors[0]! &&
        roofColor == numberColors[8]! &&
        doorColor == numberColors[3]! &&
        treeColor == numberColors[2]! &&
        windowColor == numberColors[5]!;
  }

  bool _isPointInPath(Offset point, Path path) {
    // Üçgen çatı için point-in-polygon kontrolü
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      final subPath = metric.extractPath(0, metric.length);
      if (subPath.getBounds().contains(point)) {
        final region = Path()
          ..addPath(subPath, Offset.zero)
          ..close();
        if (region.contains(point)) return true;
      }
    }
    return false;
  }
}