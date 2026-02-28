import 'package:disleksi_surum/view/sayilar/sayi_menu_view.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:provider/provider.dart';
import '../../viewModel/game_result_viewmodel.dart';
import '../../viewModel/game_timer_viewmodel.dart';

const TextStyle _kDyslexicTextStyle = TextStyle(
  fontFamily: 'OpenDyslexic',
  fontSize: 80,
  fontWeight: FontWeight.w900,
  color: Colors.black,
);

class RapidRecognitionScreen extends StatefulWidget {
  @override
  _RapidRecognitionScreenState createState() => _RapidRecognitionScreenState();
}

class _RapidRecognitionScreenState extends State<RapidRecognitionScreen> {

  // Ayarlar
  final int _flashDurationMs = 1000; // Flaş gösterim süresi (milisaniye)
  int totalClicks = 0;
  final int correctClicks = 1;
  // Durum Yönetimi
  int _targetNumber = 21;
  late int _reversedNumber;
  List<int> _options = [];
  bool _isFlashing = true; // Şu anda flaş kart gösteriliyor mu?
  String _message = 'Gözünü Aç!';
  int sayac = 0;

  @override
  void initState() {
    super.initState();
    _setNewGame();
    // Timer başlat
    final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
    timerVM.reset();
    timerVM.startTimer();
  }

  int _reverseNumber(int number) {
    if (number < 10 || number > 99) return number; // Sadece iki basamaklılar
    int tens = number ~/ 10;
    int units = number % 10;
    return (units * 10) + tens;
  }

  void _setNewGame() {
    totalClicks = 0;
    sayac++;
    if (sayac == 5){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>  MenuViewSayi(),
        ),
      );
    }

    _targetNumber = Random().nextInt(90) + 10;

    _reversedNumber = _reverseNumber(_targetNumber);

    _options = [_targetNumber, _reversedNumber];

    // 4 seçenek olana kadar rastgele dikkat dağıtıcı sayılar ekle
    while (_options.length < 4) {
      int distractor = Random().nextInt(90) + 10; // 10–99 arası
      int reversedDistractor = _reverseNumber(distractor);

      // Ne hedefin, ne tersinin aynısı olmalı
      if (!_options.contains(distractor) &&
          distractor != _targetNumber &&
          distractor != _reversedNumber &&
          reversedDistractor != _targetNumber &&
          reversedDistractor != _reversedNumber) {
        _options.add(distractor);
      }
    }

    // Seçenekleri karıştır
    _options.shuffle();

    // Flash modunu başlat
    setState(() {
      _isFlashing = true;
      _message = 'Gözünü Aç!';
    });

    // Süre dolunca flash modunu kapat
    Timer(Duration(milliseconds: _flashDurationMs), () {
      setState(() {
        _isFlashing = false;
        _message = 'Hangi sayıyı gördün?';
      });
    });
  }

  void _handleSelection(int selectedNumber) async {
    String feedbackMessage;
    Color feedbackColor;
    totalClicks++;

    bool isCorrect = selectedNumber == _targetNumber; // ✅ doğru mu kontrol et

    if (isCorrect) {
      final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
      timerVM.stopTimer();

      final vm2 = Provider.of<GameResultViewModel>(context, listen: false);
      await vm2.saveGameResult(
        letter: 'tersSayi',
        totalClicks: totalClicks,
        correctClicks: correctClicks,
        durationseconds: timerVM.totalSeconds,
        koleksiyonadi: 'Sayilar',
      );

      // ✅ Doğru seçim
      feedbackMessage = 'Harika! Doğru gördün: $_targetNumber';
      feedbackColor = Colors.green;
    } else if (selectedNumber == _reversedNumber) {
      feedbackMessage =
      'Dikkat! Sen $selectedNumber dedin, ama doğru sayı $_targetNumber idi. (Ters çevirme tespiti)';
      feedbackColor = Colors.red;
      _logError('Ters Çevirme', _targetNumber, selectedNumber);
    } else {
      feedbackMessage = 'Yanlış. Doğru sayı $_targetNumber idi.';
      feedbackColor = Colors.red;
      _logError('Yanlış Seçim', _targetNumber, selectedNumber);
    }

    // Geri bildirim gösterimi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(feedbackMessage),
        backgroundColor: feedbackColor,
        duration: const Duration(seconds: 3),
      ),
    ).closed.then((_) {
      if (isCorrect) {
        // ✅ Sadece doğruysa yeni oyuna geç
        _setNewGame();
      } else {
        // ❌ Yanlışsa yeni oyun başlamasın
        setState(() {
          _message = 'Tekrar dene!';
        });
      }
    });
  }

  // Hata loglama (Konsola veya veri tabanına kaydedilebilir)
  void _logError(String errorType, int target, int selected) {
    print('Hata Tespiti: $errorType | Hedef: $target | Seçilen: $selected');
    // BURAYA GERÇEK UYGULAMANIZDA VERİTABANI KAYDI GELMELİ.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9DC),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // 1. Flaş Kart Alanı
            Container(
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _isFlashing ? Colors.yellow.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: _isFlashing
                  ? Text(
                '$_targetNumber',
                style: _kDyslexicTextStyle.copyWith(color: Colors.red.shade700),
              )
                  : Text(
                _message,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
            ),
            SizedBox(height: 12),
            // 2. Seçenekler Alanı
            if (!_isFlashing)
              Text(
                'Gördüğün sayıya dokun:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            SizedBox(height: 12),
            if (!_isFlashing)
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 2.5,
                ),
                itemCount: _options.length,
                itemBuilder: (context, index) {
                  final number = _options[index];
                  return ElevatedButton(
                    onPressed: () => _handleSelection(number),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFAB12F),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      '$number',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        // Ters çevrilme eğilimini azaltmak için fontu daha net yapabiliriz
                        letterSpacing: 2.0,
                      ),
                    ),
                  );
                },
              ),
            if (_isFlashing)
              Container(), // Flaş sırasında seçenekleri gizle
          ],
        ),
      ),
    );
  }
}