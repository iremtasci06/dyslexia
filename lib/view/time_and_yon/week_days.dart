import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewModel/game_result_viewmodel.dart';
import '../../viewModel/game_timer_viewmodel.dart';
import '../ortak_bosluk/yonerge.dart';
import 'month.dart';

class WeekDays extends StatefulWidget {
  @override
  _WeekDaysState createState() => _WeekDaysState();
}

class _WeekDaysState extends State<WeekDays> {

  List<String> days = [
    "Pazartesi", "Salı", "Çarşamba",
    "Perşembe", "Cuma", "Cumartesi", "Pazar"];

  List<String> shuffledDays = [];
  List<Offset> positions = [];
  List<Color> colors = [];

  final double spacing = 10;
  int totalClicks = 0;
  final int correctClicks = 7;

  @override
  void initState() {
    super.initState();
    shuffledDays = List.from(days);
    shuffledDays.shuffle(Random());
    final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
    timerVM.reset();
    timerVM.startTimer();
    colors = List.filled(days.length, Color(0xFFFF714B));
  }

  List<Offset> generateSlots(double cardWidth, double spacing) {
    return List.generate(days.length,
            (i) => Offset(i * (cardWidth + spacing), 50.0));
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final int cardCount = days.length;
    final double totalSpacing = spacing * (cardCount - 1);
    final double availableWidth = screenSize.width - totalSpacing;
    final double cardWidth = availableWidth / cardCount;
    final double cardHeight = 60;
    final slots = generateSlots(cardWidth, spacing);

    // Başlangıçta ekran boyutuna göre pozisyon
    if (positions.isEmpty) {
      positions = List.generate(days.length, (_) {
        double x = Random().nextDouble() * (screenSize.width - cardWidth);
        double y = Random().nextDouble() * (screenSize.height - cardHeight - kToolbarHeight - 20);
        return Offset(x, y);
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3E9DC),
      appBar: AppBar(title: Text("Sürükle-Bırak Kartlar"),backgroundColor: const Color(0xFFF3E9DC),),
      body: Stack(
        children: List.generate(shuffledDays.length, (index) {
          return Positioned(
            left: positions[index].dx,
            top: positions[index].dy,
            child: Draggable<int>(
              data: index,
              feedback: cardWidget(
                shuffledDays[index],
                colors[index],
                cardWidth,
                cardHeight,
              ),
              childWhenDragging: Opacity(
                opacity: 0.5,
                child: cardWidget(
                  shuffledDays[index],
                  colors[index],
                  cardWidth,
                  cardHeight,
                ),
              ),
              child: cardWidget(
                shuffledDays[index],
                colors[index],
                cardWidth,
                cardHeight,
              ),
                onDragEnd: (details) {
                  setState(() {
                    // Kartı en yakın slota yapıştır
                    int nearestSlot = 0;
                    double minDist = double.infinity;
                    for (int i = 0; i < slots.length; i++) {
                      double dist = (details.offset.dx - slots[i].dx).abs();
                      if (dist < minDist) {
                        minDist = dist;
                        nearestSlot = i;
                      }
                    }

                    positions[index] = slots[nearestSlot];
                    totalClicks++;
                    // Doğruluk kontrolü
                    if (shuffledDays[index] == days[nearestSlot]) {
                      colors[index] = Color(0xff78C841); // yeşil
                    } else {
                      colors[index] = Color(0xFFC71E64); // kırmızı
                    }

                    // Tüm kartlar doğru mu kontrol et
                    bool allCorrect = colors.every((c) => c == Color(0xff78C841));
                    if (allCorrect) {

                      Future.delayed(const Duration(seconds: 1), () async{
                        final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
                        timerVM.stopTimer();

                        final vm2 = Provider.of<GameResultViewModel>(context, listen: false);
                        await vm2.saveGameResult(
                            letter: 'haftanın günleri',
                            totalClicks: totalClicks,
                            correctClicks: correctClicks,
                            durationseconds: timerVM.totalSeconds,
                            koleksiyonadi: 'zaman-yön'
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Yonerge(text: "Ayları sıraya dizelim", page: Months()),
                          ),
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

  Widget cardWidget(String text, Color color, double width, double height) {
    return Card(
      color: color,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}