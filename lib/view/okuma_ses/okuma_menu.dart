import 'package:disleksi_surum/view/home.dart';
import 'package:flutter/material.dart';
import '../../utils/hikayeler.dart';
import '../../utils/orientation_helper.dart';
import 'okuma.dart';
// <<< 1. DEĞİŞİKLİK: Anasayfa import edildi

class ColorfulTextPage extends StatefulWidget {
  const ColorfulTextPage({super.key});

  @override
  State<ColorfulTextPage> createState() => _ColorfulTextPageState();
}

class _ColorfulTextPageState extends State<ColorfulTextPage> {
  @override
  void initState() {
    super.initState();
    OrientationHelper.setPortrait();
  }

  @override
  void dispose() {
    OrientationHelper.setLandscape();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECD5BC),
      appBar: AppBar( // <<< 2. DEĞİŞİKLİK: AppBar yapısı değiştirildi
        backgroundColor: const Color(0xFFECD5BC),
        automaticallyImplyLeading: false, // Varsayılan geri tuşunu kaldır
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Geri Butonu (Ok İkonu)
            IconButton(
              onPressed: () {
                // AnasayfaPage'e geçiş yap ve bu sayfayı yığından kaldır
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => AnasayfaPage()),
                );
              },
              icon: const Icon(
                Icons.arrow_back, // Geri ikonu
                color: Colors.black,
                size: 30,
              ),
              style: IconButton.styleFrom(
                // İsteğe bağlı: Butonun arka planı
                backgroundColor: Colors.white.withOpacity(0.5),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(4),
              ),
            ),

            // Başlık Metni
            const Expanded(
              child: Text(
                "Bunları Biliyor Musun ?",
                textAlign: TextAlign.center, // Ortalamak için
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),

            // Başlığı ortalamak için sağda boş bir SizedBox ekliyoruz (Görsel dengeleme)
            const SizedBox(width: 46), // Sol ikonun genişliği kadar boşluk
          ],
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadingPage(storyIndex: index),
                ),
              );
            },
            child: Card(
              color: const Color(0xFF48B3AF),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/soru.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    story.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}