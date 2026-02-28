import 'package:flutter/cupertino.dart';

class MevsimViewModel extends ChangeNotifier{
  int totalClicks = 0;
  final int correctClicks = 1;
  bool iskontrol = false;

  void kontrol(String path, String mevsim){
    totalClicks++;
    if(path == mevsim){
      iskontrol = true;
    }else{
      iskontrol=false;
    }
    notifyListeners();
  }
  void reset(){
    totalClicks = 0;
    notifyListeners();
  }
}