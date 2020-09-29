import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/extensions/hex_to_rgb.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/challenge.dart';

class ChallengeListView extends StatefulWidget {
  @override
  _ChallengeListViewState createState() => _ChallengeListViewState();
}

class _ChallengeListViewState extends State<ChallengeListView> {

  // Singletons
  Challenge _challenge = Challenge();

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, index) => Container(
          height: _size.height * 0.115,
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
              padding: EdgeInsets.only(left: _size.height * 25 / ConstraintHelper.screenHeightCoe),
              alignment: Alignment.centerLeft,
              color: HexColor.fromHex("f0f0f0"),
              child: Text(
                "${_challenge.challengeList[index]["type"]} Challenge",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _size.height * 20 / ConstraintHelper.screenHeightCoe
                ),
              ),
            ),
        ),
        itemCount: _challenge.challengeList.length,
      )
    );
  }
}
