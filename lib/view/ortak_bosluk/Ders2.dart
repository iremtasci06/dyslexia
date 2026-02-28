import 'package:disleksi_surum/view/ortak_bosluk/Ders3.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/game_timer_viewmodel.dart';
import 'harf_sec_page.dart';
import 'yonerge.dart';

//Bu sayfada 2 harf arası seçim yapılır. örnek : D B ?
class XHarfiSayfaKontrol extends StatefulWidget {
  final List<Map<String, dynamic>> list;
  //pkelimelistesi,dkelimelistesi
  const XHarfiSayfaKontrol({super.key,required this.list});

  @override
  State<XHarfiSayfaKontrol> createState() => _PHarfiSayfaKontrolState();
}

class _PHarfiSayfaKontrolState extends State<XHarfiSayfaKontrol> {
  @override
  void initState() {
    super.initState();
    // Timer başlat
    final timerVM = Provider.of<GameTimerViewModel>(context, listen: false);
    timerVM.reset();
    timerVM.startTimer();
  }
  int index = 0;

  @override
  Widget build(BuildContext context) {

    final veri = widget.list[index];

    return HarfSecSayfa(
      resimYolu: veri['resim'],
      dogruHarf: veri['dogruHarf'],
      kelime: veri['kelime'],
      tam: veri['tam'],
      sonrakiSayfa: PHarfiSayfaKontrolSonraki(
        list:widget.list,
        sonrakiIndex: index + 1,
      ),
    );
  }
}

class PHarfiSayfaKontrolSonraki extends StatelessWidget {
  final List<Map<String, dynamic>> list;
  final int sonrakiIndex;
  const PHarfiSayfaKontrolSonraki({super.key, required this.sonrakiIndex,required this.list});

  @override
  Widget build(BuildContext context) {
    final veri = list[sonrakiIndex];
    String harf =veri['dogruHarf'];
    final harf2 =tumListeler['${harf}']![0]['harf'];
    debugPrint('harfmiz: '+harf2);
    final list2 = tumListeler['${harf}']![0]['img'];
    debugPrint(list2.toString());
    return HarfSecSayfa(
      resimYolu: veri['resim'],
      dogruHarf: veri['dogruHarf'],
      kelime: veri['kelime'],
      tam: veri['tam'],
      sonrakiSayfa: sonrakiIndex + 1 < list.length
          ? PHarfiSayfaKontrolSonraki(sonrakiIndex: sonrakiIndex + 1,list: list,)
          : Yonerge(text: 'Farklı olanı bul!', page: PDers3(harf: harf2, img: list2),
        //PDers3(harf: list2[0]['harf'], img: list2[0]['img'],)
      ),
    );
  }
}