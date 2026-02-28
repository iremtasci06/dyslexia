import 'package:disleksi_surum/view/ortak_bosluk/yonerge.dart';
import 'package:disleksi_surum/view/play_views/yakala_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/hikaye_sirala_view_model.dart';
import '../../viewModel/tts_view_model.dart';

class HikayeSiralaPage extends StatelessWidget {
  const HikayeSiralaPage({super.key});

  @override
  Widget build(BuildContext context) {
    double widthscreen = MediaQuery.sizeOf(context).width;
    double heightscreen = MediaQuery.sizeOf(context).height;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HikayeSiralaViewModel()),
        ChangeNotifierProvider(create: (_) => TtsViewModel()),
      ],
      child: Scaffold(
        body: Consumer2<HikayeSiralaViewModel, TtsViewModel>(
          builder: (context, viewModel, tts, _) {
            if (viewModel.shouldNavigateNext) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                viewModel.consumeNavigateNext();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Yonerge(
                      text: 'Sincapı yakala',
                      page: YakalamaGame(),
                    ),
                  ),
                );
              });
            }

            if (viewModel.shouldShowTryAgain) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                viewModel.consumeTryAgainDialog();
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Yanlış sıra 😢"),
                    content: const Text("Sahneleri doğru sırayla dizmeyi dene."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          viewModel.resetGame();
                        },
                        child: const Text("Tekrar Dene"),
                      ),
                    ],
                  ),
                );
              });
            }

            return Container(
              width: widthscreen,
              height: heightscreen,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  width: widthscreen*0.9,
                  height: heightscreen*0.8,
                  decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 🔊 Seslendirme butonu
                      IconButton(
                        onPressed: () {
                          tts.speak(
                              "Küçük tavşan Pofuduk, ormanda yeni maceralar arıyordu. "
                                  "Bir göl kenarında rengarenk çiçekler ve kelebekler arasında zıpladı. "
                                  "Birden karşısına sevimli bir sincap çıktı ve ona ormandaki en tatlı havuçları bulacağı gizli bir patika gösterdi.");
                        },
                        icon: const Icon(Icons.volume_up,
                            color: Colors.orange, size: 50),
                      ),

                      // 🎬 Üstteki sahne kutuları
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(3, (index) {
                          final placedImage = viewModel.placedImages[index];
                          return DragTarget<String>(
                            onAcceptWithDetails: (details) {
                              viewModel.placeImage(index, details.data);
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                width: widthscreen * 0.13,
                                height: heightscreen * 0.3,
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(100),
                                  border: Border.all(
                                      color: Colors.orange, width: 3),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: placedImage != null
                                 ? ClipRRect(
                                  borderRadius: BorderRadius.circular(36), // köşe yumuşatma
                              child: Image.asset(
                              'assets/images/oyunlar/hikayesirala/$placedImage.jpeg',
                              fit: BoxFit.contain,
                              ),
                              )
                                  : Center(
                                  child: Text(
                                    '${index + 1}. Sahne',
                                    style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),

                      // 📷 Alt kısım: Resimler aynı hizada
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (var img in viewModel.remainingImages)
                            Draggable<String>(
                              data: img,
                              feedback: Material(
                                color: Colors.transparent,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.asset(
                                    'assets/images/oyunlar/hikayesirala/$img.jpeg',
                                    width: widthscreen * 0.12,
                                    height: heightscreen * 0.3,
                                  ),
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.asset(
                                    'assets/images/oyunlar/hikayesirala/$img.jpeg',
                                    width: widthscreen * 0.12,
                                    height: heightscreen * 0.3,
                                  ),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.asset(
                                  'assets/images/oyunlar/hikayesirala/$img.jpeg',
                                  width: widthscreen * 0.12,
                                  height: heightscreen * 0.3,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
