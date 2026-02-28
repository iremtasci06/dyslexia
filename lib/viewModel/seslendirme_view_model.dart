import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechViewModel extends ChangeNotifier {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;
  String _recognizedText = "";
  bool isFinished = false;

  bool get isListening => _isListening;
  String get recognizedText => _recognizedText;

  List<String> sentences = [];
  int currentIndex = 0;
  int currentCount = 0;
  final int maxSentences = 5;

  int totalClicks = 0;     // toplam konuşulan kelime sayısı (tüm cümlelerde)
  int correctClicks = 0;   // toplam doğru kelime sayısı (tüm cümlelerde)

  DateTime? sentenceStartTime;

  /// 🔹 Konuşma tanıma sistemini başlat
  Future<void> initSpeech() async {
    await _speech.initialize();
  }

  /// 🔹 Dinlemeyi başlat
  Future<void> startListening() async {
    if (!_speech.isAvailable) return;

    _isListening = true;
    _recognizedText = "";
    sentenceStartTime ??= DateTime.now();
    notifyListeners();

    await _speech.listen(
      onResult: (result) {
        _recognizedText = result.recognizedWords;

        if (_recognizedText.isNotEmpty) {
          final spokenCount = _recognizedText.trim().split(RegExp(r'\s+')).length;
          totalClicks = spokenCount;
        }

        if (result.finalResult) _isListening = false;
        notifyListeners();
      },
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        listenMode: stt.ListenMode.dictation,
      ),
    );
  }

  /// 🔹 Dinlemeyi durdur
  Future<void> stopListening() async {
    await _speech.stop();
    _isListening = false;
    notifyListeners();
  }

  /// 🔹 Şu anki hedef cümle
  String get currentSentence => sentences.isEmpty ? "" : sentences[currentIndex];

  /// 🔹 Cümledeki yanlış kelimeleri bul
  List<String> getWrongWords() {
    if (_recognizedText.isEmpty) return [];

    String normalize(String s) => s
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\sğüşöçıİĞÜŞÖÇ]'), '')
        .replaceAll(RegExp(r'\d'), '');

    final target = normalize(currentSentence).split(' ');
    final said = normalize(_recognizedText).split(' ');

    return target.where((word) => !said.contains(word)).toList();
  }

  /// 🔹 Şu anki cümlenin sonuçlarını hesapla ve döndür
  Map<String, dynamic> getCurrentResult() {
    final wrongCount = getWrongWords().length;
    final correctNow = (totalClicks - wrongCount).clamp(0, totalClicks);
    final duration =
        DateTime.now().difference(sentenceStartTime ?? DateTime.now()).inSeconds;

    return {
      'sentence': currentSentence,
      'spokenWords': totalClicks,
      'correctWords': correctNow,
      'wrongWords': wrongCount,
      'durationSeconds': duration,
    };
  }

  void nextSentence() {
    if (isFinished || sentences.isEmpty) return;

    final result = getCurrentResult();
    correctClicks += result['correctWords'] as int;

    currentCount++;
    if (currentCount >= maxSentences) {
      isFinished = true;
    } else {
      currentIndex = (currentIndex + 1) % sentences.length;
      _recognizedText = "";
      sentenceStartTime = DateTime.now();
    }

    notifyListeners();
  }

  void checkSpeech() {
    if (_recognizedText.isEmpty) return;
    notifyListeners();
  }

  void reset() {
    _recognizedText = "";
    currentIndex = 0;
    currentCount = 0;
    isFinished = false;
    totalClicks = 0;
    correctClicks = 0;
    sentenceStartTime = null;
    notifyListeners();
  }
}
