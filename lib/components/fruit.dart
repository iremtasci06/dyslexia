import 'dart:async';
import 'package:disleksi_surum/components/pixel_adventur.dart';
import 'package:disleksi_surum/components/player_hitbox.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';


class Fruit extends SpriteAnimationComponent
with HasGameReference<PixelAdventure>,CollisionCallbacks {
  final String fruit;

  Fruit({
    this.fruit = 'Apple',
    position,
    size,
  }) : super(
    position: position,
    size: size,
  );

  final double stepTime = 0.05;
  final hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    priority = -1;

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );

    try {
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('pixeladventure/Items/Fruits/$fruit.png'),
        SpriteAnimationData.sequenced(
          amount: 17,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
        ),
      );
    } catch (e) {
      print('Fruit image not found: $fruit, setting animation to null');
      animation = null;
    }

    return super.onLoad();
  }

  void collidedWithPlayer() async {
    if (!collected) {
      collected = true;
      if (game.playSounds) {
        FlameAudio.play('collect_fruit.wav', volume: game.soundVolume);
      }

      try {
        animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('pixeladventure/Items/Fruits/Collected.png'),
          SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: stepTime,
            textureSize: Vector2.all(32),
            loop: false,
          ),
        );
      } catch (e) {
        print('Collected fruit image not found, skipping animation');
        animation = null;
      }

      await animationTicker?.completed;
      removeFromParent();
    }
  }
}