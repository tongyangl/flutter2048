import 'package:flutter/material.dart';
import 'package:game2048/UI/GameBoxView.dart';

class GameRowItemView extends StatefulWidget {
  List<GameBoxView> _list;

  GameRowItemView(this._list);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _GameRowItemView(_list);
  }
}

class _GameRowItemView extends State {
  List<GameBoxView> _list;

  _GameRowItemView(this._list);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Expanded(
      flex: 1,
      child: new Row(
        children: _list,
      ),
    );
  }
}
