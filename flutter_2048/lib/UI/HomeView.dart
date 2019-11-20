import 'package:flutter/material.dart';
import 'package:game2048/UI/MainGameView.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeView();
  }
}

class _HomeView extends State<HomeView> {
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
        body: new Container(
      margin: EdgeInsets.only(top: 250),
      alignment: AlignmentDirectional.center,
      child: new Column(
        children: <Widget>[
          new Container(
            child: new Text(
              "2048",
              style: new TextStyle(fontSize: 40.0, color: Colors.grey[800],fontWeight: FontWeight.bold),
            ),
            alignment: AlignmentDirectional.center,
          ),
          new Container(
              margin: EdgeInsets.only(top: 100),
              child: new GestureDetector(
                  child: Text(
                    "开始游戏",
                    style: new TextStyle(fontSize: 35.0,fontWeight: FontWeight.bold),
                  ),
                  onTap: onClickStartGame))

        ],
      ),
    ));
  }

  void onClickStartGame() {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new MainGameView()));
  }
}
