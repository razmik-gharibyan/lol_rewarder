import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lol_rewarder/helper/champion_id_helper.dart';
import 'package:lol_rewarder/helper/db_helper.dart';
import 'package:lol_rewarder/lol_api_key.dart';
import 'package:lol_rewarder/model/assist_challenge.dart';
import 'package:lol_rewarder/model/challenge.dart';
import 'package:lol_rewarder/model/game_main.dart';
import 'package:lol_rewarder/model/kill_challenge.dart';
import 'package:lol_rewarder/model/lol_index.dart';
import 'package:lol_rewarder/model/match_main.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/model/time_challenge.dart';
import 'package:lol_rewarder/model/tower_challenge.dart';

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
  DBHelperProvider _dbHelperProvider = DBHelperProvider();

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

  // Get first timestamp value, and use it as startPoint for upcoming games.
  Future<int> getStartingPointGameTimestamp(String accountId,String serverTag) async {
    final result = await http.get("https://$serverTag.api.riotgames.com/lol/match/v4/matchlists/by-account/"
        "$accountId?beginIndex=0&endIndex=1&api_key=${LoLApiKey.API_KEY}",
      headers: {
        "Content-Type": "application/json",
      },
    );
    int resultTimeStamp;
    if(result.statusCode == 200) {
      Map<String,dynamic> jsonResponse = json.decode(result.body);
      List<dynamic> firstGameList = jsonResponse["matches"];
      resultTimeStamp = firstGameList[0]["timestamp"];
    }
    return resultTimeStamp;
  }

  // Find matches that happened after last timestamp
  Future<List<GameMain>> getNewMatchList(String accountId,String serverTag,int latestTimeStamp) async {
    int beginIndex = 0;
    int endIndex = 1;
    List<GameMain> matchList = List<GameMain>();
    List<dynamic> mList = List<dynamic>();
    bool loopStop = true;
    while(loopStop) {
      final result = await http.get("https://$serverTag.api.riotgames.com/lol/match/v4/matchlists/by-account/"
          "$accountId?beginIndex=$beginIndex&endIndex=$endIndex&api_key=${LoLApiKey.API_KEY}",
        headers: {
          "Content-Type": "application/json",
        },
      );
      if(result.statusCode == 200) {
        Map<String,dynamic> jsonResponse = json.decode(result.body);
        mList = jsonResponse["matches"];
        if (mList.isNotEmpty) {
          if(mList[0]["timestamp"] == latestTimeStamp) {
            // If timestamp found, then stop searching for more games.
            loopStop = false;
          }else{
            // Timestamp not found yet, add current game to new match list, and go check next match
            matchList.add(GameMain(mList[0]["gameId"], mList[0]["timestamp"]));
            beginIndex++;
            endIndex++;
          }
        }
      }
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
          if(_summoner.activeChallenge.activeChallengeTimestamp == element["timestamp"]) {
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

  Future<GameHelper> getMatchByMatchId(int matchId,String serverTag) async {
    Map<String,dynamic> jsonResponse = Map<String,dynamic>();
    final result = await http.get(
      "https://$serverTag.api.riotgames.com/lol/match/v4/matches/$matchId?api_key=${LoLApiKey.API_KEY}",
      headers: {
        "Content-Type": "application/json",
      },
    );
    if(result.statusCode == 200) {
      // Decode LoL json, and find summoner team, champion, wins etc
      jsonResponse = json.decode(result.body);
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
      final Map<String,dynamic> stats = participant["stats"];
      final int gameDuration = jsonResponse["gameDuration"];
      final int queueId = jsonResponse["queueId"];
      final int kills = stats["kills"];
      final int assists = stats["assists"];
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
      // Find champion name by id
      ChampionIdHelper.champions.forEach((key, value) {
        if(key == championId) {
          champion = value;
          return;
        }
      });
      if(win == "Win" && queueId == 420) {
        // Game was won and queue was ranked game (5v5) in summoners rift
        return GameHelper(gameId: matchId,towerKills: towerKills,gameDuration: gameDuration,champion: champion,kills: kills,assists: assists);
      }
      return null;
    }
    return null;
  }

  Future<bool> getTowerChallenge(GameHelper gameHelper) async {
    TowerChallenge towerChallenge;
    _challenge.challengeList.forEach((element) {
      if(element.type == "tower") {
        towerChallenge = element;
      }
    });
    // Check if champion is same as challenge required champion, and if challenge requirements met
    if(gameHelper.champion == towerChallenge.champion && gameHelper.towerKills == 11) {
      return true;
    }
    return false;
  }

  Future<bool> getKillChallenge(GameHelper gameHelper) async {
    KillChallenge killChallenge;
    _challenge.challengeList.forEach((element) {
      if(element.type == "kill") {
        killChallenge = element;
      }
    });
    // Check if champion is same as challenge required champion, and if challenge requirements met
    if(gameHelper.champion == killChallenge.champion && gameHelper.kills >= killChallenge.killTotal) {
      return true;
    }
    return false;
  }

  Future<bool> getAssistChallenge(GameHelper gameHelper) async {
    AssistChallenge assistChallenge;
    _challenge.challengeList.forEach((element) {
      if(element.type == "assist") {
        assistChallenge = element;
      }
    });
    // Check if champion is same as challenge required champion, and if challenge requirments met
    if(gameHelper.champion == assistChallenge.champion && gameHelper.assists >= assistChallenge.assistTotal) {
      return true;
    }
    return false;
  }

  Future<bool> getTimeChallenge(GameHelper gameHelper) async {
    TimeChallenge timeChallenge;
    _challenge.challengeList.forEach((element) {
      if(element.type == "time") {
        timeChallenge = element;
      }
    });
    // Check if champion is same as challenge required champion, and if challenge requirments met
    if(gameHelper.champion == timeChallenge.champion && gameHelper.gameDuration <= timeChallenge.gameUnder * 60) {
      return true;
    }
    return false;
  }

}