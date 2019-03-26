import 'package:flutter/material.dart';
import 'package:lightapp/constants.dart';
import 'package:lightapp/features.dart';
import 'package:lightapp/home.dart';
import 'package:lightapp/search.dart';

class Handle extends StatefulWidget {
  HandleState createState() => HandleState();
}

class HandleState extends State<Handle> with SingleTickerProviderStateMixin {
  ScrollController _scrollViewController;
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    Color appBarItemsColor = Colors.white;
    return Scaffold(
        body: new NestedScrollView(
      controller: _scrollViewController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          new SliverAppBar(
            title: new Text("LIGHT",
                style: TextStyle(color: appBarItemsColor, fontSize: 22)),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.search,
                    //color: appBarItemsColor,
                  ),
                  onPressed: () {
                    showSearch(context: context, delegate: DataSearch());
                  }),
              PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    //color: appBarItemsColor,
                  ),
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return Constants.choices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  })
            ],
            pinned: true,
            floating: true,
            snap: true,
            forceElevated: innerBoxIsScrolled,
            bottom: new TabBar(
              tabs: <Tab>[
                new Tab(
                  icon: Icon(
                    Icons.home,
                    color: appBarItemsColor,
                  ),
                ),
                new Tab(
                  icon: Icon(Icons.new_releases, color: appBarItemsColor),
                ),
              ],
              controller: _tabController,
            ),
          )
        ];
      },
      body: new TabBarView(
        children: <Widget>[
          callPage(0),
          callPage(1),
        ],
        controller: _tabController,
      ),
    ));
  }

  Widget callPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return new PageHome();
      case 1:
        return new PageFeatures();
        break;
      default:
        return new PageHome();
    }
  }

//  int _currentIndex = 0;

  void choiceAction(String choice) {
    if (choice == "About") {
      showAboutDialog(
          context: context,
          applicationName: "LIGHT",
          applicationVersion: "1.0v",
          applicationIcon: Icon(
            Icons.lightbulb_outline,
            color: Colors.orange,
            size: 70,
          ),
          applicationLegalese: "SHADOWFAX©2019");
    }
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollViewController = new ScrollController();
    _tabController = new TabController(vsync: this, length: 2);
  }
}
