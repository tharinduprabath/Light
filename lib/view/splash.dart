import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lightapp/model/color_loader4.dart';
import 'package:lightapp/model/dot_type.dart';

class Splash extends StatefulWidget {
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange[100],
                Colors.orange[50],
              ]),
        ),
        child: Column(
          children: <Widget>[
            Spacer(),
            Icon(
              Icons.lightbulb_outline,
              size: 200,
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: _colorLoader4()),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initState() {
    super.initState();
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    _startTime();
  }

  Widget _colorLoader4() {
    return ColorLoader4(
//      dotOneColor: itemColor,
//      dotTwoColor: itemColor,
//      dotThreeColor: itemColor,
      dotType: DotType.diamond,
      duration: Duration(milliseconds: 800),
    );
  }

  void _navigationPage() {
    Navigator.of(context).pushReplacementNamed('/handle');
  }

  _startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, _navigationPage);
  }
}
