import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ActivityCard {
  final String title;
  final TimeCategory category;


  ActivityCard(this.title, this.category);
}

enum TimeCategory { YESTERDAY, TODAY, TOMORROW }

class TimeTrainViewModel with ChangeNotifier {
  final FlutterTts tts = FlutterTts();
  TimeCategory currentFocus = TimeCategory.TODAY;
  int totalClicks = 0;
  final int correctClicks = 7;

  bool hasNavigated = false;

  List<ActivityCard> allActivities = [
    ActivityCard("Parkta oynadım", TimeCategory.YESTERDAY),
    ActivityCard("Oyun oynuyorum.", TimeCategory.TODAY),
    ActivityCard("Okula gideceğim", TimeCategory.TOMORROW),
    ActivityCard("Süt içeceğim.",  TimeCategory.TOMORROW),
    ActivityCard("Kitap okuyorum.",  TimeCategory.TODAY),
    ActivityCard("Bahçeye çıkacağım.",  TimeCategory.TOMORROW),
    ActivityCard("Yemek yedim.",  TimeCategory.YESTERDAY),
  ];

  List<ActivityCard> draggableCards = [];
  List<ActivityCard> placedYesterday = [];
  List<ActivityCard> placedToday = [];
  List<ActivityCard> placedTomorrow = [];

  TimeTrainViewModel() {
    _initTts();
    draggableCards = List.from(allActivities)..shuffle();
  }

  void _initTts() {
    tts.setLanguage("tr-TR");
  }

  Future<void> speak(String text) async {
    await tts.stop();
    await tts.speak(text);
  }

  void moveTrain(TimeCategory newFocus) {
    currentFocus = newFocus;
    notifyListeners();

    switch (newFocus) {
      case TimeCategory.YESTERDAY:
        speak("Dün, geçmişte yaşadığın olaylardır.");
        break;
      case TimeCategory.TODAY:
        speak("Bugün, şu an yaşadığın zamandır.");
        break;
      case TimeCategory.TOMORROW:
        speak("Yarın, henüz gelmeyen zamandır.");
        break;
    }
  }

  bool handleCardDrop(ActivityCard card, TimeCategory targetVagon) {

    if (card.category == targetVagon) {
      draggableCards.remove(card);
      switch (targetVagon) {
        case TimeCategory.YESTERDAY:
          placedYesterday.add(card);
          totalClicks++;
          break;
        case TimeCategory.TODAY:
          placedToday.add(card);
          totalClicks++;
          break;
        case TimeCategory.TOMORROW:
          placedTomorrow.add(card);
          totalClicks++;
          break;
      }

      speak("Harika! Bu kartı doğru yere koydun.");
      notifyListeners();
      return true;
    } else {
      speak("Tekrar dene! Bu etkinlik yanlış vagona ait.");
      return false;
    }
  }
  void reset(){
    totalClicks = 0;
  }

  bool get isGameComplete => draggableCards.isEmpty;
}
