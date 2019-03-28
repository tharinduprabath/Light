import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DataSearch extends SearchDelegate<String> {
  String selectedCode = "";

  List<String> codeList = new List<String>();
  List<String> addressList = new List<String>();

  DataSearch() {
    var db = FirebaseDatabase.instance.reference().child("Posts");
    db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        codeList.add(values["code"]);
        addressList.add(values["address"]);
      });
    });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = query.isNotEmpty
        ? codeList.where((p) => p.startsWith(query.toUpperCase())).toList()
        : new List<String>();

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
            color: Colors.black26,
            height: 1,
          ),
      itemBuilder: (context, index) => ListTile(
            onTap: () {
              this.selectedCode = suggestionList[index];
              showResults(context);
            },
            title: RichText(
                text: TextSpan(
                    text: suggestionList[index].substring(0, query.length),
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w900,
                        fontSize: 17),
                    children: [
                  TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 17),
                  ),
                ])),
            subtitle: Text(addressList[index]),
            leading: Icon(
              Icons.lightbulb_outline,
              size: 27,
            ),
          ),
      itemCount: suggestionList.length,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.orange[200],
            ]),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 400,
              height: 50,
              child: Center(
                  child: Text(
                this.selectedCode,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              )),
            ),
            Container(
              width: 400,
              height: 50,
              child: Center(
                  child: Text(
                "Address",
                style: TextStyle(color: Colors.black54, fontSize: 20),
              )),
            ),
            Container(
              width: 300,
              height: 400,
              child: Card(
                elevation: 2,
                child: Container(
                  color: Colors.orange[200],
                  child: Center(child: Text("Map Here")),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
