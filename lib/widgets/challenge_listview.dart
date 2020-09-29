import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/extensions/hex_to_rgb.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/challenge.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/providers/challenge_provider.dart';
import 'package:lol_rewarder/providers/lol_provider.dart';

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

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: _lolProvider.getMatchListByAccountId(_summoner.accountId, _summoner.serverTag),
      builder: (ct, result) => LayoutBuilder(
        builder: (c, constraints) => Container(
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
                      Container(
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
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
            ),
            itemCount: _challenge.challengeList.length,
          )
        ),
      ),
    );
  }
}
