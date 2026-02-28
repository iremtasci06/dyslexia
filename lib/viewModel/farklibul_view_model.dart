import 'base_game_view_model.dart';

class FarkliBulViewModel extends BaseGameViewModel {
  FarkliBulViewModel() : super(correctClicks: 1);

  bool isCorrect = false;

  bool kontrolEt(String imagepath, String harf) {
    incrementTotalClicks();
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
