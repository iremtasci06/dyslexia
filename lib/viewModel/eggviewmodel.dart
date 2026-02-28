import 'base_game_view_model.dart';

class EggInputViewModel extends BaseGameViewModel {
  EggInputViewModel() : super(correctClicks: 1);

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
