import 'package:disleksi_surum/view/time_and_yon/sagsol_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../viewModel/asansor_view_model.dart';
import '../../viewModel/game_result_viewmodel.dart';
import '../../viewModel/game_timer_viewmodel.dart';
import '../ortak_bosluk/yonerge.dart';

class ElevatorGamePage extends StatefulWidget {
  const ElevatorGamePage({Key? key}) : super(key: key);

  @override
  State<ElevatorGamePage> createState() => _ElevatorGamePageState();
}

class _ElevatorGamePageState extends State<ElevatorGamePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
    timerVM.reset();
    timerVM.startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9DC),
      body: Consumer<AsansorViewModel>(
        builder: (context, vm, child) {
          final stackHeight = MediaQuery.of(context).size.height;
          final totalFloorHeight = vm.floorHeight * 6;
          final topOffset = (stackHeight - totalFloorHeight) / 2;

          return Stack(
            children: [
              // Kat numaraları ve çizgiler
              for (int i = 0; i < 6; i++) ...[
                Positioned(
                  top: vm.getFloorPosition(i, topOffset),
                  left: 40.0,
                  child: Text(
                    i == 5 ? '1. Kat' : '${6 - i}. Kat',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  top: vm.getFloorPosition(i, topOffset) + 25.0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 1,
                    color: Colors.grey.withAlpha(200),
                  ),
                ),
                if (i == vm.targetFloor)
                  Positioned(
                    top: vm.getFloorPosition(i, topOffset) - 10,
                    left: 120,
                    child: const Icon(Icons.flag, color: Colors.red, size: 30),
                  ),
              ],

              // Asansör görseli
              AnimatedPositioned(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                top: vm.elevatorPosition + topOffset - 60,
                left: 150.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/asansor.png',
                    width: 160,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Alt kontrol butonları
              Positioned(
                bottom: 100.0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      "Tur: ${vm.completedRounds + 1} / ${vm.totalRounds}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFAB12F),
                          ),
                          onPressed: vm.moveUp,
                          child: const Text(
                            'Yukarı',
                            style:
                            TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFA812F),
                          ),
                          onPressed: vm.moveDown,
                          child: const Text(
                            'Aşağı',
                            style:
                            TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDD0303),
                          ),
                          onPressed: () async {
                            bool oyunBitti = vm.checkIfAtTarget(); // artık context yok

                            if (oyunBitti) {
                              // build tamamlandıktan sonra işlemleri yap
                              WidgetsBinding.instance.addPostFrameCallback((_) async {
                                final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
                                timerVM.stopTimer();

                                final vm2 = Provider.of<GameResultViewModel>(context, listen: false);
                                await vm2.saveGameResult(
                                  letter: 'asansör',
                                  totalClicks: vm.totalClicks,
                                  correctClicks: vm.correctClicks,
                                  durationseconds: timerVM.totalSeconds,
                                  koleksiyonadi: 'zaman-yön',
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Yonerge(
                                      text: "Ayıya yardım edelim ve bal yesin",
                                      page: LeftRightGamePage(),
                                    ),
                                  ),
                                );
                              });
                            } else {
                              final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
                              timerVM.reset();
                              timerVM.startTimer();
                            }
                          },
                          child: const Text(
                            'Kontrol Et',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
