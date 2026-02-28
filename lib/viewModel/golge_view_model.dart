import 'package:flutter/material.dart';

class GolgeOyunViewModel extends ChangeNotifier {
  final Map<String, String> _matches = {};
  final List<String> _remainingShapes = ['tavsan', 'ayi', 'civciv'];
  bool _shouldNavigateNext = false;

  List<String> get remainingShapes => _remainingShapes;
  bool isMatched(String target) => _matches.containsKey(target);
  bool get shouldNavigateNext => _shouldNavigateNext;

  void checkMatch(String dragged, String target) {
    if (dragged == target) {
      _matches[target] = dragged;
      _remainingShapes.remove(dragged);
      notifyListeners();

      // ✅ Tüm eşleşmeler tamamlandıysa
      if (_remainingShapes.isEmpty) {
        _shouldNavigateNext = true;
        notifyListeners();
      }
    }
  }

  void consumeNavigateNext() {
    _shouldNavigateNext = false;
  }
}

