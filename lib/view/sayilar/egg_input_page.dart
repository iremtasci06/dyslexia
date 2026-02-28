import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/eggviewmodel.dart';
import 'card_sayi.dart';

class EggInputPage extends StatefulWidget {
  const EggInputPage({super.key});

  @override
  State<EggInputPage> createState() => _EggInputPageState();
}

class _EggInputPageState extends State<EggInputPage> {
  List<String> harf = ['2', '5', '6', '9'];
  final List<TextEditingController> controllers =
  List.generate(4, (_) => TextEditingController());

  // Yanlış değer için dialog kontrolü
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    harf.shuffle();

    for (int i = 0; i < controllers.length; i++) {
      controllers[i].addListener(() {
        final vm = context.read<EggInputViewModel>();
        vm.SayiKontrol(harf[i], controllers[i].text);

        if (!vm.kontrol && controllers[i].text.isNotEmpty && !_isDialogShowing) {
          _isDialogShowing = true;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Yanlış değer!"),
              content: Text("Girdiğiniz değer ${controllers[i].text} yanlış."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _isDialogShowing = false;
                    controllers[i].clear(); // İsteğe bağlı: yanlış değeri sil
                  },
                  child: const Text("Tamam"),
                ),
              ],
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widths = MediaQuery.sizeOf(context).width;
    double heights = MediaQuery.sizeOf(context).height;

    return ChangeNotifierProvider(
      create: (_) => EggInputViewModel(),
      child: Scaffold(
        body: Container(
          width: widths,
          height: heights,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isLandscape =
                          MediaQuery.of(context).size.width >
                              MediaQuery.of(context).size.height;

                      if (isLandscape) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                              4, (index) => Expanded(child: eggItem(harf[index], controllers[index]))),
                        );
                      } else {
                        return Column(
                          children: List.generate(
                              4,
                                  (index) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: eggItem(harf[index], controllers[index]),
                              )),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  Consumer<EggInputViewModel>(
                    builder: (context, vm, child) {
                      return ElevatedButton(
                        onPressed: vm.kontrol
                            ? () {
                         Navigator.push(context, MaterialPageRoute(builder: (_)=>RapidRecognitionScreen()));
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Devam Et",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget eggItem(String harf, TextEditingController controller) {
    return Column(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: Image.asset('assets/images/sayilar/egg_$harf.jpeg'),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "?",
              contentPadding: const EdgeInsets.symmetric(vertical: 6),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.brown),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
