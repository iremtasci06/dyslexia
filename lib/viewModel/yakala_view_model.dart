import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class YakalaViewModel extends ChangeNotifier {
  int score = 0;
  int timeLeft = 30;
  int pandaIndex = -1;
  bool isGameOver = false;

  final Random _random = Random();
  Timer? _gameTimer;
  Timer? _moveTimer;

  void startGame() {
    score = 0;
    timeLeft = 30;
    isGameOver = false;

    // 8 kare olduğu için 0-7 arası index seçiliyor
    _moveTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      pandaIndex = _random.nextInt(8);
      notifyListeners();
    });

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timeLeft > 0) {
        timeLeft--;
        notifyListeners();
      } else {
        stopGame();
      }
    });
  }

  void hitPanda() {
    score++;
    pandaIndex = _random.nextInt(8);
    notifyListeners();
  }

  void stopGame() {
    _gameTimer?.cancel();
    _moveTimer?.cancel();
    isGameOver = true;

    notifyListeners();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _moveTimer?.cancel();
    super.dispose();
  }
}
