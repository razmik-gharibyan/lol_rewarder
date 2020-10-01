import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/extensions/hex_to_rgb.dart';
import 'package:lol_rewarder/helper/calc_helper.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/challenge.dart';
import 'package:lol_rewarder/model/game_main.dart';
import 'package:lol_rewarder/model/lol_index.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/providers/challenge_provider.dart';
import 'package:lol_rewarder/providers/lol_provider.dart';
import 'package:lol_rewarder/widgets/buttons/start_challenge_button.dart';

class ChallengeListView extends StatefulWidget {
  @override
  _ChallengeListViewState createState() => _ChallengeListViewState();
}

class _ChallengeListViewState extends State<ChallengeListView> {

  // Singletons
  Challenge _challenge = Challenge();
  Summoner _summoner = Summoner();
  // Tools
  final _challengeProvider = ChallengeProvider();
  final _lolProvider = LoLProvider();
  // Vars
  Map<String,int> _progressCountMap = {
    "tower": 0, "kill": 0, "assist": 0, "time": 0
  };
  Map<String,bool> _completeCountMap = {
    "tower": false, "kill": false, "assist": false, "time": false
  };
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setState(() {
      Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Wait while progress is being loaded, this may take some time"),
            duration: Duration(seconds: 20),
          )
      );
    }));
  }

  @override
  void didChangeDependencies() async {
    if(_isInit) {
      await _getChallengeProgressByType();
      _isInit = false;
      setState(() {});
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: _lolProvider.getMatchListByAccountId(_summoner.accountId, _summoner.serverTag),
      builder: (ct, result) => LayoutBuilder(
        builder: (c, constraints) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: constraints.maxHeight * 0.7,
                child: ListView.builder(
                  itemBuilder: (ctx, index) => Container(
                    height: _size.height * 0.17,
                    margin: EdgeInsets.only(
                      bottom: _size.height * 15 / ConstraintHelper.screenHeightCoe,
                      left: _size.height * 15 / ConstraintHelper.screenHeightCoe,
                      right: _size.height * 15 / ConstraintHelper.screenHeightCoe,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ]
                    ),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: _size.height * 25 / ConstraintHelper.screenHeightCoe),
                        alignment: Alignment.centerLeft,
                        color: HexColor.fromHex("f0f0f0"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: constraints.maxWidth * 0.62,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${_challenge.challengeList[index].type.toString().toUpperCase()} CHALLENGE",
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                      fontSize: _size.height * 20 / ConstraintHelper.screenHeightCoe
                                    ),
                                  ),
                                  Text(
                                    _challengeProvider.convertTypeToChallengeText(_challenge.challengeList[index]),
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: _size.height * 18 / ConstraintHelper.screenHeightCoe
                                    ),
                                  )
                                ],
                              ),
                            ),
                            _completeCountMap[_challenge.challengeList[index].type]
                                ? Icon(Icons.check, color: Colors.amber,)
                                : Container(
                                    width: constraints.maxWidth * 0.15,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Progress",
                                          style: TextStyle(
                                            fontSize: _size.height * 13 / ConstraintHelper.screenHeightCoe
                                          ),
                                        ),
                                        _isLoading
                                          ? Platform.isAndroid
                                              ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),)
                                              : CupertinoActivityIndicator()
                                          : Text(_showProgress(_challenge.challengeList[index].type))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                  ),
                  itemCount: _challenge.challengeList.length,
                ),
              ),
              ButtonTheme(
                minWidth: _size.height * 200 / ConstraintHelper.screenHeightCoe,
                height: _size.height * 60 / ConstraintHelper.screenHeightCoe,
                child: StartChallengeButton(_size,result)
              ),
            ],
          )
        ),
      ),
    );
  }

  Future<void> _getChallengeProgressByType() async {
    final List<GameMain> matchList = await _getCorrectMatchList();
    // Find challenge type, and check progress for it
    int towerCount = 0;
    int killCount = 0;
    int assistCount = 0;
    int timeCount = 0;
    for(var match in matchList) {
      // Check if match is acceptable for check with timestamp
      if(match.timestamp >= _summoner.activeChallenge.activeChallengeTimestamp) {
        final matchMain = await _lolProvider.getMatchByMatchId(match.gameId, _summoner.serverTag);
        for(var challenge in _challenge.challengeList) {
          switch (challenge.type) {
            case "tower":
              // Return true if challenge accomplished, false if not
              if (await _lolProvider.getTowerChallenge(matchMain)) towerCount++;
              break;
            case "kill":
              // Return true if challenge accomplished, false if not
              if (await _lolProvider.getKillChallenge(matchMain)) killCount++;
              break;
            case "assist":
              // Return true if challenge accomplished, false if not
              if (await _lolProvider.getAssistChallenge(matchMain)) assistCount++;
              break;
            case "time":
              // Return true if challenge accomplished, false if not
              if (await _lolProvider.getTimeChallenge(matchMain)) timeCount++;
              break;
          }
        }
      }
    }
    // Write progress data for current challenge in it's position in progressMap
      _progressCountMap["tower"] = towerCount;
      _progressCountMap["kill"] = killCount;
      _progressCountMap["assist"] = assistCount;
      _progressCountMap["time"] = timeCount;
      _isLoading = false;
  }

  Future<List<GameMain>> _getCorrectMatchList() async {
    final BeginEndIndex indexes = await _lolProvider.getBeginIndexForTimestampMatchList(_summoner.accountId, _summoner.serverTag);
    List<GameMain> allMatchList = List<GameMain>();
    int beginIndexForLoop = CalcHelper().getCountFromBeginIndex(indexes.beginIndex);
    if(indexes.endIndex == 0) {
      // If endIndex == 0 (was not found)
      int beginIndex = indexes.beginIndex;
      int endIndex = indexes.endIndex;
      BeginEndIndex currentIndexes = BeginEndIndex(beginIndex, endIndex);
      // Use for loop to go from beginIndex match to latest match with -100 match subtract (latest game user played)
      for(int i=0; i<beginIndexForLoop + 1; i++) {
        final List<GameMain> matchList = await _lolProvider.getMatchListByBeginEndIndexes(
            _summoner.accountId, _summoner.serverTag, currentIndexes);
        allMatchList.addAll(matchList);
        beginIndex = beginIndex - 100;
        currentIndexes = BeginEndIndex(beginIndex, endIndex);
      }
    }else{
      // If endIndex != 0 , endIndex found
      int beginIndex = indexes.beginIndex;
      int endIndex = indexes.endIndex;
      BeginEndIndex currentIndexes = BeginEndIndex(beginIndex, endIndex);
      for(int i=0; i<beginIndexForLoop + 1; i++) {
        if(endIndex != 0) {
          final List<GameMain> matchList = await _lolProvider.getMatchListByBeginEndIndexes(
              _summoner.accountId, _summoner.serverTag, currentIndexes);
          allMatchList.addAll(matchList);
          beginIndex = beginIndex - 100;
          endIndex = 0;
          currentIndexes = BeginEndIndex(beginIndex,endIndex);
        }else{
          final List<GameMain> matchList = await _lolProvider.getMatchListByBeginEndIndexes(
              _summoner.accountId, _summoner.serverTag, currentIndexes);
          allMatchList.addAll(matchList);
          beginIndex = beginIndex - 100;
          currentIndexes = BeginEndIndex(beginIndex, endIndex);
        }
      }
    }
    return allMatchList;
  }

  String _showProgress(String type) {
    String progressText;
    switch (type) {
      case "tower":
        _challenge.challengeList.forEach((element) {
          if(element.type == "tower") {
            progressText = ("${_progressCountMap["tower"]} / ${element.gameTotal}");
            if(_progressCountMap["tower"] >= element.gameTotal) {
              // Challenge completed
              _completeCountMap["tower"] = true;
            }
          }
        });
        break;
      case "kill":
        _challenge.challengeList.forEach((element) {
          if(element.type == "kill") {
            progressText = ("${_progressCountMap["kill"]} / ${element.gameTotal}");
            if(_progressCountMap["kill"] >= element.gameTotal) {
              // Challenge completed
              _completeCountMap["kill"] = true;
            }
          }
        });
        break;
      case "assist":
        _challenge.challengeList.forEach((element) {
          if(element.type == "assist") {
            progressText = ("${_progressCountMap["assist"]} / ${element.gameTotal}");
            if(_progressCountMap["assist"] >= element.gameTotal) {
              // Challenge completed
              _completeCountMap["assist"] = true;
            }
          }
        });
        break;
      case "time":
        _challenge.challengeList.forEach((element) {
          if(element.type == "time") {
            progressText = ("${_progressCountMap["time"]} / ${element.gameTotal}");
            if(_progressCountMap["time"] >= element.gameTotal) {
              // Challenge completed
              _completeCountMap["time"] = true;
            }
          }
        });
    }
    return progressText;
  }

}
