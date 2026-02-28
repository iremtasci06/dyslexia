import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/farklibul_view_model.dart';
import '../../viewModel/game_result_viewmodel.dart';
import '../../viewModel/game_timer_viewmodel.dart';
import 'farklisayi2.dart';

class SayiFark extends StatefulWidget {

  const SayiFark({super.key});

  @override
  State<SayiFark> createState() => _SayiFarkState();
}

class _SayiFarkState extends State<SayiFark> {
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
    double widthscreen = MediaQuery.sizeOf(context).width;
    double heightscreen = MediaQuery.sizeOf(context).height;

    List<String> img = ['6','9','9','9','9','9'];
    img.shuffle(Random());

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: widthscreen,
          height: heightscreen,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(  // taşmayı engeller
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (rowIndex) { // 2 satır
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (colIndex) { // 3 sütun
                      int index = rowIndex * 3 + colIndex; // 2x3 matris için index
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: widthscreen / 5,
                          height: widthscreen / 5,
                          child: GestureDetector(
                            onTap: () async{
                              final vm = Provider.of<FarkliBulViewModel>(context,listen: false);
                              vm.kontrolEt(img[index],'6');
                              if(vm.isCorrect){
                                final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
                                timerVM.stopTimer();

                                final vm2 = Provider.of<GameResultViewModel>(context, listen: false);
                                await vm2.saveGameResult(
                                    letter: '6-9',
                                    totalClicks: vm.totalClicks,
                                    correctClicks: vm.correctClicks,
                                    durationseconds: timerVM.totalSeconds,
                                    koleksiyonadi: 'Sayilar'
                                );
                                vm.reset();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>  SayiFark2(),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                   'assets/images/sayilar/sayi_${img[index]}.jpeg'
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
