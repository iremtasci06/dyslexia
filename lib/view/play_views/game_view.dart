import 'package:disleksi_surum/view/play_views/hafiza_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../viewModel/game_view_model.dart';


class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<GameViewModel>(
          builder: (context, vm, _) {
            double screenHeight = MediaQuery.sizeOf(context).height;

            // Oyuncu kazanırsa başka sayfaya geç
            vm.onPlayerWin = () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HafizaPage()),
              );
            };
            vm.onBotWin = () {
              vm.restartGame();
            };

            return Column(
              children: [
                // Harf şeridi
                Container(
                  height: 70,
                  color: AppColors.peach,
                  child: Stack(
                    children: vm.movingLetters.map((ml) {
                      return Positioned(
                        left: ml.x,
                        top: 10,
                        child: Text(
                          ml.letter.toUpperCase(),
                          style: TextStyle(
                            fontSize: 32,
                            color: ml.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 10),

                // Yol ve arabalar
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      // Yol
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        height: screenHeight / 2,
                        color: Colors.grey.shade700,
                      ),

                      // Bitiş çizgisi
                      Positioned(
                        left: vm.finishLine,
                        bottom: 20,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'BİTİŞ',
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade500,
                            ),
                          ),
                        ),
                      ),

                      // Oyuncu arabası
                      Positioned(
                        left: vm.playerCar,
                        bottom: 50,
                        child: Image.asset(
                          'assets/images/oyunlar/car2.png',
                          height: 70,
                        ),
                      ),


                    ],
                  ),
                ),

                // Klavye
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 10,
                    children: vm.allLetters.map((l) {
                      return ElevatedButton(
                        onPressed: () => vm.onLetterPressed(l),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.peach,
                        ),
                        child: Text(
                          l.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 24, color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
