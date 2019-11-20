import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:game2048/UI/GameBoxView.dart';
import 'package:game2048/utils/MoveUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GameRowItemView.dart';

/// 主游戏的View
class GameView extends StatefulWidget {
  double size;

  GameView(this.size);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GameView(size);
  }
}

class _GameView extends State<GameView> {
  int _value = 0;
  final int BOTTOM = 0;
  final int TOP = 1;
  final int RIGHT = 2;
  final int LEFT = 3;
  List<GameBoxView> _viewlist = new List(16);
  List<List<GameBoxView>> viewList = new List(4);
  List animators = new List();
  MoveUtil _moveUtil;
  double size;
  int maxValue;

  List<GameRowItemView> _rowList;
  SharedPreferences prefs;

  @override
  initState() {
    super.initState();
    initView();
    _moveUtil = new MoveUtil(viewList, addValue);
    syncMaxValue();
  }

  syncMaxValue() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if (maxValue == null) {
        maxValue = 0;
      }
      maxValue = prefs.getInt("maxValue");
    });
  }

  _GameView(this.size);

  initView() {
    int p = 0;
    _rowList = new List(viewList.length);
    for (var i = 0; i < viewList.length; i++) {
      List<GameBoxView> list = new List(4);
      for (var j = 0; j < list.length; j++) {
        list[j] = new GameBoxView(size, 0);
        _viewlist[p] = list[j];
        p++;
      }
      GameRowItemView gameRowItemView = new GameRowItemView(list);
      _rowList[i] = gameRowItemView;
      viewList[i] = list;
    }

    _createRandomView();
  }

  void addValue(int v) {
    setState(() {
      _value += v;
      print(_value);
      if (_value > maxValue) {
        maxValue = _value;
      }
    });
    if (_value >= maxValue) {
      prefs.setInt("maxValue", maxValue);
    }
  }

  _createRandomView() {
    int k = 2;
    while (k > 0) {
      Random random = new Random();
      int i = random.nextInt(viewList.length);

      int j = random.nextInt(viewList[i].length);

      GameBoxView boxView = viewList[i][j];

      if (boxView.value == 0) {
        boxView.value = random.nextInt(100) >= 50 ? 4 : 2;
        k--;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _moveUtil.setContext(context);
    double h = MediaQueryData.fromWindow(window).padding.top;
    // TODO: implement build
    return new Container(
      color: Color(0XF0F8FF),
      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(top: h + 20, right: 20, left: 20),
                    width: size * 1.3,
                    height: size * 1.3,
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      border: Border.all(color: Colors.transparent, width: 0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: new Center(
                      child: new Text(
                        "2048",
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                 /* new Container(
                    width: size * 1.3,
                    height: size * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      border: Border.all(color: Colors.transparent, width: 0),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: new Center(child: new Text("菜单"),)
                  )*/
                ],
              ),
              new Container(
                margin: EdgeInsets.only(top: h + 20),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(color: Colors.transparent, width: 0),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: size * 1.2,
                height: size * 1.3,
                child: new Center(
                    child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(
                        child: new Center(
                      child: Text(
                        "当前分数",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                    new Expanded(
                        child: new Center(
                      child: Text(
                        "$_value",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ))
                  ],
                )),
              ),
              new Container(
                margin: EdgeInsets.only(top: h + 20, left: 20),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(color: Colors.transparent, width: 0),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: size * 1.2,
                height: size * 1.3,
                child: new Center(
                  child: Text(
                    "最高分数:\n$maxValue",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
          new GestureDetector(
            onVerticalDragEnd: (details) {
              debugPrint(
                  'onVerticalDragEnd' + details.primaryVelocity.toString());
              if (details.primaryVelocity > 0) {
                handelGestureEvent(BOTTOM);
              } else {
                handelGestureEvent(TOP);
              }
            },
            onHorizontalDragEnd: (details) {
              debugPrint(
                  'onHorizontalDragEnd' + details.primaryVelocity.toString());
              if (details.primaryVelocity > 0) {
                handelGestureEvent(RIGHT);
              } else {
                handelGestureEvent(LEFT);
              }
            },
            child: new Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Colors.transparent, width: 0),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(top: h, right: 3, left: 3),
              child: new Center(
                child: new Column(
                  children: _rowList,
                ),
              ),
            ),

            /*new GridView.count(
          primary: false,
          crossAxisCount: 4,
          children: _viewlist,
        ),*/
          ),
        ],
      ),
    );
  }

  void handelGestureEvent(int type) {
    setState(() {
      _moveUtil.handleTouch(type);
      for (int i = 0; i < 4; i++) {
        print(viewList[i][0].value.toString() +
            '-' +
            viewList[i][1].value.toString() +
            '-' +
            viewList[i][2].value.toString() +
            '-' +
            viewList[i][3].value.toString());
        print("\n");
      }
    });
  }
}
