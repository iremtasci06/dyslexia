import 'package:disleksi_surum/view/theme_selection.dart';
import 'package:disleksi_surum/view/login.dart';
import 'package:disleksi_surum/viewModel/usersinfo_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CocukKayitPage extends StatefulWidget {
  const CocukKayitPage({super.key});

  @override
  State<CocukKayitPage> createState() => _CocukKayitPageState();
}

class _CocukKayitPageState extends State<CocukKayitPage> {
  final TextEditingController _adSoyadController = TextEditingController();
  final TextEditingController _dogumTarihiController = TextEditingController();
  String? _selectedSinif;
  DateTime? _selectedDate;

  final List<String> _siniflar = ['1. Sınıf', '2. Sınıf', '3. Sınıf', '4. Sınıf'];

  @override
  Widget build(BuildContext context) {
    double heightscreen = MediaQuery.of(context).size.height;
    double widthscreen = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/register.jpeg"),
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
                  Expanded(child: Container()),
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
                          const Text(
                            "Çocuk Bilgileri",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Ad Soyad
                          _textField(
                            'Ad Soyad:',
                            controller: _adSoyadController,
                            prefixIcon: Icons.person,
                          ),
                          const SizedBox(height: 10),

                          // Doğum Tarihi
                          TextFormField(
                            controller: _dogumTarihiController,
                            readOnly: true,
                            decoration: _decoration('Doğum Tarihi:', prefixIcon: Icons.cake),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime(2015),
                                firstDate: DateTime(2008),
                                lastDate: DateTime.now(),
                              );

                              if (pickedDate != null) {
                                setState(() {
                                  _selectedDate = pickedDate;
                                  _dogumTarihiController.text =
                                      DateFormat('dd/MM/yyyy').format(pickedDate);
                                });

                                final avm = Provider.of<AvatarViewModel>(context, listen: false);
                                avm.setDogumgunu(pickedDate);
                              }
                            },
                          ),
                          const SizedBox(height: 10),

                          // Sınıf seçimi
                          DropdownButtonFormField<String>(
                            initialValue: _selectedSinif,
                            decoration: _decoration('Sınıf:', prefixIcon: Icons.school),
                            items: _siniflar.map((sinif) {
                              return DropdownMenuItem(
                                value: sinif,
                                child: Text(sinif),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSinif = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),

                          // Devam Et Butonu
                          ElevatedButton(
                            onPressed: () {
                              final avm = Provider.of<AvatarViewModel>(context, listen: false);
                              avm.setAdSoyad(_adSoyadController.text);
                              avm.setDogumgunu(_selectedDate ?? DateTime.now());
                              avm.setSinif(_selectedSinif ?? "");

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ThemeSelectionScreen(),
                                ),
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
                              'DEVAM ET',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Zaten kayıtlı mısınız?',
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
                                  'Giriş Yap',
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
      filled: true,
      fillColor: Colors.white.withAlpha(125),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      prefixIcon: Icon(prefixIcon, color: Colors.black),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _textField(String label,
      {IconData? prefixIcon, Widget? suffixIcon, TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      decoration: _decoration(label, prefixIcon: prefixIcon, suffixIcon: suffixIcon),
    );
  }
}
