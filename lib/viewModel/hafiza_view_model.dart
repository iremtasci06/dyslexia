import 'dart:async';
import 'dart:math';
import 'package:disleksi_surum/view/play_views/game_view.dart';
import 'package:flutter/material.dart';

class HafizaViewModel extends ChangeNotifier {
  late List<String> cards;
  late List<bool> revealed; // açık/kapalı durumu
  List<int> openedIndexes = [];

  int _eslesmeyensayi =0;
  int get eslesmeyensayi => _eslesmeyensayi;
  int _eslesensayi=0;
  int get eslesensayi => _eslesensayi;

  HafizaViewModel() {
    _initGame();
  }

  void _initGame() {
    final gameImages = const [
      'assets/images/hayvanlar/ari.jpeg',
      'assets/images/hayvanlar/bear.jpeg',
      'assets/images/hayvanlar/balik.jpeg',
      'assets/images/hayvanlar/cat.jpeg',
      'assets/images/hayvanlar/chick.jpeg',
      'assets/images/hayvanlar/dog.jpeg',
      'assets/images/hayvanlar/fare.jpeg',
      'assets/images/hayvanlar/inek.jpeg',
      'assets/images/hayvanlar/zebra.jpeg',
      'assets/images/hayvanlar/zurafa.jpeg',
    ];
    cards = [...gameImages, ...gameImages];
    cards.shuffle(Random());
    revealed = List.filled(cards.length, false);
    openedIndexes.clear();
    notifyListeners();
  }

  void onCardTap(int index, BuildContext context) {
    if (revealed[index] || openedIndexes.length == 2) return;

    revealed[index] = true;
    openedIndexes.add(index);
    notifyListeners();

    if (openedIndexes.length == 2) {
      final first = openedIndexes[0];
      final second = openedIndexes[1];

      if (cards[first] == cards[second]) {
        _eslesensayi++;
        notifyListeners();
        // eşleşti → açık kalacak
        openedIndexes.clear();

        // oyun bitti mi?
        if (revealed.every((e) => e)) {
          Future.delayed(const Duration(milliseconds: 500), () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Tebrikler!"),
                content: const Text("Tüm kartları eşleştirdiniz 🎉"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // dialog'u kapat
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GameView(), // hedef sayfa
                        ),
                      );
                    },
                    child: const Text("Sonraki Sayfa"),
                  ),
                ],
              ),
            );
          });
        }

      } else {
        // eşleşmedi → geri kapat
        Future.delayed(const Duration(seconds: 1), () {
          revealed[first] = false;
          revealed[second] = false;
          openedIndexes.clear();
          _eslesmeyensayi++;
          notifyListeners();
        });
      }
    }
  }

  void resetGame() {
    _initGame();
  }
}
