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
  final String _summonerNotFoundLoLMsg = "Data not found - No results found for player with riot id";
  // Custom Exception constants
  final String _summonerNotFoundCustomExceptionMsg = "SUMMONER_NOT_FOUND";
  // Singleton
  Summoner _summoner = Summoner();

  Future<void> checkIfSummonerExistsInLeague(String summonerName,String serverTag) async {
    final result = await http.get(
      "https://europe.api.riotgames.com/riot/account/v1/accounts/by-riot-id/$summonerName/$serverTag?api_key=${LoLApiKey.API_KEY}",
      headers: {
        "Content-Type": "application/json",
      },
    );
    if(result.statusCode == 200) {
      // Summoner found
      Map<String,dynamic> jsonResponse = json.decode(result.body);
      _summoner.puuid = jsonResponse["puuid"];
    }else if(result.statusCode == 404) {
      // Summoner not found
      Map<String,dynamic> jsonResponse = json.decode(result.body);
      if(jsonResponse["status"]["message"].toString().contains(_summonerNotFoundLoLMsg)) {
        throw Exception(_summonerNotFoundCustomExceptionMsg);
      }
    }
  }

}