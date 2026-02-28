import 'package:disleksi_surum/utils/colors.dart';
import 'package:disleksi_surum/view/ortak_bosluk/yonerge.dart';
import 'package:disleksi_surum/view/play_views/adventuremenu.dart';
import 'package:disleksi_surum/view/play_views/game_view.dart';
import 'package:disleksi_surum/view/play_views/hafiza_view.dart';
import 'package:disleksi_surum/view/play_views/hikaye_sirala_view.dart';
import 'package:disleksi_surum/view/play_views/oruntu_view.dart';
import 'package:disleksi_surum/view/play_views/yakala_view.dart';
import 'package:flutter/material.dart';

import 'golge_view.dart';

class MenuView_Oyun extends StatelessWidget {
  const MenuView_Oyun({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
            opacity: 0.4,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildHomeButton(context, 'Gölge', Icons.sports_esports, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text: "Gölgeleri Eşleştirelim", page: GolgeEslemePage()),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'Hikaye Sıralama', Icons.school, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text: "Pofuduk' a yardım edelim mi ?", page: HikayeSiralaPage()),
                      ),
                    );
                  }),
                  _buildHomeButton(context, "Sincap'ı yakala", Icons.book, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text: "Yakala !", page: YakalamaGame()),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'Örüntü', Icons.elevator, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text: "Örüntüyü devam ettir", page: Iqtest())),
                    );
                  }),
                  _buildHomeButton(context, 'Hafıza Kartları', Icons.videogame_asset, () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const Yonerge(text: "Hafıza Kartlarını Eşleştir", page: HafizaPage())),
                    );
                  }),
                  _buildHomeButton(context, 'Araba Yarışına', Icons.brush, () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>Yonerge(
                       text: "Araba yarışına ne dersin?",
                       page: GameView(),

                     ),
                      ),

                    );
                  }),
                  _buildHomeButton(context, 'Macera Zamanı', Icons.brush, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>Yonerge(
                          text: "Macera Zamanı",
                          page: AdventureMenu(),

                        ),
                      ),

                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeButton(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppColors.mavi),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.orange,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}