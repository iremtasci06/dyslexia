import 'dart:math';
import 'package:disleksi_surum/view/ortak_bosluk/agac.dart';
import 'package:disleksi_surum/viewModel/farklibul_view_model.dart';
import 'package:disleksi_surum/viewModel/game_result_viewmodel.dart';
import 'package:disleksi_surum/viewModel/game_timer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/list.dart';
import '../home_harf.dart';
import 'yonerge.dart';

class PDers3 extends StatelessWidget {
  final String harf;
  final List<String> img;

  const PDers3({super.key, required this.harf, required this.img});

  @override
  Widget build(BuildContext context) {
    final widthscreen = MediaQuery.sizeOf(context).width;
    final heightscreen = MediaQuery.sizeOf(context).height;

    // Listeyi karıştır
    final shuffledImages = List<String>.from(img)..shuffle(Random());

    // Timer'ı güvenli şekilde başlat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
      timerVM.reset();
      timerVM.startTimer();
    });

    final secilenListe = tumListeler[harf.toUpperCase()];
    if (secilenListe == null) {
      debugPrint("HATA: '$harf' için liste bulunamadı!");
      return const Scaffold(
        body: Center(child: Text("Liste bulunamadı.")),
      );
    }

    final harfList = List<String>.from(secilenListe[1]['list']);
    final hedefHarf = secilenListe[1]['harf'] as String;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              width: widthscreen,
              height: heightscreen,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(2, (rowIndex) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (colIndex) {
                          int index = rowIndex * 3 + colIndex;
                          if (index >= shuffledImages.length) return const SizedBox();

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: widthscreen / 5,
                              height: widthscreen / 5,
                              child: GestureDetector(
                                onTap: () async {
                                  final vm = Provider.of<FarkliBulViewModel>(context, listen: false);
                                  vm.kontrolEt(shuffledImages[index], harf);

                                  if (vm.isCorrect) {
                                    final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
                                    timerVM.stopTimer();

                                    final vm2 = Provider.of<GameResultViewModel>(context, listen: false);
                                    await vm2.saveGameResult(
                                        letter: harf,
                                        totalClicks: vm.totalClicks,
                                        correctClicks: vm.correctClicks,
                                        durationseconds: timerVM.totalSeconds,
                                        koleksiyonadi: 'Harfler'
                                    );
                                    vm.totalClicks=0;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Yonerge(
                                          text: 'Ağaçtan elma topla!',
                                          page: HarfToplaPage(
                                            hedefHarf: hedefHarf,
                                            harfListesi: harfList,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/harfler/P/farklı_${shuffledImages[index]}.jpeg',
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HarflerPage()),
                );
              },
              icon: const Icon(Icons.home, color: Colors.white, size: 36),
              style: IconButton.styleFrom(
                backgroundColor: Colors.orange.withAlpha(200),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// 🔠 Harf listeleri burada tanımlı
final Map<String, List<Map<String, dynamic>>> tumListeler = {
  'P': pliste,
  'D': dliste,
  'B': bliste,
  'U': uliste,
  'M': mliste,
  'N': nliste,
};