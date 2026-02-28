import 'dart:math';
import 'package:flutter/cupertino.dart';

class SecViewModel extends ChangeNotifier {
  String harf = 'D';
  bool dogru = false;
  int totalClicks = 0;
  final int correctClicks = 1;
  List<String> secenekler = [];

  SecViewModel() {
    karistir(); // ilk başta karıştır
  }

  void DKontrol(String secilenHarf) {
    totalClicks++;
    dogru = (secilenHarf == harf);
    notifyListeners();
  }

  void karistir() {
    if (harf !='U' && harf !='M' && harf != 'N') {
      if(harf !='B') {
        secenekler = ['B', harf];
      }else{
        secenekler =['P',harf];
      }
    }else if(harf !='P' && harf !='B' && harf != 'D') {
      if(harf !='U'){
        secenekler =['U',harf];
      }else{
        secenekler =['N',harf];
      }
    }
    secenekler.shuffle(Random());
    notifyListeners();
  }

  void reset() {
    dogru = false;
    notifyListeners();
  }
}