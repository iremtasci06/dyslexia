import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../viewModel/yazma_view_model.dart';

class LetterTracePage extends StatefulWidget {
  final String imagePath; // Harf resmi
  final String videoPath; // Video yolu

  const LetterTracePage({Key? key, required this.imagePath, required this.videoPath}) : super(key: key);

  @override
  _LetterTracePageState createState() => _LetterTracePageState();
}

class _LetterTracePageState extends State<LetterTracePage> {
  late VideoPlayerController _videoController;
  bool _videoEnded = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
      });

    _videoController.addListener(() {
      if (_videoController.value.position >= _videoController.value.duration) {
        setState(() {
          _videoEnded = true; // Video bitti
        });
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey paintKey = GlobalKey();
    if (!_videoEnded) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: _videoController.value.isInitialized
              ? AspectRatio(
            aspectRatio: _videoController.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                VideoPlayer(_videoController),
                Positioned(
                  bottom: 20,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _videoEnded = true;
                      });
                    },
                    child: const Text("İleri"),
                  ),
                )
              ],
            ),
          )
              : const CircularProgressIndicator(),
        ),
      );
    }
    return ChangeNotifierProvider(
      create: (_) => LetterTraceViewModel(),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent,),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Consumer<LetterTraceViewModel>(
            builder: (context, viewModel, child) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black54),
                            color: Colors.white,
                          ),
                          child: Image.asset(
                            widget.imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                        GestureDetector(
                          onPanUpdate: (details) {
                            RenderBox box = paintKey.currentContext!
                                .findRenderObject() as RenderBox;
                            Offset localPosition =
                            box.globalToLocal(details.globalPosition);
                            viewModel.addPoint(localPosition);
                          },
                          onPanEnd: (_) => viewModel.endStroke(),
                          child: RepaintBoundary(
                            key: paintKey,
                            child: CustomPaint(
                              painter: TracePainter(
                                  viewModel.points, viewModel.selectedColor),
                              size: const Size(200, 200),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (var color in [
                              Color(0xffED3500),
                              Color(0xff4DA8DA),
                              Color(0xffFF9B2F),
                              Color(0xffFF2DD1),
                              Color(0xff78C841),
                            ])
                              GestureDetector(
                                onTap: () => viewModel.changeColor(color),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: viewModel.selectedColor == color
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: viewModel.clear,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 12),
                              ),
                              child: const Text(
                                "Sıfırla",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TracePainter extends CustomPainter {
  final List<Offset> points;
  final Color color;

  TracePainter(this.points, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 15.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(TracePainter oldDelegate) => true;
}
