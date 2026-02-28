import 'package:flutter/cupertino.dart';

class FonemViewModel extends ChangeNotifier {
  int totalClicks = 0;
  final int correctClicks = 1;
  bool kontrol = false;
  bool kontrol2=false;

  void Kontrol(String harf, String text) {
    text = text.toLowerCase();
    if (text.startsWith(harf.toLowerCase())) {
      kontrol = true;
    } else {
      kontrol = false;
    }
    totalClicks++;
    notifyListeners();
  }
  void Kontrol2(String harf, String text) {
    text = text.toLowerCase();
    if (text.contains(harf.toLowerCase())) {
      kontrol2=true;
    }
    else{
      kontrol2=false;
    }
    totalClicks++;
    notifyListeners();
  }
}
