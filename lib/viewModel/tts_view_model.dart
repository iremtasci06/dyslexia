import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsViewModel extends ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();

  TtsViewModel() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("tr-TR");
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.2);
  }

  Future<void> speak(String text) async {
    await _flutterTts.stop();
    await _flutterTts.speak(text);
    debugPrint('girdi');
    notifyListeners();
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  void disposeTts() {
    _flutterTts.stop();
  }
}