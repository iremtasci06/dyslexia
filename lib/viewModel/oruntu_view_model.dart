import 'package:flutter/material.dart';

class IqTestViewModel extends ChangeNotifier {
  int score = 0;
  String? selected;
  final String correctAnswer = 'tavsan';

  // Seçim yapıldığında kontrol
  bool isCorrect(String label) => label == correctAnswer;
}