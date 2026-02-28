import 'dart:math';
import 'package:flutter/material.dart';

class HikayeSiralaViewModel extends ChangeNotifier {
  final List<String> correctOrder = ["ilksahne", "ikincisahne", "ucuncusahne"];

  List<String?> placedImages = [null, null, null];
  List<String> remainingImages = [];
  bool _shouldNavigateNext = false;
  bool _shouldShowTryAgain = false;

  bool get shouldNavigateNext => _shouldNavigateNext;
  bool get shouldShowTryAgain => _shouldShowTryAgain;

  HikayeSiralaViewModel() {
    _shuffleImages();
  }

  /// 🔀 Görselleri rastgele karıştır
  void _shuffleImages() {
    remainingImages = List.from(correctOrder); // yeni liste oluştur
    remainingImages.shuffle(Random()); // Random seed ile karıştır
    notifyListeners();
  }

  void placeImage(int index, String image) {
    if (placedImages[index] == null) {
      placedImages[index] = image;
      remainingImages.remove(image);
      notifyListeners();

      // Eğer tüm kutular dolduysa kontrol et
      if (!placedImages.contains(null)) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (_isCorrectOrder()) {
            _shouldNavigateNext = true;
            notifyListeners();
          } else {
            _shouldShowTryAgain = true;
            notifyListeners();
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

  /// 🔁 Oyunu sıfırla
  void resetGame() {
    placedImages = [null, null, null];
    _shuffleImages(); // tekrar karıştır
  }

  void consumeNavigateNext() {
    _shouldNavigateNext = false;
  }

  void consumeTryAgainDialog() {
    _shouldShowTryAgain = false;
  }
}
