import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../components/pixel_adventur.dart';

class AdventureMenu extends StatelessWidget {
  const AdventureMenu({super.key});

  @override
  Widget build(BuildContext context) {
    double widthscreen =MediaQuery.sizeOf(context).width;
    double heightscreen = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: widthscreen,
          height: heightscreen,
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/background.png'),fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: () async{
                    await Flame.device.fullScreen();
                    await Flame.device.setLandscape();
                    PixelAdventure game = PixelAdventure(levelNames: 'Level_06',character: 'Pink Man',context: context);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_)=>GameWidget(game: kDebugMode ? PixelAdventure(levelNames: 'Level_02',character: 'Pink Man',context: context) :game)));
                  },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      backgroundColor: Colors.transparent, // Şeffaf yapar
                      shadowColor: Colors.transparent,
                    ),
                    child: Container(
                      width: widthscreen/5,
                      height: 180,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('assets/images/karakterler.jpeg'),fit: BoxFit.cover,)
                      ),
                      child: Icon(Icons.play_arrow_sharp,size: 100,color: Colors.white,),
                    ),
                  ),
                  ElevatedButton(onPressed: () async{
                    await Flame.device.fullScreen();
                    await Flame.device.setLandscape();
                    PixelAdventure game = PixelAdventure(levelNames: 'Level_03',character: 'Ninja Frog',context: context);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_)=>GameWidget(game: kDebugMode ? PixelAdventure(levelNames: 'Level_03',character: 'Ninja Frog',context: context) :game)));
                  },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      backgroundColor: Colors.transparent, // Şeffaf yapar
                      shadowColor: Colors.transparent,
                    ),
                    child: Container(
                      width: widthscreen/5,
                      height: 180,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('assets/images/karakterler.jpeg'),fit: BoxFit.cover,)
                      ),
                      child: Icon(Icons.play_arrow,size: 100,color: Colors.white,),
                    ),
                  ),
                  ElevatedButton(onPressed: () async{
                    await Flame.device.fullScreen();
                    await Flame.device.setLandscape();
                    PixelAdventure game = PixelAdventure(levelNames: 'Level_04',character: 'Virtual Guy',context: context);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_)=>GameWidget(game: kDebugMode ? PixelAdventure(levelNames: 'Level_04',character: 'Virtual Guy',context: context) :game)));
                  },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      backgroundColor: Colors.transparent, // Şeffaf yapar
                      shadowColor: Colors.transparent,
                    ),
                    child: Container(
                      width: widthscreen/5,
                      height: 180,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('assets/images/karakterler.jpeg'),fit: BoxFit.cover,)
                      ),
                      child: Icon(Icons.play_arrow,size: 100,color: Colors.white,),
                    ),
                  ),
                  ],),
                  SizedBox(height: 20,),
                  Row(children: [

                  ],)
            ],
          ),
        ),
      ),
    );
  }
}
