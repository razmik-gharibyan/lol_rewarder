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
  // Vars
  Function addSkinFunctionCallback;

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

  String convertTypeToChallengeText(dynamic challenge) {
    String challengeText;
    switch (challenge.type) {
      case "tower":
        final gameTotal = (challenge as TowerChallenge).gameTotal;
        final champion = (challenge as TowerChallenge).champion;
        challengeText = "Win $gameTotal (5 v 5 Solo Ranked) games in Summoner's Rift by playing as $champion and destroying all enemy towers";
        break;
      case "kill":
        final gameTotal = (challenge as KillChallenge).gameTotal;
        final champion = (challenge as KillChallenge).champion;
        final killTotal = (challenge as KillChallenge).killTotal;
        challengeText = "Win $gameTotal (5 v 5 Solo Ranked) games in Summoner's Rift by playing as $champion and having $killTotal or more kills";
        break;
      case "assist":
        final gameTotal = (challenge as AssistChallenge).gameTotal;
        final champion = (challenge as AssistChallenge).champion;
        final assistTotal = (challenge as AssistChallenge).assistTotal;
        challengeText = "Win $gameTotal (5 v 5 Solo Ranked) games in Summoner's Rift by playing as $champion and having $assistTotal or more assists";
        break;
      case "time":
        final gameTotal = (challenge as TimeChallenge).gameTotal;
        final champion = (challenge as TimeChallenge).champion;
        final gameUnder = (challenge as TimeChallenge).gameUnder;
        challengeText = "Win $gameTotal (5 v 5 Solo Ranked) games in Summoner's Rift by playing as $champion and finishing game under $gameUnder minutes";
        break;
    }
    return challengeText;
  }

}