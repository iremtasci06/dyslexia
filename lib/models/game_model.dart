class GameResult {
  final int totalClicks;
  final int correctClicks;
  final int durationseconds;

  GameResult({
    required this.totalClicks,
    required this.correctClicks,
    required this.durationseconds,
  });

  int get wrongClicks => totalClicks - correctClicks;
  double get accuracy => totalClicks > 0 ? correctClicks / totalClicks : 0;

  Map<String, dynamic> toMap() {
    return {
      'totalClicks': totalClicks,
      'correctClicks': correctClicks,
      'wrongClicks': wrongClicks,
      'accuracy': accuracy,
      'durationseconds': durationseconds,
    };
  }
}
