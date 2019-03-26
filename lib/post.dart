import 'package:firebase_database/firebase_database.dart';

class Post {
  String _id;
  String _code;
  String _address;

  Post(this._id, this._code, this._address);
  Post.map(dynamic obj) {
    this._id  = obj['id'];
    this._code = obj['code'];
    this._address = obj['address'];
  }

  String get id => _id;
  String get code => _code;
  String get address => _address;

  Post.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _code = snapshot.value['code'];
    _address = snapshot.value['address'];
  }
}