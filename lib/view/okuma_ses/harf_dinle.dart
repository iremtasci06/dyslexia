import 'package:disleksi_surum/view/okuma_ses/ses_menu_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/game_result_viewmodel.dart';
import '../../viewModel/game_timer_viewmodel.dart';
import '../../viewModel/harfdinle_view_model.dart';
import '../../viewModel/tts_view_model.dart';

class LetterQuizPage extends StatefulWidget {
  const LetterQuizPage({super.key});

  @override
  State<LetterQuizPage> createState() => _LetterQuizPageState();
}

class _LetterQuizPageState extends State<LetterQuizPage> {
  @override
  void initState() {
    super.initState();
    final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
    timerVM.reset();
    timerVM.startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LetterQuizViewModel(Provider.of<TtsViewModel>(context, listen: false)),
      child: Consumer<LetterQuizViewModel>(
        builder: (context, vm, _) {
          // Oyun bittiğinde başka sayfaya geç
          if (vm.isFinished) {
            Future.microtask(() async{
              final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
              timerVM.stopTimer();

              final vm2 = Provider.of<GameResultViewModel>(context, listen: false);
              await vm2.saveGameResult(
                letter: 'hangisini duydun',
                totalClicks: vm.totalClicks,
                correctClicks: vm.correctClicks,
                durationseconds: timerVM.totalSeconds,
                koleksiyonadi: 'seslendirme',
              );
              vm.reset();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MenuViewSes()),
              );
            });
          }

          return Scaffold(
            backgroundColor: const Color(0xFFEDD1B0),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Hangi harfi duydun?", style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: vm.playLetter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDD0303),
                    ),
                    child: const Text("Dinle", style: TextStyle(fontSize: 24, color: Colors.black)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: vm.options.map((o) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: () => vm.checkAnswer(o),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFA812F),
                          ),
                          child: Text(o.toUpperCase(), style: const TextStyle(fontSize: 32,color: Colors.white)),
                        ),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(vm.feedback, style: const TextStyle(fontSize: 24, color: Colors.green)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
