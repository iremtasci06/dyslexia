import 'package:disleksi_surum/view/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/users_models.dart';
import '../utils/theme.dart';
import '../viewModel/usersinfo_viewmodel.dart';
import '../viewModel/register_view_model.dart';

class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final avatarVM = Provider.of<AvatarViewModel>(context, listen: false);
    final registerVM = Provider.of<RegisterViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Oyun Arkadaşı Seç'),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // GridView genişliği sabitlenmiş
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: appThemes.length,
                itemBuilder: (context, index) {
                  final theme = appThemes[index];

                  return GestureDetector(
                    onTap: () {
                      avatarVM.selectAvatar(theme.themeIcon); // avatar seçiliyor
                    },
                    child: Card(
                      color: theme.primaryColor.withAlpha(200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              theme.themeIcon,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            theme.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Devam Et Butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final avm = Provider.of<AvatarViewModel>(context, listen: false);
                  final user = Users(
                    email: avm.email ?? "",
                    username: avm.username ?? "",
                    sifre: avm.sifre ?? "",
                    childName: avm.adsoyad ?? "",
                    childAge:  avm.dogumgunu ?? DateTime.now(),
                    childClass: avm.sinif ?? "",
                    avatarUrl: avm.selectedAvatar ?? "",
                  );

                  final result = await registerVM.addUser(user);
                  if (result == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Kayıt başarılı!")),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  } else {
                    debugPrint(avm.email);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result)),
                    );
                  }
                },
                child: const Text("KAYDINI TAMAMLA"),
              ),
            ),
                /*onPressed: () async {
                  final registerVM = Provider.of<RegisterViewModel>(context, listen: false);

                  final user = Users(
                  username: _adSoyadController.text.trim(),
                  email: _emailController.text.trim(),
                  sifre: _sifreController.text.trim(),
                  );
                  final result = await registerVM.addUser(user);
                  if (result == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Kayıt başarılı!")),);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginPage(), // Sayfa geçişi
                    ),
                  );
                  } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result)),);}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'KAYDINI TAMAMLA',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
