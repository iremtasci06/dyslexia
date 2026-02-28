import 'base_game_view_model.dart';

class MevsimViewModel extends BaseGameViewModel {
  MevsimViewModel() : super(correctClicks: 1);

  bool iskontrol = false;

  void kontrol(String path, String mevsim){
    incrementTotalClicks();
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