import 'package:disleksi_surum/view/ortak_bosluk/yonerge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/oruntu_view_model.dart';
import '../../viewModel/tts_view_model.dart';
import 'hafiza_view.dart';

class Iqtest extends StatelessWidget {
  const Iqtest({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IqTestViewModel(),
      child: Consumer<IqTestViewModel>(
        builder: (context, vm, child) {
          double screenw = MediaQuery.sizeOf(context).width;
          double screenh = MediaQuery.sizeOf(context).height;

          return Scaffold(
            body: Container(
              width: screenw,
              height: screenh,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Sol panel (resimler)
                  Center(
                    child: Container(
                      height: screenh * 0.8,
                      width: screenw * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(200),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  [
                              Text(
                                'Yandaki görsellerden hangisi gelmeli?',
                                style: TextStyle(
                                    fontFamily: 'RegularFont', fontSize: 20),
                              ),
                              IconButton(
                                onPressed: () {
                                  final vm = Provider.of<TtsViewModel>(context,listen: false);
                                  vm.speak('Yandaki görsellerden hangisi gelmeli?');
                                  // context.read<TtsViewModel>().speak('Yandaki görsellerden hangisi gelmeli?');
                                },
                                icon: Icon(Icons.volume_up, size: 30, color: Colors.orange),
                              ),
                            ],
                          ),
                          buildRow('civciv', screenw, screenh),
                          buildRow('tavsan', screenw, screenh),
                        ],
                      ),
                    ),
                  ),

                  // Sağ panel (tıklanabilir Container)
                  Container(
                    width: screenw / 5,
                    height: screenh / 1,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildContainer(context, vm, 'civciv', 100, screenh),
                        _buildContainer(context, vm, 'tavsan', 130, screenh),
                        _buildContainer(context, vm, 'tavsan', 170, screenh, isNext: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Row buildRow(String label1, double w, double h) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: h / 5,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('assets/images/oyunlar/$label1.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: 130,
          height: h / 4,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('assets/images/oyunlar/$label1.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: 170,
          height: h / 3,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            image: label1 == 'civciv'
                ? DecorationImage(
              image: AssetImage('assets/images/oyunlar/$label1.jpeg'),
              fit: BoxFit.cover,
            )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildContainer(BuildContext context, IqTestViewModel vm, String label, double size,
      double screenh,
      {bool isNext = false}) {
    return GestureDetector(
      onTap: () {
        if (isNext && vm.isCorrect(label)) {
          // Doğru seçim → sayfa geçiş
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Yonerge(text: 'Hafıza kartları', page:  HafizaPage()),
            ),
          );
        } else {
          // Yanlış seçim → AlertDialog
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Yanlış Seçim!'),
              content: const Text('Lütfen doğru seçeneği seçin.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tamam'),
                ),
              ],
            ),
          );
        }
      },
      child: Container(
        width: size,
        height: screenh / (size == 100 ? 6 : size == 130 ? 4 : 2),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange, width: 1),
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage('assets/images/oyunlar/$label.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

