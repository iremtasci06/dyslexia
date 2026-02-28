import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/golge_view_model.dart';

class GolgeEslemePage extends StatelessWidget {
  const GolgeEslemePage({super.key});

  @override
  Widget build(BuildContext context) {
    double widthscreen = MediaQuery.sizeOf(context).width;
    double heightscreen = MediaQuery.sizeOf(context).height;
    List<String> img = ['tavsan','ayi','civciv'];
    img.shuffle(Random());
    return ChangeNotifierProvider(
      create: (_) => GolgeOyunViewModel(),
      child: Scaffold(
        backgroundColor: Colors.lightBlue.shade50,
        body: Container(
          width: widthscreen,
          height: heightscreen,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover
            ),
          ),
          child: Consumer<GolgeOyunViewModel>(
            builder: (context, viewModel, child) {

              return Center(
                child: Container(
                  width: widthscreen * 0.9, // genişliği ekranın %90’ı
                  height: heightscreen * 0.5,
                  decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 🟪 GÖLGELER (ÜSTTE)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (var target in img)
                            DragTarget<String>(
                              onAcceptWithDetails: (details) {
                                viewModel.checkMatch(details.data, target,context);
                              },
                              builder: (context, candidateData, rejectedData) {
                                bool matched = viewModel.isMatched(target);
                                return Container(
                                  width: widthscreen * 0.25,
                                  height: heightscreen * 0.25,
                                  decoration: BoxDecoration(
                                    color: matched
                                        ? Colors.green.shade100
                                        : Colors.grey.shade300,
                                    border: Border.all(
                                      color: matched ? Colors.green : Colors.black26,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: matched
                                      ? Image.asset(
                                    'assets/images/oyunlar/${target}.jpeg',
                                    fit: BoxFit.contain,
                                  )
                                      : Image.asset(
                                    'assets/images/oyunlar/golge_${target}.jpeg',
                                    fit: BoxFit.contain,
                                  ),
                                );
                              },
                            ),
                        ],
                      ),

                      // 🟩 ŞEKİLLER (ALTTA)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (var shape in viewModel.remainingShapes)
                            Draggable<String>(
                              data: shape,
                              feedback: Image.asset(
                                'assets/images/oyunlar/$shape.jpeg',
                                width: widthscreen * 0.2,
                                height: heightscreen * 0.2,
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.3,
                                child: Image.asset(
                                  'assets/images/oyunlar/$shape.jpeg',
                                  width: widthscreen * 0.2,
                                  height: heightscreen * 0.2,
                                ),
                              ),
                              child: Image.asset(
                                'assets/images/oyunlar/$shape.jpeg',
                                width: widthscreen * 0.2,
                                height: heightscreen * 0.2,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
