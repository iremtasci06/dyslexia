import 'dart:math';
import 'package:disleksi_surum/view/play_views/yakala_view.dart';
import 'package:flutter/material.dart';
import '../view/ortak_bosluk/yonerge.dart';

class HikayeSiralaViewModel extends ChangeNotifier {
  final List<String> correctOrder = ["ilksahne", "ikincisahne", "ucuncusahne"];

  List<String?> placedImages = [null, null, null];
  List<String> remainingImages = [];

  HikayeSiralaViewModel() {
    _shuffleImages();
  }

  /// 🔀 Görselleri rastgele karıştır
  void _shuffleImages() {
    remainingImages = List.from(correctOrder); // yeni liste oluştur
    remainingImages.shuffle(Random()); // Random seed ile karıştır
    notifyListeners();
  }

  void placeImage(int index, String image, BuildContext context) {
    if (placedImages[index] == null) {
      placedImages[index] = image;
      remainingImages.remove(image);
      notifyListeners();

      // Eğer tüm kutular dolduysa kontrol et
      if (!placedImages.contains(null)) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (_isCorrectOrder()) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Yonerge(
                  text: 'Sincapı yakala',
                  page: const YakalamaGame(),
                ),
              ),
            );
          } else {
            _showTryAgainDialog(context);
          }
        });
      }
    }
  }

  bool _isCorrectOrder() {
    for (int i = 0; i < correctOrder.length; i++) {
      if (placedImages[i] != correctOrder[i]) return false;
    }
    return true;
  }

  void _showTryAgainDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Yanlış sıra 😢"),
        content: const Text("Sahneleri doğru sırayla dizmeyi dene."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text("Tekrar Dene"),
          ),
        ],
      ),
    );
  }

  /// 🔁 Oyunu sıfırla
  void resetGame() {
    placedImages = [null, null, null];
    _shuffleImages(); // tekrar karıştır
  }
}
