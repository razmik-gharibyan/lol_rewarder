import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lol_rewarder/lol_api_key.dart';
import 'package:lol_rewarder/model/Summoner.dart';

class LoLProvider with ChangeNotifier {

  static final LoLProvider _loLProvider = LoLProvider.privateConstructor();

  factory LoLProvider() {
    return _loLProvider;
  }

  LoLProvider.privateConstructor();

  // Constants
  final Map<String,String> _serverTagList = {
    "BR": "br1", "EUW": "euw1", "EUN": "eun1", "JP": "jp1", "KR": "kr", "LA": "la1",
    "NA": "na1", "OC": "oc1", "RU": "ru", "TR": "tr1"
  };
  final String _summonerNotFoundLoLMsg = "Not Found";
  // Custom Exception constants
  final String _summonerNotFoundCustomExceptionMsg = "SUMMONER_NOT_FOUND";
  // Singleton
  Summoner _summoner = Summoner();

  Future<void> checkIfSummonerExistsInLeague(String summonerName,String serverTag) async {
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
      _summoner.puuid = jsonResponse["puuid"];
      _summoner.accountId = jsonResponse["accountId"];
      _summoner.name = summonerName;
      _summoner.serverTag = serverKeyName;
      _summoner.summonerLevel = jsonResponse["summonerLevel"];
    }else if(result.statusCode == 404) {
      // Summoner not found
      if(result.reasonPhrase == _summonerNotFoundLoLMsg) {
        throw Exception(_summonerNotFoundCustomExceptionMsg);
      }
    }
  }

}