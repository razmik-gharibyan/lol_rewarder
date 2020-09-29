import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lol_rewarder/model/assist_challenge.dart';
import 'package:lol_rewarder/model/challenge.dart';
import 'package:lol_rewarder/model/kill_challenge.dart';
import 'package:lol_rewarder/model/time_challenge.dart';
import 'package:lol_rewarder/model/tower_challenge.dart';

class ChallengeProvider with ChangeNotifier {

  static final ChallengeProvider _challengeProvider = ChallengeProvider.privateConstructor();

  factory ChallengeProvider() {
    return _challengeProvider;
  }

  ChallengeProvider.privateConstructor();

  // Singletons
  Challenge _challenge = Challenge();

  Future<void> getChallengeData(DocumentSnapshot document) async {
    List<dynamic> challengeList = List<dynamic>();
    document.data.forEach((key, value) {
      if(key.contains("challenge")) {
        switch (value["type"]) {
          case "tower":
            challengeList.add(TowerChallenge(value["type"],value["champion"],value["gameTotal"]));
            break;
          case "kill":
            challengeList.add(KillChallenge(value["type"], value["champion"], value["killTotal"], value["gameTotal"]));
            break;
          case "assist":
            challengeList.add(AssistChallenge(value["type"], value["champion"], value["assistTotal"], value["gameTotal"]));
            break;
          case "time":
            challengeList.add(TimeChallenge(value["type"], value["champion"], value["gameUnder"], value["gameTotal"]));
            break;
        }
      }
    });
    _challenge.setChallengeList(challengeList);
  }

}