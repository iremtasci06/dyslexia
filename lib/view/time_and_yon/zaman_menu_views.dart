import 'package:disleksi_surum/utils/colors.dart';
import 'package:disleksi_surum/view/time_and_yon/asansor_view.dart';
import 'package:disleksi_surum/view/time_and_yon/days_view.dart';
import 'package:disleksi_surum/view/time_and_yon/k%C4%B1s_views.dart';
import 'package:disleksi_surum/view/time_and_yon/month.dart';
import 'package:disleksi_surum/view/time_and_yon/sagsol_view.dart';
import 'package:disleksi_surum/view/time_and_yon/week_days.dart';
import 'package:flutter/material.dart';
import '../ortak_bosluk/yonerge.dart';

class ZamanMenuView extends StatelessWidget {
  const ZamanMenuView({super.key});

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
                  _buildHomeButton(context, 'mevsimler', Icons.sports_esports, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text: "Mevsimleri Öğrenelim", page: KisViews()),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'Günler', Icons.school, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text: "Günleri Öğrenelim", page: TimeTrainScreen()),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'Yukarı-Aşağı', Icons.book, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text: "Asansör ile arkadaşımıza yardım edelim", page: ElevatorGamePage()),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'Sağ-Sol', Icons.elevator, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text: "Ayıya yardım edelim ve bal yesin", page: LeftRightGamePage()),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'Haftanın Günleri', Icons.videogame_asset, () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Yonerge(text: "Haftanın günlerini sıraya dizelim", page: WeekDays()),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'Aylar', Icons.brush, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Yonerge(text: "Ayları sıraya dizelim", page: Months()),
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