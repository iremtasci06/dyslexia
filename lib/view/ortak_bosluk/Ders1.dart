    import 'dart:math';
    import 'package:disleksi_surum/view/home_harf.dart';
    import 'package:disleksi_surum/view/ortak_bosluk/Ders2.dart';
    import 'package:flutter/material.dart';
    import 'package:provider/provider.dart';
    import '../../utils/colors.dart';
    import '../../viewModel/fonem_view_model.dart';
    import '../../viewModel/game_result_viewmodel.dart';
    import '../../viewModel/game_timer_viewmodel.dart';
    import '../../viewModel/tts_view_model.dart';
    class Ders1 extends StatelessWidget {
    final String arkaPlanResmiYolu;
    final List<Map<String, dynamic>> list;
    final int index;

    const Ders1({
    super.key,
    this.arkaPlanResmiYolu = 'assets/images/background.png',
    required this.list,
    this.index = 0,
    });

    @override
    Widget build(BuildContext context) {
    double widthscreen = MediaQuery.sizeOf(context).width;
    double heightscreen = MediaQuery.sizeOf(context).height;

    final item = list[index];
    final hedefHarf = item['hedefHarf'] as String;
    final dogruHarfResimleri = List<String>.from(item['dogruHarfResimleri']);
    final digerHarfResimleri = List<String>.from(item['digerHarfResimleri']);
    final Color arkaPlanRengi = item['arkaPlanRengi'] ?? AppColors.lila;
    final String mesaj = item['mesaj'] ?? '';
    final List<Map<String, dynamic>> sayfa = item['sonraki'] ?? [];

    final allImages = [...dogruHarfResimleri, ...digerHarfResimleri]..shuffle(Random());

    // Timer’ı build içinde başlatmak için post frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
    final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
    timerVM.reset();
    timerVM.startTimer();
    });

    return Scaffold(
    backgroundColor: arkaPlanRengi,
    body: Stack(
    children: [
    SafeArea(
    child: Container(
    width: widthscreen,
    height: heightscreen,
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage(arkaPlanResmiYolu),
    fit: BoxFit.cover,
    ),
    ),
    child: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Center(
    child: ConstrainedBox(
    constraints: BoxConstraints(
    maxWidth: widthscreen * 0.9,
    maxHeight: heightscreen * 0.9,
    ),
    child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Colors.white.withAlpha(220),
    borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    Wrap(
    alignment: WrapAlignment.center,
    spacing: 10,
    runSpacing: 10,
    children: [
    for (var img in allImages)
    _buildImageButton(context, img, hedefHarf, widthscreen, index, sayfa),
    ],
    ),
    const SizedBox(height: 16),
    Text(
    mesaj,
    textAlign: TextAlign.center,
    style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 12),
    IconButton(
    onPressed: () {
    Provider.of<TtsViewModel>(context, listen: false).speak(mesaj);
    },
    icon: const Icon(Icons.volume_up, color: Colors.orange, size: 30),
    ),
    ],
    ),
    ),
    ),
    ),
    ),
    ),
    ),
    ),
    Positioned(
    top: 10,
    right: 10,
    child: IconButton(
    onPressed: () {
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => HarflerPage()),
    );
    },
    icon: const Icon(Icons.home, color: Colors.white, size: 36),
    style: IconButton.styleFrom(
    backgroundColor: Colors.orange.withAlpha(200),
    shape: const CircleBorder(),
    padding: const EdgeInsets.all(8),
    ),
    ),
    ),
    ],
    ),
    );
    }

    Widget _buildImageButton(
    BuildContext context,
    String img,
    String hedefHarf,
    double widthscreen,
    int index,
    List<Map<String, dynamic>> sayfa,
    ) {
    final vm = Provider.of<FonemViewModel>(context, listen: false);

    return SizedBox(
    width: widthscreen / 4.2,
    height: widthscreen / 4.2,
    child: Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: () async {
    hedefHarf.toLowerCase();
    if (index == 0) {
    vm.Kontrol(hedefHarf, img);
    if (vm.kontrol) {
    final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
    timerVM.stopTimer();

    final vm2 = Provider.of<GameResultViewModel>(context, listen: false);
    await vm2.saveGameResult(
    letter: hedefHarf,
    totalClicks: vm.totalClicks,
    correctClicks: vm.correctClicks,
    durationseconds: timerVM.totalSeconds,
    koleksiyonadi: 'Harfler'
    );
    vm.totalClicks=0;
    timerVM.reset();
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (_) => Ders1(list: list, index: 1),
    ),
    );
    }
    } else if (index == 1) {
    vm.Kontrol2(hedefHarf, img);
    if (vm.kontrol2) {
    final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
    timerVM.stopTimer();

    final vm2 = Provider.of<GameResultViewModel>(context, listen: false);
    await vm2.saveGameResult(
    letter: hedefHarf,
    totalClicks: vm.totalClicks,
    correctClicks: vm.correctClicks,
    durationseconds: timerVM.totalSeconds,
    koleksiyonadi: 'Harfler'
    );
    vm.totalClicks=0;
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (_) => XHarfiSayfaKontrol(list: sayfa),
    ),
    );
    }
    }
    },
    child: Ink(
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.orange, width: 2),
    boxShadow: const [
    BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.15),
    blurRadius: 8,
    offset: Offset(2, 4),
    ),
    ],
    ),
    child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Image.asset(
    'assets/harfler/${img[0].toUpperCase()}/$img.jpeg',
    fit: BoxFit.fill,
    ),
    ),
    ),
    ),
    ),
    );
    }
    }