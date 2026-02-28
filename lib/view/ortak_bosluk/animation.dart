import 'package:disleksi_surum/utils/listname.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../viewModel/video_view_model.dart';
import 'package:provider/provider.dart';

import 'Ders1.dart';

class Start extends StatelessWidget {
  final String video;
  final String harf;
  const Start({super.key,required this.video,required this.harf});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = VideoViewModel();
        vm.initVideo(video);
        return vm;
      },
      child: Consumer<VideoViewModel>(
        builder: (context, vm, child) {
          if (!vm.isInitialized) {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Video bittiğinde NextPage’e yönlendir
          if (vm.controller.value.position >=
              vm.controller.value.duration &&
              !vm.controller.value.isPlaying) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => Ders1(list: listem['$harf']!,index: 0,),
                ),
              );
            });
          }

          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: AspectRatio(
                aspectRatio: vm.controller.value.aspectRatio,
                child: VideoPlayer(vm.controller),
              ),
            ),
          );
        },
      ),
    );
  }
}