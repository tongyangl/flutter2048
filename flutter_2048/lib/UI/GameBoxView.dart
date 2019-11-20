import 'package:flutter/material.dart';
//每一个小box的View

class BoxStyle {
  Color textColor;
  Color backGroundColor;

  BoxStyle({this.textColor, this.backGroundColor});
}

var styles = Map.fromEntries([
  MapEntry(
      0,
      BoxStyle(
          textColor: Color(0xffEED8AE), backGroundColor: Color(0xffEED8AE))),
  MapEntry(
      2,
      BoxStyle(
          textColor: Color(0xff776e65), backGroundColor: Color(0xffeee4da))),
  MapEntry(
      4,
      BoxStyle(
          textColor: Color(0xff776e65), backGroundColor: Color(0xffede0c8))),
  MapEntry(
      8,
      BoxStyle(
          textColor: Color(0xfff9f6f2), backGroundColor: Color(0xfff2b179))),
  MapEntry(
      16,
      BoxStyle(
          textColor: Color(0xfff9f6f2), backGroundColor: Color(0xfff59563))),
  MapEntry(
      32,
      BoxStyle(
          textColor: Color(0xfff9f6f2), backGroundColor: Color(0xfff67c5f))),
  MapEntry(
      64,
      BoxStyle(
          textColor: Color(0xfff9f6f2), backGroundColor: Color(0xfff65e3b))),
  MapEntry(
      128,
      BoxStyle(
          textColor: Color(0xfff9f6f2), backGroundColor: Color(0xffedcf72))),
  MapEntry(
      256,
      BoxStyle(
          textColor: Color(0xfff9f6f2), backGroundColor: Color(0xffedcc61))),
  MapEntry(
      512,
      BoxStyle(
          textColor: Color(0xfff9f6f2), backGroundColor: Color(0xffedc850))),
  MapEntry(
      1024,
      BoxStyle(
          textColor: Color(0xfff9f6f2), backGroundColor: Color(0xffedc53f))),
  MapEntry(
      2048,
      BoxStyle(
          textColor: Color(0xfff9f6f2), backGroundColor: Color(0xffedc22e))),
]);

class GameBoxView extends StatefulWidget {
  final double size; //正方形的边长要跟随屏幕的大小变化所以由外部传进来
  int value = 0;

  GameBoxView(this.size, this.value);

  _GameBoxView game;

  void createBoxAnimation() {
    game.createBoxAnimation();
  }

  void startEliminateAnimation() {
    game.startEliminateAnimation();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    game = new _GameBoxView(size, value);
    return game;
  }

  void setValue(int v) {
    value = v;
    game.setValue(v);
  }
}

class _GameBoxView extends State<GameBoxView> with TickerProviderStateMixin {
  double size;
  double s;
  double _alpha = 1;
  int value;
  AnimationController eliminateAnimationController1;
  Animation eliminateAnimation1;
  AnimationController eliminateAnimationController2;
  Animation eliminateAnimation2;
  AnimationController eliminateAnimationController3;
  Animation eliminateAnimation3;
  AnimationController eliminateAnimationController4;
  Animation eliminateAnimation4;

  AnimationController animationController;
  Animation animation;

  Animation _opacity;

  initState() {
    super.initState();
    _initAnimation();
  }

  _initAnimation() {
    eliminateAnimation1 = Tween(begin: 0.8, end: 1.1).animate(eliminateAnimationController1);
    eliminateAnimation2 = Tween(begin: 1.1, end: 0.8).animate(eliminateAnimationController2);
    eliminateAnimation3 = Tween(begin: 1.0, end: 1.07).animate(eliminateAnimationController3);
    eliminateAnimation4 = Tween(begin: 1.07, end: 1.0).animate(eliminateAnimationController4);
    eliminateAnimationController1 = new AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    eliminateAnimationController2 = new AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    eliminateAnimationController3 = new AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    eliminateAnimationController4 = new AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    eliminateAnimationController1.addListener(() {
      setState(() {
        size = animation.value * s;
      });
    });
    eliminateAnimationController2.addListener(() {
      setState(() {
        size = animation.value * s;
      });
    });
    eliminateAnimationController3.addListener(() {
      setState(() {
        size = animation.value * s;
      });
    });
    eliminateAnimationController4.addListener(() {
      setState(() {
        size = animation.value * s;
      });
    });
    eliminateAnimationController1.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        eliminateAnimationController2.forward();
      }
    });
    eliminateAnimationController2.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        eliminateAnimationController3.forward();
      }
    });
    eliminateAnimationController3.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        eliminateAnimationController4.forward();
      }
    });
  }

  void startEliminateAnimation() {
    eliminateAnimationController1.forward();
  }

  void createBoxAnimation() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn)))
      ..addListener(() {
        setState(() {
          _alpha = _opacity.value;
        });
      });
    Animation animation1;
    animation1 = Tween(begin: 0.01 * s, end: s).animate(animationController);
    animationController.addListener(() {
      setState(() {
        size = animation1.value;
      });
    });
    animationController.forward();
  }

  setValue(int v) {
    setState(() {
      value = v;
    });
  }

  _GameBoxView(double width, int v) {
    value = v;
    this.s = width;
    this.size = width;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Expanded(
        flex: 1,
        child: new Opacity(
          opacity: _alpha,
          child: new Container(
            width: s,
            height: s,
            color: Colors.grey,
            child: new Center(
              child: new Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: (this.value ~/ 2048) > 1
                      ? styles[this.value ~/ 2048].backGroundColor
                      : styles[this.value].backGroundColor,
                  border: Border.all(color: Colors.transparent, width: 0),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: (this.value ~/ 2048) > 1
                          ? styles[this.value ~/ 2048].textColor
                          : styles[this.value].textColor,
                      fontSize: size /
                          (value.toString().length <= 2
                              ? 2
                              : value.toString().length * 0.8),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (animationController != null) {
      animationController.dispose();
    }
  }
}
