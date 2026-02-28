import 'package:flutter/cupertino.dart';

class FarkliBulViewModel extends ChangeNotifier {
  int totalClicks = 0;
  final int correctClicks = 1;

  bool isCorrect = false;

  bool kontrolEt(String imagepath, String harf) {
    totalClicks++;
    if (imagepath == harf) {
      isCorrect = true;
    } else {
      isCorrect = false;
    }
    notifyListeners();
    return isCorrect; // <-- artık bool dönüyor
  }
  void reset(){
    totalClicks=0;
  }
}
