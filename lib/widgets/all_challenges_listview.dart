import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/extensions/hex_to_rgb.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/challenge_type.dart';

class AllChallengesListView extends StatelessWidget {

  final List<ChallengeType> _challengeTypeList = [
    ChallengeType("Mage Challenges", "assets/images/mage_challenge.png"),
    ChallengeType("Fighter Challenges", "assets/images/fighter_challenge.png"),
    ChallengeType("Assassin Challenges", "assets/images/assassin_challenge.png"),
    ChallengeType("Marksman Challenges", "assets/images/marksman_challenge.png"),
    ChallengeType("Support Challenges", "assets/images/support_challenge.png")
  ];

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
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(left: _size.height * 25 / ConstraintHelper.screenHeightCoe),
                  alignment: Alignment.centerLeft,
                  color: HexColor.fromHex("f0f0f0"),
                  child: Text(
                    _challengeTypeList[index].title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _size.height * 20 / ConstraintHelper.screenHeightCoe
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(_challengeTypeList[index].imageAsset),
                )
              ],
            ),
          ),
        ),
        itemCount: _challengeTypeList.length,
      ),
    );
  }
}
