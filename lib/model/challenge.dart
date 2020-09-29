import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {

  static final Challenge _challenge = Challenge._privateConstructor();

  factory Challenge() {
    return _challenge;
  }

  Challenge._privateConstructor();

  String _type;
  DocumentSnapshot _data;
  List<dynamic> _challengeList;

  String get type => _type;
  DocumentSnapshot get data => _data;
  List<dynamic> get challengeList => _challengeList;

  void setType(String newValue) {
    _type = newValue;
  }

  void setData(DocumentSnapshot newValue) {
    _data = newValue;
  }

  void setChallengeList(List<dynamic> newValue) {
    _challengeList = newValue;
  }

}