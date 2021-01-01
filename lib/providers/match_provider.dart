import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:lol_rewarder/helper/db_helper.dart';
import 'package:lol_rewarder/model/active_challenge.dart';
import 'package:lol_rewarder/model/challenge.dart';
import 'package:lol_rewarder/model/game_main.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/providers/backend_provider.dart';
import 'package:lol_rewarder/providers/lol_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lol_rewarder/globals.dart' as globals;

class MatchProvider with ChangeNotifier {

  // Singletons
  final _summoner = Summoner();
  final _challenge = Challenge();
  // Streams
  final _streamController = StreamController<String>();
  Sink<String> get inStreamController => _streamController.sink;
  Stream<String> get streamController => _streamController.stream;
  // Tools
  final _lolProvider = LoLProvider();
  final _dbHelperProvider = DBHelperProvider();
  final _backendProvider = BackendProvider();

  Future<List<GameHelper>> requestMatchList() async {
    List<GameMain> newMatchList = await _lolProvider.getNewMatchList(
        _summoner.accountId, _summoner.serverTag, _summoner.activeChallenge.activeChallengeTimestamp, inStreamController);
    newMatchList = newMatchList.reversed.toList();
    print("newmatchlist length is ${newMatchList.length}");
    await _addMatchesToDBHelper(newMatchList);
    return await _dbHelperProvider.getGames();
  }

  Future<void> _addMatchesToDBHelper(List<GameMain> newMatchList) async {
    final SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    if(newMatchList.isNotEmpty) {
      int counter = 0;
      for (var match in newMatchList) {
        // Check if match was won and queue was ranked 5 v 5 summoners rift, if yes then write match to db
        final gameHelper = await _lolProvider.getMatchByMatchId(match.gameId, _summoner.serverTag);
        if(gameHelper != null) {
          counter++;
          await _dbHelperProvider.insertDataIfNotExists(gameHelper);
          inStreamController.add("Checked $counter match from ${newMatchList.length}");
        }
        await _sharedPreferences.setInt(globals.TIMESTAMP, match.timestamp);
      }
      await _sharedPreferences.setInt(globals.TIMESTAMP, newMatchList.last.timestamp);
      _summoner.setActiveChallenge(ActiveChallenge(_challenge.data.documentID, _challenge.type, newMatchList.last.timestamp));
      await _backendProvider.updateSummoner();
    }
  }

  void dispose() {
    _streamController.close();
  }

}