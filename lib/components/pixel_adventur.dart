import 'dart:async';
import 'package:disleksi_surum/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late CameraComponent cam;
  //Player player = Player(character: 'Pink Man');
  JoystickComponent? joystick;
  bool showControls = true;
  bool playSounds=false;
  double soundVolume=1.0;

  //List<String> levelNames = ['Level_03', 'Level_02'];
  int currentLevelIndex = 0;
  final String levelNames;
  final String character;
  late Player player;
  final BuildContext context;
  PixelAdventure({required this.levelNames, required this.character,required this.context,}) {
    player = Player(character: character);
  }

  Future<void> loadAllPixelAdventureImages() async {
    await images.loadAll([
      // Fruits
      'pixeladventure/Items/Fruits/Apple.png',
      'pixeladventure/Items/Fruits/Bananas.png',
      'pixeladventure/Items/Fruits/Cherries.png',
      'pixeladventure/Items/Fruits/Kiwi.png',
      'pixeladventure/Items/Fruits/Melon.png',
      'pixeladventure/Items/Fruits/Orange.png',
      'pixeladventure/Items/Fruits/Pineapple.png',
      'pixeladventure/Items/Fruits/Strawberry.png',
      'pixeladventure/Items/Fruits/Collected.png',
      // Main Characters
      'pixeladventure/Main Characters/Ninja Frog/Idle (32x32).png',
      'pixeladventure/Main Characters/Ninja Frog/Run (32x32).png',
      'pixeladventure/Main Characters/Ninja Frog/Jump (32x32).png',
      'pixeladventure/Main Characters/Ninja Frog/Hit (32x32).png',
      'pixeladventure/Main Characters/Ninja Frog/Fall (32x32).png',
      'pixeladventure/Main Characters/Pink Man/Idle (32x32).png',
      'pixeladventure/Main Characters/Pink Man/Jump (32x32).png',
      'pixeladventure/Main Characters/Pink Man/Hit (32x32).png',
      'pixeladventure/Main Characters/Pink Man/Fall (32x32).png',
      'pixeladventure/Main Characters/Pink Man/Run (32x32).png',
      'pixeladventure/Main Characters/Virtual Guy/Idle (32x32).png',
      'pixeladventure/Main Characters/Virtual Guy/Jump (32x32).png',
      'pixeladventure/Main Characters/Virtual Guy/Hit (32x32).png',
      'pixeladventure/Main Characters/Virtual Guy/Fall (32x32).png',
      'pixeladventure/Main Characters/Virtual Guy/Run (32x32).png',
      'pixeladventure/Main Characters/Appearing (96x96).png',
      'pixeladventure/Main Characters/Desappearing (96x96).png',
      // Checkpoints
      'pixeladventure/Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png',
      'pixeladventure/Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png',
      'pixeladventure/Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png',
      // Enemies
      'pixeladventure/Enemies/Chicken/Idle (32x34).png',
      'pixeladventure/Enemies/Chicken/Hit (32x34).png',
      'pixeladventure/Enemies/Chicken/Run (32x34).png',
      // Traps
      'pixeladventure/Traps/Saw/On (38x38).png',
      // HUD
      'HUD/Joystick.png',
      'HUD/Knob.png',
      'HUD/JumpButton.png',
      // Background
      'pixeladventure/Background/Gray.png',
    ]);
  }


  @override
  Future<void> onLoad() async {
    await loadAllPixelAdventureImages();
    await Future.delayed(const Duration(seconds: 3));
    //await images.loadAllImages();

    _loadLevel(); // İlk seviyeyi yükle

  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick(dt);
    }
    super.update(dt);
  }

  void addJoystick() {
    // cam hazır değilse çık
    joystick = JoystickComponent(
      priority: 10,
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Knob.png')),
      ),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Joystick.png')),
      ),
      margin: const EdgeInsets.only(left: 5, bottom: 32),
    );
    cam.viewport.add(joystick!);
  }

  void updateJoystick(double dt) {
    if (joystick == null) return;

    switch (joystick!.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadNextLevel() async{
    Navigator.pop(context);
  }

  void _loadLevel() {
    Level world = Level(
      player: player,
      levelName: levelNames,
    );

    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    if (showControls) {
      addJoystick();
     //cam.viewport.add(JumpButton());
      //addAll([cam,JumpButton()]);
      addExitButton();
      addJumpButton();
    }
  }
  void returnToMenu() {
    Navigator.pop(context);
  }
  void addExitButton() {
    final exitButton = HudButtonComponent(
      button: RectangleComponent(
        size: Vector2(80, 40),
        paint: Paint()..color = const Color(0xAA000000),
      ),
      buttonDown: RectangleComponent(
        size: Vector2(80, 40),
        paint: Paint()..color = const Color(0xFF444444),
      ),
      margin: const EdgeInsets.only(top: 20, right: 20),
      onPressed: () {
        returnToMenu();
      },
    );

    // Yazı eklendi
    final text = TextComponent(
      text: 'ÇIK',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(40, 20),
    );

    exitButton.add(text);

    // Sağ üst köşe konumlandırma
    exitButton.position = Vector2(size.x - 100, 20); // ekran genişliğine göre
    exitButton.anchor = Anchor.topLeft;

    cam.viewport.add(exitButton);
  }
  void addJumpButton() {
    final jumpButton = HudButtonComponent(
      button: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/JumpButton.png')),
        size: Vector2(80, 80), // başlangıç boyutu, viewport veya ekran oranına göre ayarlanabilir
      ),
      buttonDown: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/JumpButton.png')),
        size: Vector2(80, 80),
      ),
      margin: const EdgeInsets.only(bottom: 20, right: 20), // sağ-alt köşe
      onPressed: () {
        player.hasJumped = true; // butona basınca jump tetiklenir
      },
      onReleased: () {
        player.hasJumped = false; // bırakınca jump false
      },
    );

    // Sağ-alt köşeye pozisyonlandır
    jumpButton.position = Vector2(
      size.x - 100, // ekran genişliğine göre offset, margin ile kombine edilebilir
      size.y - 100, // ekran yüksekliğine göre offset
    );
    jumpButton.anchor = Anchor.topLeft;

    cam.viewport.add(jumpButton);
  }


}
