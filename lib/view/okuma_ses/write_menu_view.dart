import 'package:disleksi_surum/utils/colors.dart';
import 'package:disleksi_surum/view/okuma_ses/yazma_view.dart';
import 'package:flutter/material.dart';

import '../ortak_bosluk/yonerge.dart';

class MenuViewWrite extends StatelessWidget {
  const MenuViewWrite({super.key});

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
                  _buildHomeButton(context, 'p', Icons.mic, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text:"Haydi p yazalım" , page: LetterTracePage(imagePath: "assets/images/write/p.png",videoPath: "assets/images/write/d.mp4",),),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'B', Icons.question_mark, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text:"Haydi B yazalım" , page: LetterTracePage(imagePath: "assets/images/write/b_b.png",videoPath: "assets/images/write/d.mp4",),),
                      ),
                    );
                  }),
                 _buildHomeButton(context, 'D', Icons.question_mark, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text:"Haydi D yazalım" , page: LetterTracePage(imagePath: "assets/images/write/b_d.png",videoPath: "assets/images/write/d.mp4",),),
                      ),
                    );
                  }),_buildHomeButton(context, 'M', Icons.question_mark, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text:"Haydi M yazalım" , page: LetterTracePage(imagePath: "assets/images/write/b_m.png",videoPath: "assets/images/write/d.mp4",),),
                      ),
                    );
                  }),_buildHomeButton(context, 'N', Icons.question_mark, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text:"Haydi N yazalım" , page: LetterTracePage(imagePath: "assets/images/write/b_n.png",videoPath: "assets/images/write/d.mp4",),),
                      ),
                    );
                  }),_buildHomeButton(context, 'U', Icons.question_mark, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text:"Haydi U yazalım" , page: LetterTracePage(imagePath: "assets/images/write/b_u.png",videoPath: "assets/images/write/d.mp4",),),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'b', Icons.question_mark, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text:"Haydi b yazalım" , page: LetterTracePage(imagePath: "assets/images/write/k_b.png",videoPath: "assets/images/write/d.mp4",),),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'd', Icons.question_mark, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text:"Haydi d yazalım" , page: LetterTracePage(imagePath: "assets/images/write/k_d.png",videoPath: "assets/images/write/d.mp4",),),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'n', Icons.question_mark, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Yonerge(text:"Haydi n yazalım" , page: LetterTracePage(imagePath: "assets/images/write/k_n.png",videoPath: "assets/images/write/d.mp4",),),
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