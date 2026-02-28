import 'package:disleksi_surum/view/home_harf.dart';
import 'package:disleksi_surum/view/okuma_ses/write_menu_view.dart';
import 'package:disleksi_surum/view/play_views/menu_views.dart';
import 'package:disleksi_surum/view/sayilar/sayi_menu_view.dart';
import 'package:disleksi_surum/view/okuma_ses/ses_menu_view.dart';
import 'package:disleksi_surum/view/time_and_yon/zaman_menu_views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/tts_view_model.dart';
import 'okuma_ses/okuma_menu.dart';

class AnasayfaPage extends StatelessWidget {
  const AnasayfaPage({super.key});

  @override
  Widget build(BuildContext context) {
    double heightscreen = MediaQuery.sizeOf(context).height;
    double widthscreen = MediaQuery.sizeOf(context).width;
    final vm = Provider.of<TtsViewModel>(context);

    // Responsive boyutlar
    double buttonWidth = widthscreen * 0.18;
    double buttonHeight = heightscreen * 0.22;
    double iconSize = heightscreen * 0.05;

    return Scaffold(
      body: Container(
        height: heightscreen,
        width: widthscreen,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: widthscreen * 0.05, // yatay boşluk
              runSpacing: heightscreen * 0.03, // dikey boşluk
              children: [
                buildCategory(context, vm, 'harf', 'Harfleri Öğrenelim', buttonWidth, buttonHeight, iconSize,HarflerPage()),
                buildCategory(context, vm, 'sayi', 'Sayıları Öğrenelim', buttonWidth, buttonHeight, iconSize,MenuViewSayi()),
                buildCategory(context, vm, 'oyun', 'Oynarken Öğrenelim', buttonWidth, buttonHeight, iconSize,MenuView_Oyun()),
                buildCategory(context, vm, 'zaman-yon', 'Zamanları Öğrenelim', buttonWidth, buttonHeight, iconSize,ZamanMenuView()),
                buildCategory(context, vm, 'okuma', 'Okuma Yapalım', buttonWidth, buttonHeight, iconSize,ColorfulTextPage()),
                buildCategory(context, vm, 'dinleme', 'Dinleme Yapalım', buttonWidth, buttonHeight, iconSize,MenuViewSes()),
                buildCategory(context, vm, 'yazma', 'Yazı Yazalım', buttonWidth, buttonHeight, iconSize,MenuViewWrite()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategory(BuildContext context, TtsViewModel vm, String imagePath, String speakText,
      double width, double height, double iconSize,Widget page) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => page));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: EdgeInsets.zero,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/$imagePath.png',
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        IconButton(
          onPressed: () => vm.speak(speakText),
          icon: Icon(Icons.volume_up, size: iconSize, color: Colors.black),
        ),
      ],
    );
  }
}
