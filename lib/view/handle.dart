import 'package:flutter/material.dart';
import 'package:lightapp/model/constants.dart';
import 'package:lightapp/view/home.dart';
import 'package:lightapp/view/search.dart';

class Handle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context),
      body: new PageHome(),
    );
  }

  Widget myAppBar(context) {
    return new AppBar(
      title: Text("Light"),
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.search,
              size: 25,
            ),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            }),
        PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
            ),
            onSelected: (choice) {
              _choiceAction(choice, context);
            },
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            })
      ],
    );
  }

  void _choiceAction(String choice, context) {
    if (choice == Constants.about) _showAboutDialog(context);
  }

  void _showAboutDialog(context) {
    showAboutDialog(
        context: context,
        applicationName: "Light",
        applicationVersion: "0.1v",
        applicationIcon: Icon(
          Icons.lightbulb_outline,
          size: 70,
        ),
        applicationLegalese: "THE BRICKS \nSoftware House \n© 2019");
  }
}
