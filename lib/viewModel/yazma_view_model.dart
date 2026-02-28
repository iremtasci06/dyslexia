import 'package:flutter/material.dart';

class LetterTraceViewModel extends ChangeNotifier {
  List<Offset> points = [];
  Color selectedColor = Colors.black;

  void addPoint(Offset point) {
    points = List.from(points)..add(point);
    notifyListeners();
  }

  void endStroke() {
    points.add(Offset.zero);
    notifyListeners();
  }

  void clear() {
    points.clear();
    notifyListeners();
  }

  void changeColor(Color color) {
    selectedColor = color;
    notifyListeners();
  }
}
