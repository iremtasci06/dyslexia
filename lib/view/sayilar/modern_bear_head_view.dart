import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/bear_viewmodel.dart';
import '../../utils/cute_bear_painter.dart';
import '../../viewModel/game_result_viewmodel.dart';
import '../../viewModel/game_timer_viewmodel.dart';
import 'house_view.dart';

class ModernBearHeadView extends StatefulWidget {
  const ModernBearHeadView({super.key});

  @override
  State<ModernBearHeadView> createState() => _ModernBearHeadViewState();
}

class _ModernBearHeadViewState extends State<ModernBearHeadView> {
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
      create: (_) => BearViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Ayıcığı Boya 🎨")),
        body: SafeArea(
          child: Consumer<BearViewModel>(
            builder: (context, viewModel, _) => Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Center(
                    child: GestureDetector(
                      onTapDown: (details) => viewModel.handleTap(
                        details.localPosition,
                        const Size(400, 400),
                            () {
                              Future.delayed(const Duration(seconds: 2), () async{
                                final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
                                timerVM.stopTimer();

                                final vm2 = Provider.of<GameResultViewModel>(context, listen: false);
                                await vm2.saveGameResult(
                                  letter: 'boyama_ayi',
                                  totalClicks: viewModel.totalClicks,
                                  correctClicks: viewModel.correctClicks,
                                  durationseconds: timerVM.totalSeconds,
                                    koleksiyonadi: 'Sayilar'
                                );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const HouseView(),
                                  ),
                                );
                              });
                            },
                      ),
                      child: CustomPaint(
                        size: const Size(400, 400),
                        painter: CuteBearPainter(
                          faceColor: viewModel.faceColor,
                          earColor: viewModel.earColor,
                          innerEarColor: viewModel.innerEarColor,
                          noseColor: viewModel.noseColor,
                          noseBgColor: viewModel.noseBgColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: viewModel.numberColors.entries.map((entry) {
                        final num = entry.key;
                        final color = entry.value;
                        final isSelected = viewModel.selectedNumber == num;

                        return GestureDetector(
                          onTap: () => viewModel.selectNumber(num),
                          child: Container(
                            width: 60,
                            height: 60,
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
                                fontSize: 20,
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
