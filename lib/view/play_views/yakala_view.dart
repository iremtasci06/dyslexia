import 'package:disleksi_surum/view/play_views/oruntu_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../viewModel/yakala_view_model.dart';
import '../ortak_bosluk/yonerge.dart';

class YakalamaGame extends StatelessWidget {
  const YakalamaGame({super.key});

  @override
  Widget build(BuildContext context) {
    // Ekranı yatay moda sabitle
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return ChangeNotifierProvider(
      create: (_) => YakalaViewModel()..startGame(),
      child: const _GameView(),
    );
  }
}

class _GameView extends StatelessWidget {
  const _GameView();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    final vm = Provider.of<YakalaViewModel>(context);

    // Oyun bittiğinde yeni sayfaya yönlendir
    if (vm.isGameOver) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const Yonerge(text: 'Hangi resim gelmeli', page: const Iqtest()),
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: AppColors.lila,
      body: SafeArea(
        child: Row(
          children: [
            // Sol panel (puan - süre)
            Container(
              width: screenWidth * 0.25,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(100),
                border: Border(
                  right: BorderSide(color: Colors.orange.shade200, width: 3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Puan: ${vm.score}',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Süre: ${vm.timeLeft}',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Sağ panel (oyun alanı)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double gridWidth = constraints.maxWidth;
                    double gridHeight = constraints.maxHeight;

                    // 4 sütun 2 satır = 8 kare
                    double squareSize = (gridWidth / 4).clamp(0, gridHeight / 2);

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // 4 sütun
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1, // kare oranı
                      ),
                      itemCount: 8, // 4x2 grid
                      itemBuilder: (context, index) {
                        final bool hasCorap = index == vm.pandaIndex;
                        return GestureDetector(
                          onTap: () {
                            if (hasCorap) vm.hitPanda();
                          },
                          child: Container(
                            width: squareSize,
                            height: squareSize,
                            decoration: BoxDecoration(
                              color: hasCorap ? Colors.orange.shade100 : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: hasCorap
                                ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/images/oyunlar/hamster.jpeg',
                                fit: BoxFit.contain,
                              ),
                            )
                                : null,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
