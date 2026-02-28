import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/game_result_viewmodel.dart';
import '../../viewModel/game_timer_viewmodel.dart';
import 'farklisayi.dart';
import '../../utils/house_painter.dart';
import '../../viewModel/house_viewmodel.dart';

class HouseView extends StatefulWidget {
  const HouseView({super.key});

  @override
  State<HouseView> createState() => _HouseViewState();
}

class _HouseViewState extends State<HouseView> {
  @override
  void initState() {
    super.initState();
    // Timer başlat
    final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
    timerVM.reset();
    timerVM.startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HouseViewModel(),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: Consumer<HouseViewModel>(
            builder: (context, viewModel, _) => Row(
              children: [
                // Sol: ev çizimi
                Expanded(
                  flex: 5,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1.2,
                      child: GestureDetector(
                        onTapDown: (details) => viewModel.handleTap(
                          details.localPosition,
                          const Size(400, 400),
                              () {
                            // Tüm parçalar boyandı -> başka sayfa
                            Future.delayed(const Duration(seconds: 2), () async{
                              final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
                              timerVM.stopTimer();

                              final vm2 = Provider.of<GameResultViewModel>(context, listen: false);
                              await vm2.saveGameResult(
                                  letter:'boyama_ev',
                                  totalClicks: viewModel.totalClicks,
                                  correctClicks: viewModel.correctClicks,
                                  durationseconds: timerVM.totalSeconds,
                                  koleksiyonadi: 'Sayilar'
                              );

                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => SayiFark()),
                            );
                            });
                          },
                        ),
                        child: CustomPaint(
                          size: const Size(400, 400),
                          painter: HousePainter(
                            viewModel.wallColor,
                            viewModel.roofColor,
                            viewModel.doorColor,
                            viewModel.treeColor,
                            viewModel.windowColor, // pencere eklendi
                          ),
                        ),

                      ),
                    ),
                  ),
                ),

                // Sağ: palet
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: viewModel.numberColors.entries.map((entry) {
                        final num = entry.key;
                        final color = entry.value;
                        final isSelected = viewModel.selectedNumber == num;

                        return GestureDetector(
                          onTap: () => viewModel.selectNumber(num),
                          child: Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? Colors.black : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "$num",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
