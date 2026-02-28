import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../viewModel/game_result_viewmodel.dart';
import '../../viewModel/game_timer_viewmodel.dart';
import '../../viewModel/harfsecviewmodel.dart';
import '../../viewModel/tts_view_model.dart';

class HarfSecSayfa extends StatelessWidget {
  final String resimYolu;
  final String dogruHarf;
  final String kelime;
  final String tam;
  final Widget sonrakiSayfa;

  const HarfSecSayfa({
    super.key,
    required this.resimYolu,
    required this.dogruHarf,
    required this.kelime,
    required this.tam,
    required this.sonrakiSayfa,
  });

  @override
  Widget build(BuildContext context) {
    final ttsViewModel = Provider.of<TtsViewModel>(context);
    final dvm = Provider.of<SecViewModel>(context, listen: false);
    double widthscreen = MediaQuery.sizeOf(context).width;
    double heightscreen = MediaQuery.sizeOf(context).height;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      dvm.harf = dogruHarf;
      dvm.karistir();
      dvm.reset();
    });

    return Scaffold(
      backgroundColor: AppColors.sari,
      body: Container(
        width: widthscreen,
        height: heightscreen,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Consumer<SecViewModel>(
            builder: (context, dvm, _) => Center(
              child: SingleChildScrollView(
                child: Container(
                  width: widthscreen * 0.9,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(220),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      bool isNarrow = constraints.maxWidth < 600; // küçük ekran kontrolü
                      return isNarrow
                          ? _buildVerticalLayout(context, ttsViewModel, dvm)
                          : _buildHorizontalLayout(context, ttsViewModel, dvm);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Yatay düzen (tablet veya geniş ekranlar için)
  Widget _buildHorizontalLayout(
      BuildContext context, TtsViewModel ttsViewModel, SecViewModel dvm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Görsel
        Flexible(
          flex: 1,
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(resimYolu)),
            ),
          ),
        ),
        const SizedBox(width: 25),

        // Yazı ve harf seçenekleri
        Flexible(
          flex: 2,
          child: _buildContent(context, ttsViewModel, dvm),
        ),
      ],
    );
  }

  /// 🔹 Dikey düzen (küçük ekranlar için)
  Widget _buildVerticalLayout(
      BuildContext context, TtsViewModel ttsViewModel, SecViewModel dvm) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 220,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(resimYolu)),
          ),
        ),
        const SizedBox(height: 16),
        _buildContent(context, ttsViewModel, dvm),
      ],
    );
  }

  /// 🔹 Ortak içerik kısmı (kelime, ses, butonlar)
  Widget _buildContent(
      BuildContext context, TtsViewModel ttsViewModel, SecViewModel dvm) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          kelime,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        IconButton(
          onPressed: () => ttsViewModel.speak(tam),
          icon: const Icon(Icons.volume_up, size: 40, color: Colors.orange),
        ),
        const SizedBox(height: 10),
        const Text(
          'Hangi harf gelmeli?',
          style: TextStyle(color: Colors.green, fontSize: 22),
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            for (var harf in dvm.secenekler)
              _secenekButton(context, harf, dvm),
          ],
        ),
      ],
    );
  }

  Widget _secenekButton(BuildContext context, String harf, SecViewModel dvm) {
    return SizedBox(
      width: 80,
      height: 80,
      child: OutlinedButton(
        onPressed: () async{
          dvm.DKontrol(harf);
          if (dvm.dogru) {
            final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
            timerVM.stopTimer();

            final vm2 = Provider.of<GameResultViewModel>(context, listen: false);
            await vm2.saveGameResult(
              letter: dvm.harf,
              totalClicks: dvm.totalClicks,
              correctClicks: dvm.correctClicks,
              durationseconds: timerVM.totalSeconds,
                koleksiyonadi: 'Harfler'
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => sonrakiSayfa),
            ).then((_) => dvm.reset());
          }
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.green, width: 2),
          backgroundColor: Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          harf,
          style: const TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}
