import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lol_rewarder/lol_api_key.dart';
import 'package:lol_rewarder/model/summoner.dart';

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

}