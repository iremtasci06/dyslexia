import 'package:disleksi_surum/utils/colors.dart';
import 'package:disleksi_surum/utils/listname.dart';
import 'package:disleksi_surum/view/ortak_bosluk/agac.dart';
import 'package:disleksi_surum/view/ortak_bosluk/balon_view.dart';
import 'package:disleksi_surum/view/ortak_bosluk/Ders3.dart';
import 'package:disleksi_surum/view/ortak_bosluk/Ders2.dart';
import 'package:disleksi_surum/view/ortak_bosluk/Ders1.dart';
import 'package:disleksi_surum/view/ortak_bosluk/animation.dart';
import 'package:flutter/material.dart';

class NMenuView extends StatelessWidget {
  const NMenuView({super.key});

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
                  _buildHomeButton(context, 'Harf İzle', Icons.abc, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Start(
                          harf: 'n',
                          video: 'assets/harfler/U/U.mp4',
                        ),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'N Avcısı', Icons.search, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Ders1(list: listem['n']!,index: 0,),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'M mi N mi ?', Icons.question_mark, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => XHarfiSayfaKontrol(list: listem['n2']!),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'Farklı olanı bul!', Icons.priority_high, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PDers3(harf: 'n',img: ['n','m','m','m','m','m'],),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'Ağaçtan elma topla!', Icons.touch_app, (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HarfToplaPage(hedefHarf: "n", harfListesi: ['n', 'u', 'm', 'n', 'u', 'm', 'm', 'n', 'u', 'n', 'n'],),
                      ),
                    );
                  }),
                  _buildHomeButton(context, 'Balon Oyunu!', Icons.touch_app, (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HarfBulPage(hedefHarf: 'n', harfListesi: ['n', 'u', 'm', 'n', 'u', 'm', 'm', 'n', 'u', 'n', 'n'],)
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