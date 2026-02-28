import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class LeftRightViewModel extends ChangeNotifier {
  double _targetPosition = 300.0;
  final double _boxWidth = 100.0;
  final double _moveStep = 50.0;
  double _characterPosition = 50.0;
  String _storyText = "Karakter bal kavanozuna ulaşmak istiyor!";
  int sayac = 0;

  VoidCallback? onGameCompleted;


  bool _storyStepCompleted = false;
  double get characterPosition => _characterPosition;
  double get targetPosition => _targetPosition;
  String get storyText => _storyText;
  double get boxWidth => _boxWidth;

  void moveRight(double maxPosition) {
    _characterPosition = (_characterPosition + _moveStep).clamp(0.0, maxPosition);
    _checkStoryStep(maxPosition);
    notifyListeners();
  }

  void moveLeft() {
    _characterPosition = (_characterPosition - _moveStep).clamp(0.0, double.infinity);
    _checkStoryStep(null);
    notifyListeners();
  }

  void _checkStoryStep(double? maxPosition) {
    if ((_characterPosition - _targetPosition).abs() < 10 && sayac < 3) {
      sayac++;
      _storyText = "Tebrikler! Karakter bal kavanozuna ulaştı 🍯";

      if (maxPosition != null) {
        final random = Random();
        _targetPosition = (50 + (maxPosition - 50) * random.nextDouble())
            .clamp(50.0, maxPosition);
      }

      notifyListeners();

      if(sayac == 3){
        _storyText = "Oyun bitti! 🏆";
        if (onGameCompleted != null) {
          onGameCompleted!(); // callback ile sayfa geçişi
        }
      }
    }
  }

}
