import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game2048/UI/GameBoxView.dart';

class MoveUtil {
  final int BOTTOM = 0;
  final int TOP = 1;
  final int RIGHT = 2;
  final int LEFT = 3;
  bool _need_create_newbox = false;
  Function valueFunction;
  List<List<GameBoxView>> viewList;
  BuildContext _buildContext;
  MoveUtil(this.viewList, this.valueFunction);

  void handleTouch(int direction) {
    _need_create_newbox = false;
    if (direction == TOP) {
      top();
    } else if (direction == BOTTOM) {
      bottom();
    } else if (direction == LEFT) {
      left();
    } else if (direction == RIGHT) {
      right();
    }
    if (_need_create_newbox) {
      print("随机数块");
      _createRandomBox();
    }
    if (isOver()) {
      _showOverDialog(_buildContext);
    }
    _need_create_newbox = false;
  }

  setContext(BuildContext buildContext){
    _buildContext=buildContext;
  }
  void _showOverDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Text("游戏结束"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("确定"),
                onPressed: null,
              ),
              CupertinoDialogAction(
                child: Text("取消"),
                onPressed: null,
              )
            ],
          );
        });
  }

  _createRandomBox() {
    List<GameBoxView> list = new List();
    for (int i = 0; i < viewList.length; i++) {
      for (int j = 0; j < viewList[i].length; j++) {
        if (viewList[i][j].value == 0) {
          list.add(viewList[i][j]);
        }
      }
    }
    Random random = new Random();
    int i = random.nextInt(list.length);
    GameBoxView boxView = list[i];
    if (boxView.value == 0) {
      boxView.setValue(2);
      boxView.createBoxAnimation();
    }
  }

  bool isOver() {
    // 游戏是否结束，结束条件：可用格子为空且所有格子上下左右值不等
    for (var i = 0; i < viewList.length; i++) // 左右不等
      for (var j = 1; j < viewList[i].length; j++) {
        if (viewList[i][j].value == viewList[i][j - 1].value) return false;
      }
    for (var j = 0; j < viewList.length; j++) // 上下不等
      for (var i = 1; i < viewList[i].length; i++) {
        if (viewList[i][j] == viewList[i - 1][j]) return false;
      }
    return true;
  }

  void top() {
    _remove_top_blank();
    _top();
  }

  void bottom() {
    _remove_bottom_blank();
    _bottom();
  }

  void right() {
    _remove_right_blank();
    _right();
  }

  void left() {
    _left_remove_blank();
    _left();
  }

  void _left() {
    int i, j;
    for (i = 0; i < 4; i++) {
      for (j = 0; j < 3; j++) {
        if (viewList[i][j].value == viewList[i][j + 1].value &&
            !(viewList[i][j].value == 0 && viewList[i][j + 1].value == 0)) {
          viewList[i][j].setValue(viewList[i][j + 1].value * 2);
          viewList[i][j + 1].setValue(0);
          viewList[i][j].startEliminateAnimation();
          _need_create_newbox = true;
          valueFunction(viewList[i][j].value);
        }
      }
    }
    _left_remove_blank();
  }

  void _right() {
    int i, j;
    for (i = 0; i < 4; i++) {
      for (j = 3; j > 0; j--) {
        if (viewList[i][j].value == viewList[i][j - 1].value &&
            !(viewList[i][j].value == 0 && viewList[i][j - 1].value == 0)) {
          viewList[i][j].setValue(viewList[i][j - 1].value * 2);
          viewList[i][j - 1].setValue(0);
          _need_create_newbox = true;
          viewList[i][j].startEliminateAnimation();
          valueFunction(viewList[i][j].value);
        }
      }
    }
    _remove_right_blank();
  }

  void _bottom() {
    int i, j;
    for (i = 0; i < 4; i++) {
      for (j = 0; j < 3; j++) {
        if (viewList[j][i].value == viewList[j + 1][i].value &&
            !(viewList[j][i].value == 0 && viewList[j + 1][i].value == 0)) {
          viewList[j][i].setValue(viewList[j + 1][i].value * 2);
          viewList[j + 1][i].setValue(0);
          _need_create_newbox = true;
          viewList[j][i].startEliminateAnimation();
          valueFunction(viewList[j][i].value);
        }
      }
    }
    _remove_bottom_blank();
  }

  void _top() {
    int i, j;
    for (i = 0; i < 4; i++) {
      for (j = 0; j < 3; j++) {
        if (viewList[j][i].value == viewList[j + 1][i].value &&
            !(viewList[j][i].value == 0 && viewList[j + 1][i].value == 0)) {
          viewList[j][i].setValue(viewList[j + 1][i].value * 2);
          viewList[j + 1][i].setValue(0);
          _need_create_newbox = true;
          viewList[j][i].startEliminateAnimation();
          valueFunction(viewList[j][i].value);
        }
      }
    }
    _remove_top_blank();
  }

  void _remove_top_blank() {
    int i, j, k;
    for (i = 0; i < 4; i++) {
      for (j = 1; j < 4; j++) {
        k = j;
        while (k - 1 >= 0 && viewList[k - 1][i].value == 0) {
          //上面的那个为空
          swap(viewList[k][i], viewList[k - 1][i]);
          k--;
        }
      }
    }
  }

  void _remove_bottom_blank() {
    int i, j, k;
    for (i = 0; i < 4; i++) {
      for (j = 2; j >= 0; j--) {
        k = j;
        while (k + 1 < 4 && viewList[k + 1][i].value == 0) {
          //上面的那个为空
          swap(viewList[k][i], viewList[k + 1][i]);
          k++;
        }
      }
    }
  }

  void _remove_right_blank() {
    int i, j, k;
    for (i = 0; i < 4; i++) {
      for (j = 2; j >= 0; j--) {
        k = j;
        while (k + 1 < 4 && viewList[i][k + 1].value == 0) {
          //上面的那个为空
          swap(viewList[i][k], viewList[i][k + 1]);

          k++;
        }
      }
    }
  }

  void _left_remove_blank() {
    int i, j, k;
    for (i = 0; i < 4; i++) {
      for (j = 1; j < 4; j++) {
        k = j;
        while (k - 1 >= 0 && viewList[i][k - 1].value == 0) {
          //上面的那个为空
          swap(viewList[i][k], viewList[i][k - 1]);
          k--;
        }
      }
    }
  }

  void swap(GameBoxView m1, GameBoxView m2) {
    if (!(m1.value == 0 && m2.value == 0)) {
      _need_create_newbox = true;
      print("m1=" + m1.value.toString() + "m2=" + m2.value.toString());
    }
    int temp = m1.value;
    m1.setValue(m2.value);
    m2.setValue(temp);
  }
}
