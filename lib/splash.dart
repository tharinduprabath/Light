import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lightapp/color_loader4.dart';
import 'package:lightapp/dot_type.dart';

class Splash extends StatefulWidget {
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    Color itemColor = Colors.orange;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange[200],
                Colors.orange[50],
              ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Icon(
              Icons.lightbulb_outline,
              size: 200,
              color: itemColor,
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: colorLoader4()),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorLoader4() {
    return ColorLoader4(
//      dotOneColor: itemColor,
//      dotTwoColor: itemColor,
//      dotThreeColor: itemColor,
      dotType: DotType.diamond,
      duration: Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initState() {
    super.initState();
    startTime();
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/handle');
  }

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }
}
