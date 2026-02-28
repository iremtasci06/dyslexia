import 'package:disleksi_surum/utils/data.dart';
import 'package:disleksi_surum/view/okuma_ses/ses_menu_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/game_result_viewmodel.dart';
import '../../viewModel/game_timer_viewmodel.dart';
import '../../viewModel/seslendirme_view_model.dart';

class SpeechPage extends StatefulWidget {
  const SpeechPage({Key? key}) : super(key: key);

  @override
  State<SpeechPage> createState() => _SpeechPageState();
}

class _SpeechPageState extends State<SpeechPage> {
  late SpeechViewModel vm;
  List<SentenceData> sentencesData = [];

  @override
  void initState() {
    super.initState();
    vm = SpeechViewModel();
    vm.initSpeech();

    final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
    timerVM.reset();
    timerVM.startTimer();

    // 🔹 JSON'dan cümleleri yükle
    loadSentencesFromJson().then((data) {
      setState(() {
        sentencesData = data;
        vm.sentences = sentencesData.map((e) => e.text).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Consumer<SpeechViewModel>(
        builder: (context, vm, _) {
          // 🔹 Oyun bittiğinde sonuç kaydı ve yönlendirme
          if (vm.isFinished) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
              final vm2 = Provider.of<GameResultViewModel>(context, listen: false);

              timerVM.stopTimer();
              await vm.stopListening();

              await vm2.saveGameResult(
                letter: 'seslendirme',
                totalClicks: vm.totalClicks,
                correctClicks: vm.correctClicks,
                durationseconds: timerVM.totalSeconds,
                koleksiyonadi: 'seslendirme', // 🔹 koleksiyon adı dinamik parametre
              );

              vm.reset();

              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MenuViewSes()),
                );
              }
            });
          }

          return Scaffold(
            appBar: AppBar(title: const Text("Konuşma Uygulaması")),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔹 Hedef cümle
                  Text(
                    vm.currentSentence.isEmpty
                        ? "Cümle yükleniyor..."
                        : vm.currentSentence,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Kullanıcının söylediği cümle
                  Text(
                    vm.recognizedText.isEmpty
                        ? (vm.isListening
                        ? "Dinleniyor..."
                        : "Henüz konuşma algılanmadı 🎤")
                        : "Sen dedin: ${vm.recognizedText}",
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // 🔹 Butonlar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          vm.isListening
                              ? vm.stopListening()
                              : vm.startListening();
                        },
                        icon: Icon(
                            vm.isListening ? Icons.stop : Icons.mic_rounded),
                        label: Text(vm.isListening ? "Durdur" : "Dinle"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          vm.nextSentence();
                          setState(() {});
                        },
                        child: const Text("Sonraki"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: vm.checkSpeech,
                        child: const Text("Kontrol Et"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Sonuç mesajları
                  Builder(
                    builder: (_) {
                      final wrong = vm.getWrongWords();
                      if (wrong.isEmpty && vm.recognizedText.isNotEmpty) {
                        return const Text(
                          "Harika! 🎉 Tüm kelimeleri doğru söyledin.",
                          style: TextStyle(color: Colors.green, fontSize: 18),
                          textAlign: TextAlign.center,
                        );
                      } else if (wrong.isNotEmpty) {
                        return Text(
                          "Yanlış veya eksik kelimeler: ${wrong.join(', ')}",
                          style: const TextStyle(color: Colors.red, fontSize: 18),
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
