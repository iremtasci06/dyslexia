import 'package:disleksi_surum/utils/colors.dart';
import 'package:disleksi_surum/view/sayilar/card_sayi.dart';
import 'package:disleksi_surum/view/sayilar/farklisayi.dart';
import 'package:flutter/material.dart';
import '../ortak_bosluk/yonerge.dart';
import 'egg_input_page.dart';
import 'modern_bear_head_view.dart';

class MenuViewSayi extends StatelessWidget {
  const MenuViewSayi({super.key});

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
                  _buildHomeButton(context, 'Boyama', Icons.brush, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text:"Boyama yapmaya ne dersin ?", page: ModernBearHeadView()),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'Kaç yumurta ?', Icons.question_mark, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text:"Her kümeste kaç yumurta olduğunu yazar mısın ?", page: EggInputPage()),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'Farklı olanı bul!', Icons.priority_high, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text:"Farklı olan sayı hangisi?", page: SayiFark()),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'Ters Sayılar!', Icons.compare_arrows_sharp, (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Yonerge(text:"Farklı olan sayı hangisi?", page: RapidRecognitionScreen()),
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