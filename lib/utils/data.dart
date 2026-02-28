import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class SentenceData {
  final String text;
  final String level; // JSON'daki "id"
  SentenceData({required this.text, required this.level});
}

Future<List<SentenceData>> loadSentencesFromJson() async {
  // JSON dosyasını oku
  final jsonString = await rootBundle.loadString('assets/veriler.json');

  // JSON'u decode et
  final List<dynamic> jsonData = jsonDecode(jsonString);

  final List<SentenceData> sentences = [];

  for (final item in jsonData) {
    final text = item['text']?.toString() ?? '';
    final level = item['id']?.toString() ?? '0';

    if (text.isNotEmpty) {
      sentences.add(SentenceData(text: text, level: level));
    }

    print('Loaded sentence: "$text" | level: "$level"');
  }

  // Listeyi karıştır
  sentences.shuffle(Random());

  return sentences;
}

