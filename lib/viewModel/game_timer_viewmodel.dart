import 'package:flutter/material.dart';

class GameTimerViewModel extends ChangeNotifier {
  int totalSeconds = 0;
  bool _isRunning = false;

  void startTimer() {
    _isRunning = true;
    Future.doWhile(() async {
      if (!_isRunning) return false;
      await Future.delayed(const Duration(seconds: 1));
      totalSeconds++;
      notifyListeners();
      return true;
    });
  }

  void stopTimer() {
    _isRunning = false;
  }

  String get formattedTime {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2,'0')}:${seconds.toString().padLeft(2,'0')}';
  }

  void reset() {
    totalSeconds = 0;
  }
}
