import 'package:flutter/material.dart';
import 'package:lightapp/view/handle.dart';
import 'package:lightapp/view/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        routes: <String, WidgetBuilder>{
          '/splash': (BuildContext context) => new Splash(),
          '/handle': (BuildContext context) => new Handle(),
        },
        debugShowCheckedModeBanner: false,
        title: 'Light Service',
        theme: ThemeData(
            primarySwatch: Colors.orange,
            iconTheme: IconThemeData(color: Colors.orange),
            buttonColor: Colors.orange,
            appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
                textTheme: TextTheme(
                    title: TextStyle(color: Colors.white, fontSize: 25)))),
        home: Splash());
  }
}
