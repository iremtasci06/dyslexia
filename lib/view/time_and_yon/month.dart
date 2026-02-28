import 'dart:math';
import 'package:disleksi_surum/view/time_and_yon/zaman_menu_views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewModel/game_result_viewmodel.dart';
import '../../viewModel/game_timer_viewmodel.dart';

class Months extends StatefulWidget {
  @override
  _MonthsState createState() => _MonthsState();
}

class _MonthsState extends State<Months> {
  List<String> month = [
    "Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran",
    "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık",
  ];

  late List<String> shuffledDays;
  late List<Offset> positions;
  late List<Color> colors;

  int totalClicks = 0;
  final int correctClicks = 12;

  final double cardHeight = 60;
  final double spacing = 10;
  late double cardWidth;

  @override
  void initState() {
    super.initState();
    shuffledDays = List.from(month);
    shuffledDays.shuffle(Random());
    colors = List.filled(month.length, Color(0xFFFF714B));

    final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
    timerVM.reset();
    timerVM.startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;

      // Kart genişliğini ekran genişliğine göre ayarla
      final totalSpacing = spacing * (month.length - 1);
      cardWidth = (screenSize.width - totalSpacing) / month.length;

      // Pozisyonları rastgele oluştur
      positions = List.generate(month.length, (_) {
        double x = Random().nextDouble() * (screenSize.width - cardWidth);
        double y = Random().nextDouble() * (screenSize.height - cardHeight - kToolbarHeight - 20);
        return Offset(x, y);
      });

      setState(() {});
    });
  }

  // Slotları yatay olarak hizalamak
  List<Offset> get slots {
    return List.generate(month.length, (i) {
      double x = (cardWidth + spacing) * i;
      double y = 50.0;
      return Offset(x, y);
    });
  }

  @override
  Widget build(BuildContext context) {
   /* if (positions == null) {
      // initFrame callback tamamlanmamışsa boş ekran
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }*/

    return Scaffold(
      backgroundColor: const Color(0xFFF3E9DC),
      appBar: AppBar(
        title: Text("Sürükle-Bırak Kartlar"),
        backgroundColor: const Color(0xFFF3E9DC),
      ),
      body: Stack(
        children: List.generate(shuffledDays.length, (index) {
          return Positioned(
            left: positions[index].dx,
            top: positions[index].dy,
            child: Draggable<int>(
              data: index,
              feedback: cardWidget(shuffledDays[index], colors[index]),
              childWhenDragging: Opacity(
                opacity: 0.5,
                child: cardWidget(shuffledDays[index], colors[index]),
              ),
              child: cardWidget(shuffledDays[index], colors[index]),
                onDragEnd: (details) {
                  setState(() {
                    // Kartı en yakın slota yapıştır (x ve y koordinatına göre)
                    int nearestSlot = 0;
                    double minDist = double.infinity;
                    for (int i = 0; i < slots.length; i++) {
                      double dx = details.offset.dx - slots[i].dx;
                      double dy = details.offset.dy - slots[i].dy;
                      double dist = dx * dx + dy * dy; // Öklid mesafesi karesi
                      if (dist < minDist) {
                        minDist = dist;
                        nearestSlot = i;
                      }
                    }

                    positions[index] = slots[nearestSlot];
                    totalClicks++;
                    // Doğruluk kontrolü
                    if (shuffledDays[index] == month[nearestSlot]) {
                      colors[index] = Color(0xff78C841); // doğru
                    } else {
                      colors[index] = Color(0xFFC71E64); // yanlış
                    }

                    // Tüm kartlar doğru mu kontrol et
                    bool allCorrect = colors.every((c) => c == Color(0xff78C841));
                    if (allCorrect) {
                      // 1 saniye bekleyip diğer sayfaya geç
                      Future.delayed(const Duration(seconds: 1), () async{
                        final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
                        timerVM.stopTimer();

                        final vm2 = Provider.of<GameResultViewModel>(context, listen: false);
                        await vm2.saveGameResult(
                            letter: 'aylar',
                            totalClicks: totalClicks,
                            correctClicks: correctClicks,
                            durationseconds: timerVM.totalSeconds,
                            koleksiyonadi: 'zaman-yön'
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ZamanMenuView()), // kendi sayfan ile değiştir
                        );
                      });
                    }
                  });
                }

            ),
          );
        }),
      ),
    );
  }

  Widget cardWidget(String text, Color color) {
    return Card(
      color: color,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
