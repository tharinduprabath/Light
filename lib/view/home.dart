import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lightapp/model/color_loader3.dart';
import 'package:lightapp/model/post.dart';

//Color btnBGColor = Colors.orange;
Color txtColor = Colors.white;

class BottomSheetModel {
  final DatabaseReference databaseRef =
      FirebaseDatabase.instance.reference().child("Posts");

  BuildContext context;
  String selectedID, updatedAddress = "";

  final _formKey = GlobalKey<FormState>();

  void _snackBarMessage(String message) {
    Scaffold.of(this.context).showSnackBar(new SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  void _updateData() {
    databaseRef
        .child(this.selectedID)
        .child("address")
        .set(this.updatedAddress)
        .then((_) {
      _snackBarMessage("Updated");
    });
  }

  void _deleteData() {
    databaseRef.child(this.selectedID).remove().then((_) {
      _snackBarMessage("Deleted");
    });
  }

  _deleteConfirmDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(20),
            elevation: 14,
            title: Text(
              "Are you sure want to delete?",
              style: TextStyle(color: Colors.black87),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "NO",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(this.context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "YES",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  _deleteData();
                  Navigator.of(this.context).pop();
                },
              ),
            ],
          );
        });
  }

  _showUpdateDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          var txt = new TextEditingController();
          //txt.text = this.updatedAddress;

          return SimpleDialog(
            titlePadding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            elevation: 18,
            title: Center(
                child: Text(
              "UPDATE",
              style: TextStyle(fontSize: 24),
            )),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            contentPadding: EdgeInsets.all(32),
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (value){
                        if (value.isEmpty) return "Can not be empty";
                      },
                      initialValue: this.updatedAddress,
                      autofocus: true,
                      maxLength: 150,
                      maxLengthEnforced: false,
                      enableInteractiveSelection: true,
                      decoration: InputDecoration(icon: Icon(Icons.comment)),
                      onSaved: (val) => this.updatedAddress = val,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: RaisedButton(
                        textColor: txtColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            Navigator.pop(this.context);
                            _updateData();
                          }
                        },
                        child: Text("UPDATE"),
                      ),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              )
            ],
          );
        });
  }

  _action1() {
    // delete
    _deleteConfirmDialog(this.context);
  }

  _action2() {
    // update
    _showUpdateDialog(this.context);
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

  _showMainBottomSheet(BuildContext context, String id, String address) {
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
}

// --------------------------------------------------------------------------------------------------------

class PageHome extends StatefulWidget {
  PageHomeState createState() => PageHomeState();
}

class PageHomeState extends State<PageHome> {
  BottomSheetModel myModelSheet = new BottomSheetModel();

  StreamSubscription<Event> _onPostAddedSubscription;
  StreamSubscription<Event> _onPostChangedSubscription;
  StreamSubscription<Event> _onPostRemovedSubscription;
  StreamSubscription<ConnectivityResult> _onNetworkSubscription;

  bool isLoading = true;
  bool isNetworkEnabled = false;
  bool isFirstTime = true;
  int selectedIndex;
  List<Post> posts;
  String newCode = "", newAddress = "", deleteCode = "";

  final _formKey = GlobalKey<FormState>();

  final DatabaseReference databaseRef =
      FirebaseDatabase.instance.reference().child("Posts");

  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FloatingActionButton(
            foregroundColor: txtColor,
            //backgroundColor: btnBGColor,
            onPressed: () {
              _showAddNewDialog(context);
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
                  child: posts.isNotEmpty
                      ? ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.black12,
                                height: 1,
                              ),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              splashColor: Colors.orange[200],
                              highlightColor: Colors.orange[200],
                              onLongPress: () {
                                this.selectedIndex = index;
                                myModelSheet._showMainBottomSheet(context,
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
                      : Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              //Text("No Data", style: TextStyle(fontSize: 24),),
                              ColorLoader3(
                                dotRadius: 5,
                                radius: 20,
                              ),
                            ],
                          ),
                        ))),
        ));
  }

  @override
  void dispose() {
    _onPostAddedSubscription.cancel();
    _onPostChangedSubscription.cancel();
    _onPostRemovedSubscription.cancel();

    _onNetworkSubscription.cancel();

    super.dispose();
  }

  void handleSave() {
    List<String> codeList = new List<String>();

    posts.forEach((data) => {codeList.add(data.code)});

    if (codeList.contains(newCode)) {
      // TODO: Error duplicate
      _snackBarMessage("Already Inserted");
    } else {
      databaseRef.push().set({
        'code': newCode,
        'address': newAddress,
      }).then((_) {
        _snackBarMessage("Saved");
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

    _onNetworkSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _checkConnectionStatus();
        isFirstTime = false;
      } else if (!isFirstTime) {
        _snackBarMessage("Internet connection restored");
      }
    });
    _startTime();
    _startConnectionTime();
  }

  void _loadingDone() {
    setState(() {
      isLoading = false;
    });
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

  _showAddNewDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            contentPadding: EdgeInsets.all(32),
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return "Can not be empty";
                        if (value.length < 6) return "Code format invalid";
                      },
                      autofocus: true,
                      inputFormatters: <TextInputFormatter>[],
                      cursorColor: Colors.orange,
                      decoration: InputDecoration(
                          icon: Icon(Icons.code), labelText: "Code"),
                      maxLength: 6,
                      maxLengthEnforced: true,
                      textCapitalization: TextCapitalization.characters,
                      onSaved: (val) => newCode = val,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return "Can not be empty";
                      },
                      cursorColor: Colors.orange,
                      decoration: InputDecoration(
                          icon: Icon(Icons.comment), labelText: "Address"),
                      maxLength: 150,
                      maxLengthEnforced: false,
                      onSaved: (val) => newAddress = val,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      textColor: txtColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          handleSave();
                          Navigator.pop(context);
                        }
                      },
                      child: Text("SAVE"),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ],
          );
        });
  }

  void _snackBarMessage(String message, {duration: 1}) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
    ));
  }

  _startTime() async {
    isLoading = true;
    var _duration = new Duration(milliseconds: 1000);
    return new Timer(_duration, _loadingDone);
  }

  _startConnectionTime() async {
    isLoading = true;
    var _duration = new Duration(milliseconds: 1000);
    return new Timer(_duration, _checkConnectionStatus);
  }

  _checkConnectionStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi))
      isNetworkEnabled = false;
    else
      isNetworkEnabled = true;

    print(isNetworkEnabled.toString());

    if (!isNetworkEnabled)
      _snackBarMessage("No internet connection", duration: 2);
  }
}
