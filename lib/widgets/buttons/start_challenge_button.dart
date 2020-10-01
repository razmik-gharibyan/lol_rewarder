import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/active_challenge.dart';
import 'package:lol_rewarder/model/challenge.dart';
import 'package:lol_rewarder/model/game_main.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/providers/backend_provider.dart';

class StartChallengeButton extends StatelessWidget {

  Size size;
  dynamic result;
  Function startChallengePressed;

  StartChallengeButton(this.size,this.result,this.startChallengePressed);

  // Singletons
  Summoner _summoner = Summoner();
  Challenge _challenge = Challenge();
  // Tools
  final _backendProvider = BackendProvider();

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        "START CHALLENGE",
        style: TextStyle(
            fontSize: size.height * 17 / ConstraintHelper.screenHeightCoe,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      color: Colors.black87,
      textColor: Colors.white70,
      splashColor: Colors.amber,
      onPressed: () async {
        _showConfirmationDialog(context);
      },
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => Platform.isAndroid
        ? AlertDialog(
          title: Text("Are you sure?"),
          content: Text("If you start a new challenge, your current active (ongoing) challenge will be lost."
              "Are you sure you want to start this challenge"),
          actions: [
            FlatButton(
              child: Text(
                "NO",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            FlatButton(
              child: Text(
                "YES",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                await _updateActiveChallenge(result.data);
                Navigator.of(ctx).pop();
              },
            )
          ],
        )
        : CupertinoAlertDialog(
          title: Text("Are you sure?"),
          content: Text("If you start a new challenge, your current active (ongoing) challenge will be lost."
              "Are you sure you want to start this challenge"),
          actions: [
            FlatButton(
              child: Text("NO",),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            FlatButton(
              child: Text("YES"),
              onPressed: () async {
                await _updateActiveChallenge(result.data);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        )
    );
  }

  Future<void> _updateActiveChallenge(dynamic data) async {
    final int latestTimestamp = (data as List<GameMain>).first.timestamp;
    _summoner.setActiveChallenge(ActiveChallenge(_challenge.data.documentID, _challenge.type, latestTimestamp));
    await _backendProvider.updateSummoner();
    startChallengePressed();
  }
}
