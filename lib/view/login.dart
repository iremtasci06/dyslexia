import 'dart:io';
import 'package:disleksi_surum/viewModel/auth_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:disleksi_surum/view/home.dart';
import 'package:disleksi_surum/view/register_family.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double heightscreen = MediaQuery.of(context).size.height;
    final double widthscreen = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: heightscreen),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Expanded(child: SizedBox()), // Üst boşluk

                  // Alt form alanı
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
                          const SizedBox(height: 40),
                          _textField(
                            'Kullanıcı adınız:',
                            prefixIcon: Icons.person,
                            controller: _usernameController,
                          ),
                          const SizedBox(height: 12),
                          _textField(
                            'Şifreniz:',
                            prefixIcon: Icons.lock,
                            suffixIcon: const Icon(Icons.visibility_off, color: Colors.black),
                            controller: _passwordController,
                          ),
                          const SizedBox(height: 10),

                          // “Beni Hatırla” ve “Şifremi Unuttum” satırı
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.check_box_outline_blank,
                                      size: 18, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text('Beni Hatırla',
                                      style: TextStyle(color: Colors.white, fontSize: 15)),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('Şifremi Unuttum',
                                    style: TextStyle(color: Colors.blue, fontSize: 15)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Giriş butonu
                          ElevatedButton(
                            onPressed: () async {
                              // Ekranı yatay moda al

                              final userVM = Provider.of<AuthViewModel>(context,listen: false);
                              final result = await userVM.loginUser(
                                _usernameController.text.trim(),
                                _passwordController.text.trim(),
                              );

                              if (result != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(content: Text(
                                      result)),

                                );
                                return;
                              }
                              await SystemChrome.setPreferredOrientations([
                                DeviceOrientation.landscapeLeft,
                                DeviceOrientation.landscapeRight,
                              ]);
                                // 🔸 Giriş başarılı → Ana sayfaya yönlendir
                                Navigator.pushReplacement(
                                  context,
                                  Platform.isIOS
                                      ? CupertinoPageRoute(builder: (
                                      _) => const AnasayfaPage())
                                      : MaterialPageRoute(builder: (
                                      _) => const AnasayfaPage()),
                                );
                              },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'GİRİŞ',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Kayıt yönlendirme
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hesabın yok mu?',
                                style: TextStyle(
                                  color: Colors.white.withAlpha(150),
                                  fontSize: 16,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const KayitPage()),
                                  );
                                },
                                child: const Text(
                                  'Kayıt Ol',
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

  InputDecoration _decoration(String label,
      {IconData? prefixIcon, Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
      filled: true,
      fillColor: Colors.white.withAlpha(120),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      prefixIcon: Icon(prefixIcon, color: Colors.black),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _textField(String label,
      {TextEditingController? controller, IconData? prefixIcon, Widget? suffixIcon}) {
    return TextFormField(
      controller: controller,
      decoration: _decoration(label, prefixIcon: prefixIcon, suffixIcon: suffixIcon),
    );
  }
}
