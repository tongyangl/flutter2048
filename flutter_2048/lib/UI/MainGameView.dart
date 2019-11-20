import 'package:flutter/material.dart';
import 'package:game2048/UI/GameView.dart';

class MainGameView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainGameView();
  }
}

class _MainGameView extends State<MainGameView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double size = MediaQuery.of(context).size.width;
    size=(size-6)/4-12;
    return new Scaffold(

      body: new GameView(size),
    );
  }
}
