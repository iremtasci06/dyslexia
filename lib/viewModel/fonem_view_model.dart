import 'base_game_view_model.dart';

class FonemViewModel extends BaseGameViewModel {
  FonemViewModel() : super(correctClicks: 1);

  bool kontrol = false;
  bool kontrol2=false;

  void Kontrol(String harf, String text) {
    text = text.toLowerCase();
    if (text.startsWith(harf.toLowerCase())) {
      kontrol = true;
    } else {
      kontrol = false;
    }
    incrementTotalClicks();
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
    incrementTotalClicks();
    notifyListeners();
  }
}
