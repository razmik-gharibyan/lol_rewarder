import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/extensions/hex_to_rgb.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/helper/db_helper.dart';
import 'package:lol_rewarder/model/challenge.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/providers/challenge_provider.dart';
import 'package:lol_rewarder/providers/lol_provider.dart';
import 'package:lol_rewarder/providers/match_provider.dart';
import 'package:lol_rewarder/widgets/buttons/get_reward_button.dart';
import 'package:lol_rewarder/widgets/buttons/start_challenge_button.dart';

class ChallengeListView extends StatefulWidget {
  @override
  _ChallengeListViewState createState() => _ChallengeListViewState();
}

class _ChallengeListViewState extends State<ChallengeListView> {

  // Constants
  final String _initialText = "Wait while progress is being loaded, this may take a few minutes";
  // Singletons
  Challenge _challenge = Challenge();
  Summoner _summoner = Summoner();
  // Tools
  final _challengeProvider = ChallengeProvider();
  final _lolProvider = LoLProvider();
  final _matchProvider = MatchProvider();
  StreamController _controller = StreamController<bool>();
  // Vars
  Map<String,int> _progressCountMap = {
    "tower": 0, "kill": 0, "assist": 0, "time": 0
  };
  Map<String,bool> _completeCountMap = {
    "tower": false, "kill": false, "assist": false, "time": false
  };
  bool _isInit = true;
  bool _isLoading;
  bool _isAllChallengesComplete = false;
  bool _isDisposed = false;
  bool _isChallengeStarted = false;

  @override
  void initState() {
    super.initState();
    _showFoundMatchesSnackBar();
    if(_summoner.activeChallenge == null) {
      _isLoading = false;
      _isChallengeStarted = false;
    }else{
      _isLoading = _challenge.data.documentID == _summoner.activeChallenge.activeChallengeId; // If opened challenge is already active
      if (_isLoading) {
        _isChallengeStarted = true;
      }
    }
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
          if(_isLoading) {
            /*
            setState(() {
              Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Wait while progress is being loaded, this may take a few minutes"),
                    duration: Duration(seconds: 2),
                  )
              );
            });

             */
          }
      });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if(_isInit) {
      if(_isLoading) {
        await _getChallengeProgressByType();
        if(!_isDisposed) {
          _isInit = false;
          setState(() {
            _isLoading = false;
          });
          _controller.stream.listen((event) {
            _isAllChallengesComplete = _checkRequiredChallengesComplete(_completeCountMap);
            setState(() {
              _isLoading = false;
            });
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.close();
    _matchProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return LayoutBuilder(
        builder: (c, constraints) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 9,
                child: Container(
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
                          padding: EdgeInsets.symmetric(horizontal: _size.height * 15 / ConstraintHelper.screenHeightCoe),
                          alignment: Alignment.centerLeft,
                          color: HexColor.fromHex("f0f0f0"),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
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
                                          fontSize: _size.height * 14 / ConstraintHelper.screenHeightCoe
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              _completeCountMap[_challenge.challengeList[index].type]
                                  ? Flexible(
                                      flex: 1,
                                      child: Center(
                                        child: Icon(Icons.check, color: Colors.amber,)
                                      ),
                                    )
                                  : Flexible(
                                      flex: 2,
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Progress",
                                                style: TextStyle(
                                                  fontSize: _size.height * 13 / ConstraintHelper.screenHeightCoe
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: _isLoading
                                                  ? Platform.isAndroid
                                                  ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),)
                                                  : CupertinoActivityIndicator()
                                                  : Text(_showProgress(_challenge.challengeList[index].type)),
                                            )
                                    ],
                                ),
                              ),
                                  )
                            ],
                          ),
                        ),
                    ),
                    itemCount: _challenge.challengeList.length,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(
                        child: ButtonTheme(
                            minWidth: _size.height * 200 / ConstraintHelper.screenHeightCoe,
                            height: _size.height * 60 / ConstraintHelper.screenHeightCoe,
                            child: _summoner.activeChallenge == null
                                ? StartChallengeButton(_size,_startChallengePressed)
                                :_challenge.data.documentID == _summoner.activeChallenge.activeChallengeId // If opened challenge is already active
                                ? GetRewardButton(_size,_isAllChallengesComplete)
                                : StartChallengeButton(_size,_startChallengePressed)
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: _isChallengeStarted ? Container(
                        color: Colors.black,
                        width: double.infinity,
                        child: StreamBuilder<String>(
                            initialData: _initialText,
                            stream: _matchProvider.streamController,
                            builder: (cont, snapshot) {
                              if (!snapshot.hasData) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    _initialText,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                );
                              }
                              return Align(
                                alignment: Alignment.center,
                                child: Text(
                                  snapshot.data,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              );
                            }
                        ),
                      ) : Container(),
                    )
                  ],
                ),
              ),
            ],
          )
        ),
      );
  }

  Future<void> _getChallengeProgressByType() async {
    final List<GameHelper> matchList = await _matchProvider.requestMatchList();
    // Find challenge type, and check progress for it
    int towerCount = 0;
    int killCount = 0;
    int assistCount = 0;
    int timeCount = 0;
    print("matchlist lenght is ${matchList.length}");
    for(var match in matchList) {
      if(_isDisposed) {return;}
      for(var challenge in _challenge.challengeList) {
        switch (challenge.type) {
          case "tower":
            // Return true if challenge accomplished, false if not
            if (await _lolProvider.getTowerChallenge(match)) towerCount++;
            break;
          case "kill":
            // Return true if challenge accomplished, false if not
            if (await _lolProvider.getKillChallenge(match)) killCount++;
            break;
          case "assist":
            // Return true if challenge accomplished, false if not
            if (await _lolProvider.getAssistChallenge(match)) assistCount++;
            break;
          case "time":
            // Return true if challenge accomplished, false if not
            if (await _lolProvider.getTimeChallenge(match)) timeCount++;
            break;
        }
      }
    }
    // Write progress data for current challenge in it's position in progressMap
    _progressCountMap["tower"] = towerCount;
    _progressCountMap["kill"] = killCount;
    _progressCountMap["assist"] = assistCount;
    _progressCountMap["time"] = timeCount;
    _matchProvider.inStreamController.add("All matches have checked");
    for (var challenge in _challenge.challengeList) {
      _calculateProgress(challenge.type);
    }
  }

  String _calculateProgress(String type) {
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

  String _showProgress(String type) {
    return _calculateProgress(type);
  }

  bool _checkRequiredChallengesComplete(Map<String,bool> completeCountMap) {
    int completeCounter = 0;
    completeCountMap.forEach((key, value) {
      if(value) completeCounter++;
    });
    // Return true if complete counter have 3 completed challenges
    return completeCounter >= 3;
  }

  void _startChallengePressed() async {
    setState(() {
      Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("A new challenge started, you previous matches will be ignored"),
            duration: Duration(seconds: 10),
          )
      );
      _isLoading = false;
    });
  }

  void _showFoundMatchesSnackBar() {
    /*
    _matchProvider.streamController.listen((String text) {
      setState(() {
        Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(text),
              duration: Duration(seconds: 1),
            )
        );
      });
    });

     */
  }

}
