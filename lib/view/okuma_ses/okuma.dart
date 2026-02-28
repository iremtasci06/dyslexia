import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../utils/hikayeler.dart';
import '../../viewModel/game_result_viewmodel.dart';
import '../../viewModel/game_timer_viewmodel.dart';
import 'okuma_menu.dart';

class ReadingPage extends StatefulWidget {
  final int storyIndex;

  const ReadingPage({super.key, required this.storyIndex});

  static const Map<String, Color> highlightColors = {
    'b': Color(0xFFC70039),
    'd': Color(0xFF9400FF),
    'p': Color(0xFF059212),
  };

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  @override
  void initState() {
    super.initState();
    final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
    timerVM.reset();
    timerVM.startTimer();
  }

  @override
  Widget build(BuildContext context) {
    // Ekranı dikey moda sabitle
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final story = stories[widget.storyIndex];

    // Metni kelimelere ayır
    final words = story.text.split(' ');

    List<TextSpan> textSpans = [];

    for (var word in words) {
      // Her kelimedeki harfleri kontrol et
      List<TextSpan> letterSpans = word.split('').map((char) {
        final lowerChar = char.toLowerCase();
        final color = ReadingPage.highlightColors[lowerChar] ?? Colors.black;
        return TextSpan(
          text: char,
          style: TextStyle(
            fontFamily: 'OpenDyslexic',
            fontSize: 22,
            height: 2,
            color: color,
          ),
        );
      }).toList();

      // Her kelimeden sonra bir boşluk ekle
      textSpans.add(TextSpan(children: letterSpans));
      textSpans.add(const TextSpan(text: '      '));
    }

    return Container(
        decoration: const BoxDecoration(
        image: DecorationImage(
        image: AssetImage('assets/images/background.png'),
    fit: BoxFit.cover,
    alignment: Alignment.center,
    ),
    ),
    child: Scaffold(
    backgroundColor: Colors.transparent,
    body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 100,right: 16,left: 16,bottom: 16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFFEDD1B0),
              ),
              padding: const EdgeInsets.only(top: 30,right: 16,left: 16,bottom: 16),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(children: textSpans),
              ),
            ),
            ElevatedButton(onPressed: ()async{
              final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
              timerVM.stopTimer();

              final vm2 = Provider.of<GameResultViewModel>(context, listen: false);
              await vm2.saveGameResult(
                letter: 'Okuma',
                totalClicks: 0,
                correctClicks: 0,
                durationseconds: timerVM.totalSeconds,
                koleksiyonadi: 'okuma1',
              );
              timerVM.totalSeconds=0;
              Navigator.push(context, MaterialPageRoute(builder: (_)=>ColorfulTextPage()));
            }, child: Text('GERİ')),
          ],
        ),
      ),
    ),
    );
  }
}

