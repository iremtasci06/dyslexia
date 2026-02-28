import 'dart:math';
import 'base_game_view_model.dart';

class SecViewModel extends BaseGameViewModel {
  SecViewModel() : super(correctClicks: 1) {
    karistir(); // ilk başta karıştır
  }

  String harf = 'D';
  bool dogru = false;
  List<String> secenekler = [];

  void DKontrol(String secilenHarf) {
    incrementTotalClicks();
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