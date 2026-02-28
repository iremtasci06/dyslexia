import 'package:flutter/foundation.dart';

abstract class BaseGameViewModel extends ChangeNotifier {
  BaseGameViewModel({required this.correctClicks});

  int totalClicks = 0;
  int correctClicks;

  void incrementTotalClicks([int value = 1]) {
    totalClicks += value;
  }

  void incrementCorrectClicks([int value = 1]) {
    correctClicks += value;
  }

  void resetGameCounters({int? correctClicksValue, bool notify = true}) {
    totalClicks = 0;
    if (correctClicksValue != null) {
      correctClicks = correctClicksValue;
    }
    if (notify) {
      notifyListeners();
    }
  }
}