import 'package:flutter/material.dart';
import 'tts_view_model.dart';

class LetterQuizViewModel extends ChangeNotifier {
  int totalClicks = 0;
  int correctClicks = 0; // Doğru tıklamaları sayacak

  final TtsViewModel tts;
  LetterQuizViewModel(this.tts) {
    _remainingLetters = List.from(letters);
    generateQuestion();
  }

  final List<String> letters = ["R", "V", "F", "Y", "L"];
  late List<String> _remainingLetters; // Kalan harfler
  late String currentLetter;
  List<String> options = [];
  String feedback = "";
  bool isFinished = false;

  void generateQuestion() {
    if (_remainingLetters.isEmpty) {
      isFinished = true;
      feedback = "Tebrikler! Oyun bitti.";
      notifyListeners();
      return;
    }

    currentLetter = _remainingLetters.removeAt(0);

    options = [currentLetter];
    final otherLetters = letters.where((l) => l != currentLetter).toList();
    otherLetters.shuffle();
    options.addAll(otherLetters.take(2));
    options.shuffle();

    feedback = "";
    notifyListeners();
  }

  void checkAnswer(String selected) {
    totalClicks++;

    if (selected == currentLetter) {
      correctClicks++; // Sadece doğru ise artır
      feedback = "Doğru! $currentLetter harfini duydun";
    } else {
      feedback = "Yanlış! Doğru cevap: $currentLetter";
    }

    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      generateQuestion();
    });
  }

  void playLetter() {
    if (!isFinished) tts.speak(currentLetter);
  }

  void reset() {
    totalClicks = 0;
    correctClicks = 0; // resetle
    _remainingLetters = List.from(letters);
    isFinished = false;
    generateQuestion();
  }
}
