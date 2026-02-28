import 'package:disleksi_surum/view/login.dart';
import 'package:disleksi_surum/view/register_child.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewModel/usersinfo_viewmodel.dart';


class KayitPage extends StatefulWidget {
  const KayitPage({super.key});

  @override
  State<KayitPage> createState() => _KayitPageState();
}

class _KayitPageState extends State<KayitPage> {
  late TextEditingController emailcontroller;
  late TextEditingController usernamecontroller;
  late TextEditingController passcontroller;
  late TextEditingController conpasscontroller;

  @override
  void initState() {
    super.initState();
    emailcontroller = TextEditingController();
    usernamecontroller = TextEditingController();
    passcontroller = TextEditingController();
    conpasscontroller = TextEditingController();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    usernamecontroller.dispose();
    passcontroller.dispose();
    conpasscontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatarVM = Provider.of<AvatarViewModel>(context, listen: false);

    double heightscreen = MediaQuery.of(context).size.height;
    double widthscreen = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true, // klavye açıldığında kaydırma aktif
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/register.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView( // ✅ tüm sayfa kayabilir
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: heightscreen, // tam ekran yüksekliği
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Üst kısım boşluğu ekran boyutuna göre otomatik dengelenir
                  Expanded(child: Container()),

                  // Alt kısımdaki form alanı
                  Container(
                    width: widthscreen,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withAlpha(0),
                          Colors.black.withAlpha(180),
                          Colors.black.withAlpha(230),
                          Colors.black.withAlpha(255),
                        ],
                      ),
                    ),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _textField('Email:', prefixIcon: Icons.email,controller: emailcontroller),
                          const SizedBox(height: 10),
                          _textField('Kullanıcı adınız:', prefixIcon: Icons.person,controller: usernamecontroller),
                          const SizedBox(height: 10),
                          _textField('Şifreniz:',
                              prefixIcon: Icons.lock,
                              suffixIcon: const Icon(Icons.visibility_off, color: Colors.black),
                          controller:passcontroller ),
                          const SizedBox(height: 10),
                          _textField('Tekrar Şifreniz:',
                              prefixIcon: Icons.lock_reset,
                              suffixIcon: const Icon(Icons.visibility_off, color: Colors.black),
                          controller: conpasscontroller),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              avatarVM.setEmail(emailcontroller.text.trim());
                              avatarVM.setUsername(usernamecontroller.text);
                              avatarVM.setSifre(passcontroller.text);
                              Navigator.push(context,
                                MaterialPageRoute(builder: (_) => const CocukKayitPage()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text(
                              'Devam Et',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hesabın var mı?',
                                style: TextStyle(
                                  color: Colors.white.withAlpha(160),
                                  fontSize: 16,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LoginPage()),
                                  );
                                },
                                child: const Text(
                                  'Giriş',
                                  style: TextStyle(color: Colors.orange, fontSize: 16),
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
  }

  // Decoration fonksiyonu
  InputDecoration _decoration(String label,
      {IconData? prefixIcon, Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white.withAlpha(125),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      prefixIcon: Icon(prefixIcon, color: Colors.black),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

// TextField fonksiyonu
  Widget _textField(String label,
      {TextEditingController? controller, IconData? prefixIcon, Widget? suffixIcon}) {
    return TextFormField(
      controller: controller, // Controller burada kullanılıyor
      decoration: _decoration(label, prefixIcon: prefixIcon, suffixIcon: suffixIcon),
    );
  }
}
