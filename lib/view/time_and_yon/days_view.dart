import 'package:disleksi_surum/view/time_and_yon/asansor_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/days_view_model.dart';
import '../../viewModel/game_result_viewmodel.dart';
import '../../viewModel/game_timer_viewmodel.dart';
import '../ortak_bosluk/yonerge.dart';

class TrainVagon extends StatefulWidget {
  final TimeCategory category;
  final String label;
  final Color color;
  final List<ActivityCard> placedCards;

  const TrainVagon({
    required this.category,
    required this.label,
    required this.color,
    required this.placedCards,
  });

  @override
  State<TrainVagon> createState() => _TrainVagonState();
}

class _TrainVagonState extends State<TrainVagon> {
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
    final vm = Provider.of<TimeTrainViewModel>(context, listen: false);
    final screenHeight = MediaQuery.of(context).size.height;
    final vagonHeight = screenHeight / 4;

    return DragTarget<ActivityCard>(
      onAcceptWithDetails: (details) async{
        final card = details.data;
        if (vm.handleCardDrop(card, widget.category)) {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("🎉 ${card.title} doğru yere yerleştirildi!"),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 220,
          height: vagonHeight,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: widget.color.withAlpha(200),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: candidateData.isNotEmpty ? Colors.yellowAccent : Colors.transparent,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.label,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              const Divider(color: Colors.white70),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: widget.placedCards
                        .map((card) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Chip(
                        label: Text(card.title,
                            style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.white,
                      ),
                    ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TimeTrainScreen extends StatefulWidget {
  const TimeTrainScreen({Key? key}) : super(key: key);

  @override
  State<TimeTrainScreen> createState() => _TimeTrainScreenState();
}

class _TimeTrainScreenState extends State<TimeTrainScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TimeTrainViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF3E9DC),
        body: SafeArea(
          child: Consumer<TimeTrainViewModel>(
            builder: (context, vm, child) {
            if (vm.isGameComplete && !vm.hasNavigated) {
              vm.hasNavigated = true;
              // Tek seferlik navigasyon
              WidgetsBinding.instance.addPostFrameCallback((_) async{
                final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
                timerVM.stopTimer();

                final vm2 = Provider.of<GameResultViewModel>(context, listen: false);
                await vm2.saveGameResult(
                    letter: 'günler',
                    totalClicks: vm.totalClicks,
                    correctClicks: vm.correctClicks,
                    durationseconds: timerVM.totalSeconds,
                    koleksiyonadi: 'zaman-yön'
                );
                Navigator.push(context,
                  MaterialPageRoute(
                  builder: (_) => Yonerge(text: "Asansör ile arkadaşımıza yardım edelim", page: ElevatorGamePage(),),
            ),);});
            }
                return LayoutBuilder(
                builder: (context, constraints) {
                  final isSmallScreen = constraints.maxWidth < 600;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Flex(
                          direction: isSmallScreen ? Axis.vertical : Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- SOL: TREN VAGONLARI ---
                            Expanded(
                              flex: isSmallScreen ? 0 : 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TrainVagon(
                                    category: TimeCategory.YESTERDAY,
                                    label: "DÜN",
                                    color: const Color(0xFFFAB12F),
                                    placedCards: vm.placedYesterday,
                                  ),
                                  TrainVagon(
                                    category: TimeCategory.TODAY,
                                    label: "BUGÜN",
                                    color: const Color(0xFFFA812F),
                                    placedCards: vm.placedToday,
                                  ),
                                  TrainVagon(
                                    category: TimeCategory.TOMORROW,
                                    label: "YARIN",
                                    color: const Color(0xFFDD0303),
                                    placedCards: vm.placedTomorrow,
                                  ),
                                ],
                              ),
                            ),
                            if (!isSmallScreen)
                              const SizedBox(width: 16)
                            else
                              const SizedBox(height: 16),
                            // --- SAĞ: KARTLAR ---
                            Expanded(
                              flex: isSmallScreen ? 0 : 6,
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isSmallScreen ? 1 : 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 2.5,
                                ),
                                itemCount: vm.draggableCards.length,
                                itemBuilder: (context, index) {
                                  final card = vm.draggableCards[index];
                                  return Draggable<ActivityCard>(
                                    data: card,
                                    feedback: Material(
                                      color: Colors.transparent,
                                      child: Chip(
                                        label: Text(card.title,),
                                        backgroundColor: Colors.yellow.shade200,
                                      ),
                                    ),
                                    childWhenDragging: Chip(
                                      label: Text(card.title,),
                                      backgroundColor: Colors.yellow.shade100,
                                    ),
                                    child: Chip(
                                      label: Text(card.title,style: TextStyle(fontSize: 18)),
                                      backgroundColor: const Color(0xFFFEF3E2),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
