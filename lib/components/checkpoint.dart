import 'dart:async';
import 'package:disleksi_surum/components/pixel_adventur.dart';
import 'package:disleksi_surum/components/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';


class Checkpoint extends SpriteAnimationComponent
    with HasGameReference<PixelAdventure>, CollisionCallbacks {
  Checkpoint({
    position,
    size,
  }) : super(
    position: position,
    size: size,
  );


  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    add(RectangleHitbox(
      position: Vector2(18, 56),
      size: Vector2(12, 8),
      collisionType: CollisionType.passive,
    ));
    try {
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache(
            'pixeladventure/Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 1,
          textureSize: Vector2.all(64),
        ),
      );
    } catch (e) {
      print('Checkpoint image not found, setting animation to null');
      animation = null;
    }

    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player ) _reachedCheckpoint();
    super.onCollisionStart(intersectionPoints, other);
  }

  void _reachedCheckpoint() async {
    try {
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache(
            'pixeladventure/Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'),
        SpriteAnimationData.sequenced(
          amount: 26,
          stepTime: 0.05,
          textureSize: Vector2.all(64),
          loop: false,
        ),
      );


      await animationTicker?.completed;

      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache(
            'pixeladventure/Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png'),
        SpriteAnimationData.sequenced(
          amount: 10,
          stepTime: 0.05,
          textureSize: Vector2.all(64),
        ),
      );
    }catch (e) {
      print('Checkpoint animation images not found');
      animation = null;
    }
  }
}