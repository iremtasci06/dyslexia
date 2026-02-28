import 'package:flutter/material.dart';
import '../view/ortak_bosluk/yonerge.dart';
import '../view/play_views/hikaye_sirala_view.dart';

class GolgeOyunViewModel extends ChangeNotifier {
  final Map<String, String> _matches = {};
  final List<String> _remainingShapes = ['tavsan', 'ayi', 'civciv'];

  List<String> get remainingShapes => _remainingShapes;
  bool isMatched(String target) => _matches.containsKey(target);

  void checkMatch(String dragged, String target, BuildContext context) {
    if (dragged == target) {
      _matches[target] = dragged;
      _remainingShapes.remove(dragged);
      notifyListeners();

      // ✅ Tüm eşleşmeler tamamlandıysa
      if (_remainingShapes.isEmpty) {
        Future.delayed(const Duration(milliseconds: 800), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Yonerge(text: 'Hikayeyi sırala', page:  HikayeSiralaPage())),
          );
        });
      }
    }
  }
}

