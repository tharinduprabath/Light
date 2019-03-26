import 'package:flutter/material.dart';

class PageFeatures extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.orange[200],
                Colors.orange[50],
              ]),
        ),
        child: Container(),
        ),
      );
  }
}
