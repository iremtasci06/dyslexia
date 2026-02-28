import 'dart:async';
import 'package:disleksi_surum/components/pixel_adventur.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';


class BackgroundTile extends ParallaxComponent<PixelAdventure> {
  final String color;

  BackgroundTile({this.color = 'Gray', super.position});

  final double scrollSpeed = 40;

  @override
  FutureOr<void> onLoad() async {
    priority = -10;
    size = Vector2.all(64);

    try {
      parallax = await game.loadParallax(
        [ParallaxImageData('pixeladventure/Background/$color.png')],
        baseVelocity: Vector2(0, -scrollSpeed),
        repeat: ImageRepeat.repeat,
        fill: LayerFill.none,
      );
    } catch (e) {
      // Eğer resim yoksa null bırak veya default bir resim yükle
      print('Background image not found for $color, setting parallax to null');
      parallax = null;
    }

    return super.onLoad();
  }
}
