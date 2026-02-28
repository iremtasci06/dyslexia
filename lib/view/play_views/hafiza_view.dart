import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../viewModel/hafiza_view_model.dart';

class HafizaPage extends StatefulWidget {
  const HafizaPage({super.key});

  @override
  State<HafizaPage> createState() => _HafizaPageState();
}

class _HafizaPageState extends State<HafizaPage> {

  @override
  void dispose() {
    // Sayfa kapanınca tekrar yatay moda al
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // Ekranı dikey moda sabitle
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
      create: (_) => HafizaViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.mavi,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.mavi,
          title: const Text('Hafıza Oyunu'),
        ),
        body: Consumer<HafizaViewModel>(
          builder: (context, vm, child) {
            return Padding(
              padding: const EdgeInsets.only(top: 80,right: 8,left: 8),
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: GridView.builder(
                      itemCount: vm.cards.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => vm.onCardTap(index, context),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: vm.revealed[index]
                                  ? Image.asset(vm.cards[index], fit: BoxFit.cover)
                                  : Container(
                                color: Color(0xff450693),
                                child: const Icon(
                                  Icons.help,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
