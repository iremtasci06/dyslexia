import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../utils/orientation_helper.dart';
import '../../viewModel/hafiza_view_model.dart';
import 'game_view.dart';

class HafizaPage extends StatefulWidget {
  const HafizaPage({super.key});

  @override
  State<HafizaPage> createState() => _HafizaPageState();
}

class _HafizaPageState extends State<HafizaPage> {
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
            if (vm.shouldShowCompletedDialog) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                vm.consumeCompletedDialog();
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Tebrikler!"),
                    content: const Text("Tüm kartları eşleştirdiniz 🎉"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const GameView()),
                          );
                        },
                        child: const Text("Sonraki Sayfa"),
                      ),
                    ],
                  ),
                );
              });
            }

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
                          onTap: () => vm.onCardTap(index),
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
