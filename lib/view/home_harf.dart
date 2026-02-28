import 'package:disleksi_surum/view/b/menu_view.dart';
import 'package:disleksi_surum/view/home.dart';
import 'package:disleksi_surum/view/m/menu_view.dart';
import 'package:disleksi_surum/view/n/menu_view.dart';
import 'package:disleksi_surum/view/p/menu_view.dart';
import 'package:disleksi_surum/view/u/menu_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'd/menu_view.dart';
 // <<< 1. DEĞİŞİKLİK: Anasayfa import edildi

class HarflerPage extends StatefulWidget {
  const HarflerPage({super.key});

  @override
  State<HarflerPage> createState() => _HarflerPageState();
}

class _HarflerPageState extends State<HarflerPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widths = MediaQuery.sizeOf(context).width;
    double heights = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFEAEA),
      body: Stack( // <<< 2. DEĞİŞİKLİK: Stack widget'ı eklendi
        children: [
          Container(
            width: widths,
            height: heights,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffBBDCE5),
                  Color(0xffFFC6C6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding( // <<< 3. DEĞİŞİKLİK: Üstten boşluk için Padding eklendi
              padding: const EdgeInsets.only(top: 50.0), // İkona yer açar
              child: GridView.count(
                crossAxisCount: 3, // 3 sütun
                crossAxisSpacing: 8.0, // yatay boşluk
                mainAxisSpacing: 4.0, // dikey boşluk
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                childAspectRatio: 1.5,
                children: [
                  // Mevcut _buildMenuButton listesi buraya taşındı...
                  _buildMenuButton(
                    context,
                    imagePath: 'assets/harfler/P/p.jpeg',
                    label: 'P Harfi',
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (_) => MenuView()),);
                    },
                  ),
                  _buildMenuButton(
                    context,
                    imagePath: 'assets/harfler/D/d.jpeg',
                    label: 'D Harfi',
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => DMenuView()),
                      );
                    },
                  ),
                  _buildMenuButton(
                    context,
                    imagePath: 'assets/harfler/B/b.jpeg',
                    label: 'B Harfi',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BMenuView(),
                        ),
                      );
                    },
                  ),
                  _buildMenuButton(
                    context,
                    imagePath: 'assets/harfler/U/u.jpeg',
                    label: 'U Harfi',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UMenuView(),
                        ),
                      );
                    },
                  ),

                  _buildMenuButton(
                    context,
                    imagePath: 'assets/harfler/M/m.jpeg',
                    label: 'M Harfi',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MMenuView(),
                        ),
                      );
                    },
                  ),
                  _buildMenuButton(
                    context,
                    imagePath: 'assets/harfler/N/n.jpeg',
                    label: 'N Harfi',
                    onPressed: () {
                      Navigator.push( // Burası pushReplacement'tan push'a çevrildi, daha mantıklı.
                        context,
                        MaterialPageRoute(
                          builder: (_) => NMenuView(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // <<< 4. DEĞİŞİKLİK: Geri butonu ikonu eklendi
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              onPressed: () {
                // AnasayfaPage'e geri dönülür ve HarflerPage yığından kaldırılır
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AnasayfaPage()),
                );
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 36),
              style: IconButton.styleFrom(
                backgroundColor: Colors.blueAccent.withOpacity(0.7),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // _buildMenuButton metodu buranın altında devam eder...
  Widget _buildMenuButton(
      BuildContext context, {
        required String imagePath,
        required VoidCallback onPressed,
        String? label,
      }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 110,
          height: 130,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onPressed,
            splashColor: const Color.fromRGBO(255, 255, 255, 0.2),
            child: Ink(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  const BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    blurRadius: 8,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ],
    );
  }
}