import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';

import '../utils/data.dart';

class SpeechViewModell extends ChangeNotifier {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isInitialized = false;
  bool _isListening = false;
  String _recognizedText = "";
  String _matchedSentence = "";
  List<SentenceData> sentences = [];

  bool get isInitialized => _isInitialized;
  bool get isListening => _isListening;
  String get recognizedText => _recognizedText;
  String get matchedSentence => _matchedSentence;

  int currentIndex = 0;

  String get userAnswer => _recognizedText;

  Future<void> initSpeech() async {
    _isInitialized = await _speech.initialize();
    notifyListeners();
  }

  Future<void> startListening() async {
    if (!_isInitialized) await initSpeech();
    _isListening = true;
    _recognizedText = "";
    notifyListeners();

    _speech.listen(onResult: (result) {
      _recognizedText = result.recognizedWords;
      notifyListeners();
    });
  }
  void stopListening(int totalStories) {
    _speech.stop();
    _isListening = false;
    _findBestMatch();
    notifyListeners();

    if (sentences.isNotEmpty) {
      var currentSentence = sentences[currentIndex].text;
      var isTrue = isCorrect(currentSentence);

      if (isTrue) {
        print("✅ Cümle doğru söylendi, 1 saniye sonra sonrakiye geçiliyor...");
        Future.delayed(const Duration(seconds: 1), () {
          nextSentence(totalStories);
        });
      } else {
        print("❌ Cümle hatalı söylendi, aynı cümlede kalındı.");
      }

      getWrongAndMissingWords(currentSentence);
    }
  }

  bool isProcessing = false;

  void updateRecognizedText(String text, int totalStories, List<SentenceData> stories) {
    _recognizedText = text;   // <-- burada recognizedText değil _recognizedText olmalı
    final currentSentence = stories[currentIndex].text;

    if (isCorrect(currentSentence)) {
      print("✅ Doğru söylendi, sonraki cümleye geçiliyor...");
      Future.delayed(const Duration(seconds: 1), () {
        nextSentence(totalStories);
      });
    } else {
      print("❌ Yanlış söylendi, aynı cümlede kalındı.");
    }

    notifyListeners();
  }
  void nextSentence(int totalStories) {
    if (totalStories == 0) return;
    currentIndex = (currentIndex + 1) % totalStories;
    _recognizedText = ""; // önceki cümle temizlenir
    notifyListeners();
  }

// ✅ En yakın cümleyi bul
  void _findBestMatch() {
    if (sentences.isEmpty) return;

    String normalizedSpeech = _normalizeText(_recognizedText);
    double highestScore = 0;
    String bestMatch = "";

    for (var sentence in sentences) {
      String normalizedSentence = _normalizeText(sentence.text);
      double score = _calculateSimilarity(normalizedSpeech, normalizedSentence);

      if (score > highestScore) {
        highestScore = score;
        bestMatch = sentence.text;
      }

      if (normalizedSpeech == normalizedSentence) {
        bestMatch = sentence.text;
        break;
      }
    }
    _matchedSentence = bestMatch;
  }

  double _calculateSimilarity(String s1, String s2) {
    final words1 = s1.split(' ');
    final words2 = s2.split(' ');

    int matches = 0;
    for (var word in words1) {
      if (words2.contains(word)) matches++;
    }

    return words1.isEmpty ? 0 : matches / words1.length;
  }

  void clearRecognizedText() {
    _recognizedText = '';
    notifyListeners();
  }

  String _normalizeText(String text) {
    if (text.isEmpty) return "";

    String s = text.toLowerCase().trim();

    // Noktalama ve özel karakterleri kaldır
    s = s.replaceAll(RegExp(r'[^\w\sığüşöçİĞÜŞÖÇ]'), '');
    s = s.replaceAll(RegExp(r'\s+'), ' ');

    // Türkçe karakter eşlemeleri (isteğe göre)
    s = s.replaceAll('ı', 'i');
    s = s.replaceAll('ş', 's');
    s = s.replaceAll('ç', 'c');
    s = s.replaceAll('ğ', 'g');
    s = s.replaceAll('ö', 'o');
    s = s.replaceAll('ü', 'u');

    return s;
  }

// Daha güvenli doğru/yanlış kontrol
  bool isCorrect(String targetSentence, {double threshold = 0.8}) {
    final ratio = _calculateWordMatchRatio(_recognizedText, targetSentence);
    return ratio >= threshold;
  }


// Daha adil benzerlik: eşleşen hedef-kelime / hedef-kelime-sayısı
  double _calculateWordMatchRatio(String recognized, String target) {
    final rWords = _normalizeText(recognized).split(' ').where((w) => w.isNotEmpty).toList();
    final tWords = _normalizeText(target).split(' ').where((w) => w.isNotEmpty).toList();

    if (tWords.isEmpty) return 0.0;
    if (rWords.isEmpty) return 0.0;

    int matches = 0;
    for (var w in tWords) {
      // direkt contains veya küçük fuzzy
      if (rWords.contains(w)) {
        matches++;
      } else {
        // küçük fuzzy check: Levenshtein benzeri (basit)
        for (var rw in rWords) {
          if (_simpleTokenSimilarity(rw, w) >= 0.8) {
            matches++;
            break;
          }
        }
      }
    }

    return matches / tWords.length; // hedefe göre oran
  }

// Basit token benzerliği: karakter bazlı oran (0..1)
  double _simpleTokenSimilarity(String a, String b) {
    if (a == b) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    // Levenshtein veya basit ortak karakter oranı
    final minLen = a.length < b.length ? a.length : b.length;
    int common = 0;
    for (int i = 0; i < minLen; i++) {
      if (a[i] == b[i]) common++;
    }
    // normalize
    return common / b.length;
  }
  Map<String, List<String>> getWrongAndMissingWords(String targetSentence) {
    final rWords = _normalizeText(_recognizedText)
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList();
    final tWords = _normalizeText(targetSentence)
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList();

    List<String> missing = [];
    List<String> wrong = [];

    print('---******************************DEBUG: Karşılaştırma Başladı*********************************---');
    print('Kullanıcının söylediği: $rWords');
    print('Hedef cümle: $tWords');

    for (var t in tWords) {
      bool found = false;
      for (var r in rWords) {
        double sim = _simpleTokenSimilarity(r, t);
        print('Checking: hedef="$t" vs söyledi="$r" -> similarity=$sim');
        if (sim >= 0.8) {
          found = true;
          break;
        }
      }
      if (!found) {
        missing.add(t);
        print('Eksik bulundu: $t');
      }
    }

    print('---*******************************************DEBUG: Karşılaştırma Bitti****************************---');
    print('Eksik kelimeler: $missing');
    print('Yanlış kelimeler: $wrong');

    return {'missing': missing, 'wrong': wrong};
  }
}


