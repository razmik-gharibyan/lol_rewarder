import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lol_rewarder/helper/champion_id_helper.dart';
import 'package:lol_rewarder/lol_api_key.dart';
import 'package:lol_rewarder/model/active_challenge.dart';
import 'package:lol_rewarder/model/challenge.dart';
import 'package:lol_rewarder/model/game_main.dart';
import 'package:lol_rewarder/model/lol_index.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/model/tower_challenge.dart';
import 'package:lol_rewarder/providers/backend_provider.dart';

class LoLProvider with ChangeNotifier {

  static final LoLProvider _loLProvider = LoLProvider.privateConstructor();

  factory LoLProvider() {
    return _loLProvider;
  }

  LoLProvider.privateConstructor();

  // Constants
  final Map<String,String> _serverTagList = {
    "BR": "br1", "EUW": "euw1", "EUN": "eun1", "JP": "jp1", "KR": "kr", "LAN": "la1",
    "LAS" : "la2", "NA": "na1", "OC": "oc1", "RU": "ru", "TR": "tr1"
  };
  final String _summonerNotFoundLoLMsg = "Not Found";
  // Custom Exception constants
  final String _summonerNotFoundCustomExceptionMsg = "SUMMONER_NOT_FOUND";
  // Singleton
  Summoner _summoner = Summoner();
  Challenge _challenge = Challenge();

  Future<void> getSummonerInfoByName(String summonerName,String serverTag) async {
    String serverKeyName;
    _serverTagList.forEach((key, value) {
      if(key == serverTag) {
        serverKeyName = value;
      }
    });
    final result = await http.get(
      "https://$serverKeyName.api.riotgames.com/lol/summoner/v4/summoners/by-name/$summonerName?api_key=${LoLApiKey.API_KEY}",
      headers: {
        "Content-Type": "application/json",
      },
    );
    if(result.statusCode == 200) {
      // Summoner found
      Map<String,dynamic> jsonResponse = json.decode(result.body);
      _summoner.setPuuid(jsonResponse["puuid"]);
      _summoner.setAccountId(jsonResponse["accountId"]);
      _summoner.setName(jsonResponse["name"]);
      _summoner.setServerTag(serverKeyName);
      _summoner.setIconId(jsonResponse["profileIconId"]);
      _summoner.setSummonerLevel(jsonResponse["summonerLevel"]);
    }else if(result.statusCode == 404) {
      // Summoner not found
      if(result.reasonPhrase == _summonerNotFoundLoLMsg) {
        throw Exception(_summonerNotFoundCustomExceptionMsg);
      }
    }
  }

  Future<void> getSummonerInfoByPuuid(String puuid,String serverTag) async {
    final result = await http.get(
      "https://$serverTag.api.riotgames.com/lol/summoner/v4/summoners/by-puuid/$puuid?api_key=${LoLApiKey.API_KEY}",
      headers: {
        "Content-Type": "application/json",
      },
    );
    if(result.statusCode == 200) {
      // Summoner found
      Map<String,dynamic> jsonResponse = json.decode(result.body);
      _summoner.setPuuid(jsonResponse["puuid"]);
      _summoner.setAccountId(jsonResponse["accountId"]);
      _summoner.setName(jsonResponse["name"]);
      _summoner.setServerTag(serverTag);
      _summoner.setIconId(jsonResponse["profileIconId"]);
      _summoner.setSummonerLevel(jsonResponse["summonerLevel"]);
    }else if(result.statusCode == 404) {
      // Summoner not found
      if(result.reasonPhrase == _summonerNotFoundLoLMsg) {
        throw Exception(_summonerNotFoundCustomExceptionMsg);
      }
    }
  }

  Future<List<GameMain>> getMatchListByAccountId(String accountId, String serverTag) async {
    final result = await http.get(
      "https://$serverTag.api.riotgames.com/lol/match/v4/matchlists/by-account/$accountId?api_key=${LoLApiKey.API_KEY}",
      headers: {
        "Content-Type": "application/json",
      },
    );
    List<GameMain> matchList = List<GameMain>();
    if(result.statusCode == 200) {
      Map<String,dynamic> jsonResponse = json.decode(result.body);
      final List<dynamic> mList = jsonResponse["matches"];
      mList.forEach((element) {
        matchList.add(GameMain(element["gameId"], element["timestamp"]));
      });
      return matchList;
    }
    return matchList;
  }

  Future<BeginEndIndex> getBeginIndexForTimestampMatchList(String accountId, String serverTag) async {
    int beginIndex = 0;
    int totalGames = 0;
    int endIndex = 0;
    List<dynamic> mList = List<dynamic>();
    bool loopStop = true;
    while(loopStop) {
      var result;
      result = await http.get("https://$serverTag.api.riotgames.com/lol/match/v4/matchlists/by-account/"
          "$accountId?beginIndex=$beginIndex&api_key=${LoLApiKey.API_KEY}",
        headers: {
        "Content-Type": "application/json",
        },
      );
      if(result.statusCode == 200) {
        Map<String,dynamic> jsonResponse = json.decode(result.body);
        totalGames = jsonResponse["totalGames"];
        mList = jsonResponse["matches"];
        mList.forEach((element) {
          //TODO change constant to timestamp
          if(1550910508497 == element["timestamp"]) {
            // Found timestamp to beginIndex search matchList with, stop loop and return beginIndex value
            final indexDifference = totalGames - beginIndex;
            if(indexDifference < 100) {
              endIndex = beginIndex + indexDifference;
            }
            loopStop = false;
          }
        });
        if(loopStop) {
          // timestamp not found yet add beginIndex value with 100
          beginIndex = beginIndex + 100;
        }
      }
    }
    return BeginEndIndex(beginIndex, endIndex);
  }

  Future<List<GameMain>> getMatchListByBeginEndIndexes(String accountId,String serverTag,BeginEndIndex indexes) async {
    var result;
    if(indexes.endIndex == 0) {
      // If endIndex == 0 that means no need to query with endIndex, begin index is enough
      result = await http.get("https://$serverTag.api.riotgames.com/lol/match/v4/matchlists/by-account/"
          "$accountId?beginIndex=${indexes.beginIndex}&api_key=${LoLApiKey.API_KEY}",
        headers: {
          "Content-Type": "application/json",
        },
      );
    }else{
      // If endIndex != 0 that means also add endIndex to beginIndex (i.e. oldest matchList query)
      result = await http.get("https://$serverTag.api.riotgames.com/lol/match/v4/matchlists/by-account/"
          "$accountId?beginIndex=${indexes.beginIndex}&endIndex=${indexes.endIndex}&api_key=${LoLApiKey.API_KEY}",
        headers: {
          "Content-Type": "application/json",
        },
      );
    }
    List<GameMain> matchList = List<GameMain>();
    if(result.statusCode == 200) {
      Map<String,dynamic> jsonResponse = json.decode(result.body);
      final List<dynamic> mList = jsonResponse["matches"];
      mList.forEach((element) {
        matchList.add(GameMain(element["gameId"], element["timestamp"]));
      });
      return matchList;
    }
    return matchList;
  }

  Future<bool> getTowerChallenge(int matchId,String serverTag) async {
    final result = await http.get(
      "https://$serverTag.api.riotgames.com/lol/match/v4/matches/$matchId?api_key=${LoLApiKey.API_KEY}",
      headers: {
        "Content-Type": "application/json",
      },
    );
    if(result.statusCode == 200) {
      // Get current challenge information from server
      TowerChallenge towerChallenge;
      _challenge.challengeList.forEach((element) {
        if(element.type == "tower") {
          towerChallenge = element;
        }
      });
      // Decode LoL json, and find summoner team, champion, wins etc
      Map<String,dynamic> jsonResponse = json.decode(result.body);
      List<dynamic> participantIdentities = jsonResponse["participantIdentities"];
      List<dynamic> participants = jsonResponse["participants"];
      List<dynamic> teams = jsonResponse["teams"];
      // Get participants index in all players list, and use that index to get from participant list with same index
      int participantIndex = 0;
      for(var element in participantIdentities) {
        if(element["player"]["accountId"] == _summoner.accountId) {
          break;
        }
        participantIndex++;
      }
      var participant = participants[participantIndex];
      final int championId = participant["championId"];
      final int teamId = participant["teamId"];
      String champion;
      String win;
      int towerKills;
      // Find the summoner team, win condition, and tower kills
      teams.forEach((element) {
        if(element["teamId"] == teamId) {
          win = element["win"];
          towerKills = element["towerKills"];
        }
      });
      // Check if summoner team was winner team or not
      if(win == "Win") {
        // Find champion name by id
        ChampionIdHelper.champions.forEach((key, value) {
          if(key == championId) {
            champion = value;
            return;
          }
        });
        // Check if summoner champion is same as challenge champion
        if(champion == towerChallenge.champion) {
          // Check if tower challenge complete (all towers killed)
          if(towerKills == 11) {
            // Challenge complete
            return true;
          }
          return false;
        }
        return false;
      }else{
        return false;
      }
    }
  }

}