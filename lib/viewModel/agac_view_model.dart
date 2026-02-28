import 'dart:math';
import 'package:flutter/material.dart';

class agacViewModel extends ChangeNotifier {
  int totalClicks = 0;
  final int correctClicks = 5;
  late List<String> textlist ;
  late String hedefHarf; // hangi harfi toplayacağız
  List<bool> visibleList = []; // hangi butonlar görünür
  List<String> _basket = [];
  List<String> get basket => _basket;

  // Listeyi ve hedef harfi dışarıdan al
  void setTextList(List<String> harfler, String harf) {
    textlist = List<String>.from(harfler); // kopya oluştur
    textlist.shuffle(Random()); // karıştır
    hedefHarf = harf.toLowerCase(); // hedef harfi ayarla

    visibleList = List<bool>.filled(textlist.length, true); // hepsi görünür
    _basket.clear();

    notifyListeners();
  }

  // Doğru harfe tıklanırsa kaybolsun
  void addIfMatch(int index) {
    if (textlist[index].toLowerCase() == hedefHarf && visibleList[index]) {
      visibleList[index] = false;
      _basket.add(textlist[index]);
      notifyListeners();
    }
    totalClicks++;
  }
}