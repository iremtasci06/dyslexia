import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/tts_view_model.dart';
import '../../viewModel/userget_view_model.dart';
import '../../models/users_models.dart';

class Yonerge extends StatelessWidget {
  final String text;
  final Widget page;
  final ChangeNotifier Function()? pagevm;

  const Yonerge({
    super.key,
    required this.text,
    required this.page,
    this.pagevm,
  });

  // Navigasyon işlevini bir metot içine alalım, böylece hem ses ikonunda hem de yeni butonda kullanabiliriz.
  void _navigateToNextPage(BuildContext context) {
    Widget nextPage = pagevm == null
        ? page
        : ChangeNotifierProvider(
      create: (_) => pagevm!(),
      child: page,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TtsViewModel>(context, listen: false);
    final widthscreen = MediaQuery.sizeOf(context).width;
    final heightscreen = MediaQuery.sizeOf(context).height;
    final isLandscape = widthscreen > heightscreen;
    final uvm = Provider.of<UserGetViewModel>(context, listen: false);

    return FutureBuilder<Users?>(
      future: uvm.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("Kullanıcı bulunamadı"));
        }

        final user = snapshot.data!;
        final karakter = user.avatarUrl.isNotEmpty
            ? user.avatarUrl
            : 'assets/images/karakter.jpeg'; // default avatar

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Container(
              width: widthscreen,
              height: heightscreen,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Flex(
                    direction: isLandscape ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: isLandscape ? 4 : 3,
                        child: karakter.startsWith('assets/')
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(240),
                          child: Image.asset(
                            karakter,
                            height: isLandscape ? heightscreen * 1 : heightscreen * 0.35,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network(
                            karakter,
                            height: isLandscape ? heightscreen * 0.6 : heightscreen * 0.35,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16, height: 16),
                      Flexible(
                        flex: 5,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(220),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.orange, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(3, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                text,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row( // <<< 1. DEĞİŞİKLİK: İkonları yatay sıralamak için Row eklendi
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Mevcut Ses İkonu
                                  IconButton(
                                    onPressed: () async {
                                      await vm.speak(text);

                                      // Ses bittikten sonra 5 saniye gecikme ile otomatik geçiş (mevcut mantık korunmuştur)
                                      Future.delayed(const Duration(seconds: 5), () {
                                        // Not: Gecikmeden sonra geçiş yaparken,
                                        // kullanıcının bu sırada Devam Et butonuna basmış olma ihtimali
                                        // nedeniyle kontrol eklenmesi gerekebilir,
                                        // ancak mevcut mantıkta bunu koruyoruz.
                                        _navigateToNextPage(context);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.volume_up,
                                      color: Colors.orange,
                                      size: 36,
                                    ),
                                  ),
                                  const SizedBox(width: 24), // İkonlar arasına boşluk

                                  // <<< 2. DEĞİŞİKLİK: Yeni Devam Et butonu (Geri butonu gibi bir ikon)
                                  IconButton(
                                    onPressed: () {
                                      // Konuşma beklenmez, doğrudan diğer sayfaya geçilir.
                                      vm.stop(); // Konuşma varsa durdur
                                      _navigateToNextPage(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward, // İlerleme ikonu
                                      color: Colors.green, // Farklı renk verdik
                                      size: 36,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}