import 'package:flutter/material.dart';

class EggInputViewModel extends ChangeNotifier {
  int totalClicks = 0;
  final int correctClicks = 1;

  bool kontrol=true;

  void SayiKontrol(String imgpath,String sayi){
    if(imgpath == sayi){
      kontrol =true;
    }else{
      kontrol =false;
    }
    notifyListeners();
  }
}
