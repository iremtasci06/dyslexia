import 'dart:math';
import 'package:flutter/material.dart';

class BalonViewModel extends ChangeNotifier {
  int totalClicks = 0;
  final int correctClicks = 6;
  late List<String> harfler;
  late List<String> tablo;
  late List<Color?> renkler;

  late String hedefHarf;
  int _ballon = 6;
  int get ballon => _ballon;

  bool showBalloon = false;
  double balloonY = 1.0;

  int toplamHarf = 0;
  int bulunanHarf = 0;

  // 🔹 Liste ve hedef harfi View'dan al
  void setGame(List<String> gelenHarfler, String hedef) {
    hedefHarf = hedef.toUpperCase();
    harfler = gelenHarfler.map((e) => e.toUpperCase()).toList();

    _initGame();
    notifyListeners();
  }

  void _initGame() {
    tablo = [...harfler, ...harfler]; // çiftlenmiş tablo
    tablo.shuffle(Random());
    renkler = List.filled(tablo.length, null);

    toplamHarf = tablo.where((h) => h == hedefHarf).length;
    bulunanHarf = 0;
    _ballon = 6;
  }

  void resetGame() {
    _initGame();
    notifyListeners();
  }

  void kontrolEt(int index, BuildContext context) {
    if (tablo[index] == hedefHarf) {
      if (renkler[index] != Colors.green) {
        bulunanHarf++;
        renkler[index] = Colors.green;
        _ballon--;
        notifyListeners();

        // 🎈 Balon animasyonu
        showBalloon = true;
        balloonY = 1.0;
        notifyListeners();

        Future.delayed(const Duration(milliseconds: 50), () {
          balloonY = -1.2;
          notifyListeners();
        });

        Future.delayed(const Duration(seconds: 3), () {
          showBalloon = false;
          notifyListeners();
        });

        // ✅ Tüm hedef harfler bulundu mu?
        if (bulunanHarf == toplamHarf) {
          Future.delayed(const Duration(milliseconds: 500), () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Tebrikler 🎉"),
                content: Text("Tüm $hedefHarf harflerini buldun!"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      resetGame();
                    },
                    child: const Text("Yeniden Oyna"),
                  )
                ],
              ),
            );
          });
        }
      }
    } else {
      renkler[index] = Colors.red;
      notifyListeners();

      // ❌ Balonlar bitti mi?
      if (_ballon <= 0) {
        Future.delayed(const Duration(milliseconds: 500), () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Oyun Bitti 😢"),
              content: const Text("Tüm balonların bitti."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    resetGame();
                  },
                  child: const Text("Tekrar Dene"),
                )
              ],
            ),
          );
        });
      }
    }
    totalClicks++;
  }
}
