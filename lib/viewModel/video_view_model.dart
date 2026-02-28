import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends ChangeNotifier {
  late VideoPlayerController _controller;
  bool isInitialized = false;

  VideoPlayerController get controller => _controller;

  void initVideo(String assetPath) {
    _controller = VideoPlayerController.asset(assetPath)
      ..initialize().then((_) {
        isInitialized = true;
        notifyListeners();
        _controller.play();
        _controller.setLooping(false);
      });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration &&
          !_controller.value.isPlaying) {
        // Video tamamlandı
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
