import 'package:disleksi_surum/view/home_harf.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../utils/orientation_helper.dart';
import '../../viewModel/balon_view_model.dart';
import '../../viewModel/game_result_viewmodel.dart';
import '../../viewModel/game_timer_viewmodel.dart';
class HarfBulPage extends StatefulWidget {
  final String hedefHarf;
  final List<String> harfListesi;

  const HarfBulPage({
    super.key,
    required this.hedefHarf,
    required this.harfListesi,
  });

  @override
  State<HarfBulPage> createState() => _HarfBulPageState();
}

class _HarfBulPageState extends State<HarfBulPage> {
  @override
  void initState() {
    super.initState();
    OrientationHelper.setPortrait();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
      timerVM.reset();
      timerVM.startTimer();
    });
  }

  @override
  void dispose() {
    OrientationHelper.setLandscape();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthscreen = MediaQuery.sizeOf(context).width;
    final heightscreen = MediaQuery.sizeOf(context).height;

    return ChangeNotifierProvider<BalonViewModel>(
      create: (_) {
        final vm = BalonViewModel();
        vm.setGame(widget.harfListesi, widget.hedefHarf);
        return vm;
      },
      child: Consumer<BalonViewModel>(
        builder: (context, vm, child) {
          if (vm.pendingEvent != BalonGameEvent.none) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final event = vm.pendingEvent;
              vm.consumePendingEvent();

              if (event == BalonGameEvent.win) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Tebrikler 🎉"),
                    content: Text("Tüm ${vm.hedefHarf} harflerini buldun!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          vm.resetGame();
                        },
                        child: const Text("Yeniden Oyna"),
                      )
                    ],
                  ),
                );
              }

              if (event == BalonGameEvent.lose) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Oyun Bitti 😢"),
                    content: const Text("Tüm balonların bitti."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          vm.resetGame();
                        },
                        child: const Text("Tekrar Dene"),
                      )
                    ],
                  ),
                );
              }
            });
          }

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
                                  vm.kontrolEt(index);
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
                                      letter: widget.hedefHarf,
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
                    onPressed: () async {
                      await OrientationHelper.setLandscape();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HarflerPage()),
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