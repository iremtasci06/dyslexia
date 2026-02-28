import 'package:disleksi_surum/view/home_harf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../viewModel/balon_view_model.dart';
import '../../viewModel/game_result_viewmodel.dart';
import '../../viewModel/game_timer_viewmodel.dart';
class HarfBulPage extends StatelessWidget {
  final String hedefHarf;
  final List<String> harfListesi;

  const HarfBulPage({
    super.key,
    required this.hedefHarf,
    required this.harfListesi,
  });

  @override
  Widget build(BuildContext context) {
    final widthscreen = MediaQuery.sizeOf(context).width;
    final heightscreen = MediaQuery.sizeOf(context).height;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Dikey moda sabitle
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // Timer başlat
      final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
      timerVM.reset();
      timerVM.startTimer();
    });

    return ChangeNotifierProvider<BalonViewModel>(
      create: (_) {
        final vm = BalonViewModel();
        vm.setGame(harfListesi, hedefHarf);
        return vm;
      },
      child: Consumer<BalonViewModel>(
        builder: (context, vm, child) {
          if (vm.tablo.isEmpty) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.pink2,
            body: Stack(
              children: [
                Container(
                  width: widthscreen,
                  height: heightscreen,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: heightscreen / 4),
                      Text(
                        'Hadi bakalım ${vm.hedefHarf} harfini bul!',
                        style: const TextStyle(
                            color: Colors.black, fontSize: 20),
                      ),
                      const Text(
                        'Balonlarını özgür bırak',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GridView.builder(
                            itemCount: vm.tablo.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                            ),
                            itemBuilder: (context, index) {
                              final color = vm.renkler[index];
                              return GestureDetector(
                                onTap: () async {
                                  vm.kontrolEt(index, context);
                                  if (vm.ballon == 0) {
                                    final timerVM = Provider.of<GameTimerViewModel>(
                                        context,
                                        listen: false);
                                    timerVM.stopTimer();

                                    final vm2 =
                                    Provider.of<GameResultViewModel>(
                                        context,
                                        listen: false);
                                    await vm2.saveGameResult(
                                      letter: hedefHarf,
                                      totalClicks: vm.totalClicks,
                                      correctClicks: vm.correctClicks,
                                      durationseconds: timerVM.totalSeconds,
                                      koleksiyonadi: 'Harfler',
                                    );
                                    vm.totalClicks = 0;
                                    timerVM.reset();
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: color ?? Colors.white,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      vm.tablo[index],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            vm.ballon,
                                (index) => Image.asset(
                              'assets/images/ballon.png',
                              width: widthscreen / 7,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (vm.showBalloon)
                  AnimatedAlign(
                    duration: const Duration(seconds: 3),
                    alignment: Alignment(0, vm.balloonY),
                    curve: Curves.easeOut,
                    child: SizedBox(
                      width: widthscreen / 2,
                      child: Image.asset('assets/images/ballon.png'),
                    ),
                  ),
                Positioned(
                  top: 20,
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
        },
      ),
    );
  }
}