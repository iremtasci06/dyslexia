import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class GameViewModel extends ChangeNotifier {
  final List<String> allLetters = ['b', 'p', 'd', 'g', 'y', 'c', 'n', 'u'];
  final Random _random = Random();

  // Harf şeridi
  List<_MovingLetter> movingLetters = [];

  // Araba pozisyonları
  double playerCar = 0.0;

  // Oyun durumu
  bool gameOver = false;

  // Zamanlayıcı
  Timer? moveTimer;
  double letterSpeed = 0.8; // Harflerin hızı (ve botun hızı)

  // Bitiş çizgisi X koordinatı
  double finishLine = 640; // isteğe göre ileride

  // Oyun sonucu callback
  VoidCallback? onPlayerWin;
  VoidCallback? onBotWin;

  GameViewModel({this.onPlayerWin, this.onBotWin}) {
    _initGame();
  }

  void _initGame() {
    movingLetters = List.generate(8, (i) {
      return _MovingLetter(
        id: UniqueKey().toString(),
        letter: allLetters[_random.nextInt(allLetters.length)],
        x: 300.0 + i * 100,
      );
    });

    // Harf kayışı + bot ilerlemesi
    moveTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (gameOver) return;

      for (var letter in movingLetters) {
        letter.x -= letterSpeed; // harfler kayıyor
      }


      // Soldan çıkan harfi sil, sağa yeni ekle
      if (movingLetters.isNotEmpty && movingLetters.first.x < -60) {
        movingLetters.removeAt(0);
        movingLetters.add(_MovingLetter(
          id: UniqueKey().toString(),
          letter: allLetters[_random.nextInt(allLetters.length)],
          x: movingLetters.isNotEmpty ? movingLetters.last.x + 100 : 300,
        ));
      }

      _checkFinish();
      notifyListeners();
    });
  }

  void onLetterPressed(String letter) {
    if (gameOver) return;

    final candidates = movingLetters
        .where((l) => l.letter == letter && l.color == Colors.black)
        .toList();

    if (candidates.isNotEmpty) {
      candidates.sort((a, b) => a.x.compareTo(b.x));
      final target = candidates.first;

      target.color = AppColors.peach; // kalıcı turuncu

      playerCar += (30+letterSpeed / 3); // daha yavaş ve kontrollü
      if (playerCar > finishLine) playerCar = finishLine;

      _checkFinish();
      notifyListeners();
    }
  }

  void _checkFinish() {
    if (playerCar >= finishLine) {
      gameOver = true;
      moveTimer?.cancel();
      if (onPlayerWin != null) onPlayerWin!();
    }
  }

  void restartGame() {
    playerCar = 0.0;
    gameOver = false;
    _initGame();
    notifyListeners();
  }

  @override
  void dispose() {
    moveTimer?.cancel();
    super.dispose();
  }
}

class _MovingLetter {
  String id;
  String letter;
  double x;
  Color color;

  _MovingLetter({
    required this.id,
    required this.letter,
    required this.x,
    this.color = Colors.black,  });
}