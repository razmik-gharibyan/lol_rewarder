import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/extensions/hex_to_rgb.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/challenge.dart';
import 'package:lol_rewarder/model/challenge_type.dart';
import 'package:lol_rewarder/screens/type_challenge_screen.dart';

class AllChallengesListView extends StatelessWidget {

  // Constants
  final List<ChallengeType> _challengeTypeList = [
    ChallengeType("Mage Challenges", "assets/images/mage_challenge.png", "mage"),
    ChallengeType("Fighter Challenges", "assets/images/fighter_challenge.png", "fighter"),
    ChallengeType("Assassin Challenges", "assets/images/assassin_challenge.png", "assassin"),
    ChallengeType("Marksman Challenges", "assets/images/marksman_challenge.png", "marksman"),
    ChallengeType("Support Challenges", "assets/images/support_challenge.png", "support")
  ];
  // Singleton
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
          child: InkWell(
            child: Container(
              color: HexColor.fromHex("f0f0f0"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: _size.width * 0.6,
                    padding: EdgeInsets.only(left: _size.height * 25 / ConstraintHelper.screenHeightCoe),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _challengeTypeList[index].title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _size.height * 18 / ConstraintHelper.screenHeightCoe
                      ),
                    ),
                  ),
                  Container(
                    width: _size.width * 0.3,
                    alignment: Alignment.bottomRight,
                    child: Image.asset(_challengeTypeList[index].imageAsset),
                  )
                ],
              ),
            ),
            onTap: () {
              _challenge.setType(_challengeTypeList[index].type);
              Navigator.of(context).pushNamed(TypeChallengeScreen.routeName);
            },
          ),
        ),
        itemCount: _challengeTypeList.length,
      ),
    );
  }
}
