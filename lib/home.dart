import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lightapp/post.dart';
import 'package:lightapp/color_loader3.dart';

Color btnBGColor = Colors.orange;
Color txtColor = Colors.white;

class Model {
  final DatabaseReference databaseRef =
      FirebaseDatabase.instance.reference().child("Posts");

  BuildContext context;
  String selectedID, updatedAddress = "";

  Widget confirmAlert() {
    return AlertDialog(
      titlePadding: EdgeInsets.all(20),
      elevation: 14,
      title: Text(
        "Are you sure want to delete?",
        style: TextStyle(fontSize: 20),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "NO",
            style: TextStyle(fontSize: 16, color: btnBGColor),
          ),
          onPressed: () {
            Navigator.of(this.context).pop();
          },
        ),
        FlatButton(
          child: Text(
            "YES",
            style: TextStyle(fontSize: 16, color: btnBGColor),
          ),
          onPressed: () {
            Navigator.of(this.context).pop();
            delete();
          },
        ),
      ],
    );
  }

  void delete() {
    databaseRef.child(this.selectedID).remove().then((_) {
      snackBarMessage("Deleted");
    });
  }

  mainBottomSheet(BuildContext context, String id, String address) {
    this.selectedID = id;
    this.context = context;
    this.updatedAddress = address;

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createTitle(context, "Delete", Icons.delete, _action1),
              _createTitle(context, "Show Map", Icons.map, null),
              _createTitle(context, "Edit Address", Icons.edit, _action2),
            ],
          );
        });
  }

  Widget showSimpleDialog() {
    var txt = new TextEditingController();
    txt.text = this.updatedAddress;

    return SimpleDialog(
      titlePadding: EdgeInsets.fromLTRB(0, 40, 0, 0),
      elevation: 18,
      title: Center(
          child: Text(
        "UPDATE",
        style: TextStyle(fontSize: 24),
      )),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      contentPadding: EdgeInsets.all(32),
      children: <Widget>[
        TextField(
          autofocus: true,
          cursorColor: btnBGColor,
          enableInteractiveSelection: true,
          controller: txt,
          decoration: InputDecoration(icon: Icon(Icons.comment)),
          onChanged: (val) => this.updatedAddress = val,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: RaisedButton(
            color: btnBGColor,
            textColor: txtColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            onPressed: () {
              Navigator.pop(this.context);
              updateData();
            },
            child: Text("UPDATE"),
          ),
        )
      ],
    );
  }

  void snackBarMessage(String message) {
    Scaffold.of(this.context).showSnackBar(new SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  void updateData() {
    databaseRef
        .child(this.selectedID)
        .child("address")
        .set(this.updatedAddress)
        .then((_) {
      snackBarMessage("Updated");
    });
  }

  _action1() {
    // delete
    _alterConfirm(this.context);
  }

  _action2() {
    // update
    _simpleDialog(this.context);
  }

  _alterConfirm(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return confirmAlert();
        });
  }

  ListTile _createTitle(
      BuildContext context, String name, IconData icon, Function action) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        action();
      },
    );
  }

  _simpleDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return showSimpleDialog();
        });
  }
}

class PageHome extends StatefulWidget {
  PageHomeState createState() => PageHomeState();
}

class PageHomeState extends State<PageHome> {
  Model myModelSheet = new Model();

  StreamSubscription<Event> _onPostAddedSubscription;
  StreamSubscription<Event> _onPostChangedSubscription;
  StreamSubscription<Event> _onPostRemovedSubscription;

  bool isLoading = true;
  int selectedIndex;
  List<Post> posts;
  String newCode = "", newAddress = "", deleteCode = "";

  final DatabaseReference databaseRef =
      FirebaseDatabase.instance.reference().child("Posts");

  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FloatingActionButton(
            foregroundColor: txtColor,
            backgroundColor: btnBGColor,
            onPressed: () {
              _simpleDialog(context);
            },
            child: Icon(
              Icons.add,
              size: 33,
            ),
          ),
        ),
        body: Material(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.orange[50],
                      Colors.orange[50],
                    ]),
              ),
              child: Material(
                type: MaterialType.transparency,
                color: Colors.transparent,
                child: !isLoading
                    ? ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.black12,
                              height: 1,
                            ),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            splashColor: Colors.orange[400],
                            highlightColor: Colors.orange[200],
                            onLongPress: () {
                              this.selectedIndex = index;
                              myModelSheet.mainBottomSheet(context,
                                  posts[index].id, posts[index].address);
                            },
                            child: new ListTile(
                              //contentPadding: EdgeInsets.only(left: 16),
                              title: Text(
                                posts[index].code,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal),
                              ),
                              subtitle: Text(
                                posts[index].address,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 13),
                              ),
                              leading: Icon(
                                Icons.lightbulb_outline,
                                color: Colors.black54,
                                size: 30,
                              ),
                              trailing: Text(
                                (index + 1).toString(),
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12),
                              ),
                            ),
                          );
                        },
                        itemCount: posts.length,
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                      )
                    : ColorLoader3(
                        dotRadius: 5,
                        radius: 20,
                      ),
              )),
        ));
  }

  @override
  void dispose() {
    _onPostAddedSubscription.cancel();
    _onPostChangedSubscription.cancel();
    _onPostRemovedSubscription.cancel();
    super.dispose();
  }

  void handleSave() {
    List<String> codeList = new List<String>();

    posts.forEach((data) => {codeList.add(data.code)});

    if (codeList.contains(newCode)) {
      // TODO: Error duplicate
      snackBarMessage("Already Inserted");
    } else {
      databaseRef.push().set({
        'code': newCode,
        'address': newAddress,
      }).then((_) {
        snackBarMessage("Saved");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    posts = new List();
    _onPostChangedSubscription =
        databaseRef.onChildChanged.listen(_onPostUpdated);
    _onPostAddedSubscription = databaseRef.onChildAdded.listen(_onPostAdded);
    _onPostRemovedSubscription =
        databaseRef.onChildRemoved.listen(_onPostRemoved);
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    startTime();
  }

  void loadingDone() {
      setState(() {
        isLoading = false;
      });
  }

  startTime() async {
    isLoading = true;
    var _duration = new Duration(milliseconds: 1000);
    return new Timer(_duration, loadingDone);
  }

  Widget showSimpleDialog() {
    newCode = "";
    newAddress = "";

    return SimpleDialog(
      titlePadding: EdgeInsets.fromLTRB(0, 40, 0, 0),
      elevation: 18,
      title: Center(
          child: Text(
        "NEW POST",
        style: TextStyle(fontSize: 24),
      )),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      contentPadding: EdgeInsets.all(32),
      children: <Widget>[
        TextField(
          inputFormatters: <TextInputFormatter>[],
          autofocus: true,
          cursorColor: Colors.orange,
          decoration:
              InputDecoration(icon: Icon(Icons.code), labelText: "Code"),
          maxLength: 6,
          maxLengthEnforced: true,
          textCapitalization: TextCapitalization.characters,
          onChanged: (val) => newCode = val,
        ),
        TextField(
          cursorColor: Colors.orange,
          decoration:
              InputDecoration(icon: Icon(Icons.comment), labelText: "Address"),
          maxLength: 150,
          maxLengthEnforced: false,
          onChanged: (val) => newAddress = val,
        ),
        RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          color: btnBGColor,
          textColor: txtColor,
          onPressed: () {
            handleSave();
            Navigator.pop(context);
          },
          child: Text("SAVE"),
        )
      ],
    );
  }

  void snackBarMessage(String message) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    ));
  }

  void _onPostAdded(Event event) {
    setState(() {
      posts.add(new Post.fromSnapshot(event.snapshot));
      posts.sort((a, b) => a.code.compareTo(b.code));
    });
  }

  void _onPostRemoved(Event event) {
    setState(() {
      posts.removeAt(this.selectedIndex);
      posts.sort((a, b) => a.code.compareTo(b.code));
    });
  }

  void _onPostUpdated(Event event) {
    var oldPostValue =
        posts.singleWhere((post) => post.id == event.snapshot.key);
    setState(() {
      posts[posts.indexOf(oldPostValue)] =
          new Post.fromSnapshot(event.snapshot);
      posts.sort((a, b) => a.code.compareTo(b.code));
    });
  }

  _simpleDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return showSimpleDialog();
        });
  }
}
