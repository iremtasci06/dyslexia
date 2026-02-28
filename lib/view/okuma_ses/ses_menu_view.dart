import 'package:disleksi_surum/utils/colors.dart';
import 'package:disleksi_surum/view/okuma_ses/harf_dinle.dart';
import 'package:disleksi_surum/view/okuma_ses/seslendirme_view.dart';
import 'package:flutter/material.dart';

import '../ortak_bosluk/yonerge.dart';

class MenuViewSes extends StatelessWidget {
  const MenuViewSes({super.key});

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
                  _buildHomeButton(context, 'Seslendirme', Icons.mic, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text:"Dinlediğin cümleyi tekrar et" , page: SpeechPage()),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'Hangi harf', Icons.question_mark, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Yonerge(text:"Hangi harfi duyduysan onu seç" , page: LetterQuizPage()),
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