import 'package:disleksi_surum/viewModel/themeNotifier_view_model.dart';
import 'package:disleksi_surum/viewModel/usersinfo_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:disleksi_surum/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Uygulama açılıyor mu?", (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeNotifier()),
          ChangeNotifierProvider(create: (_) => AvatarViewModel()),
          // Tüm ViewModel’leri buraya ekle!!!
        ],
        child: const MyApp(),
      ),
    );

    expect(find.byType(MyApp), findsOneWidget);
  });
}
