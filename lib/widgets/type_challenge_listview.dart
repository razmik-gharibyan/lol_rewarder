import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/extensions/hex_to_rgb.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/challenge.dart';
import 'package:lol_rewarder/providers/backend_provider.dart';
import 'package:lol_rewarder/providers/challenge_provider.dart';

class TypeChallengeListView extends StatefulWidget {

  @override
  _TypeChallengeListViewState createState() => _TypeChallengeListViewState();
}

class _TypeChallengeListViewState extends State<TypeChallengeListView> {

  // Singleton
  Challenge _challenge = Challenge();
  // Tools
  final _backendProvider = BackendProvider();
  final _challengeProvider = ChallengeProvider();

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: _backendProvider.getChallengeListByType(_challenge.type),
      builder: (c, result) =>
      Container(
        child:  result.connectionState == ConnectionState.done ? ListView.builder(
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
                padding: EdgeInsets.only(left: _size.height * 25 / ConstraintHelper.screenHeightCoe),
                alignment: Alignment.centerLeft,
                color: HexColor.fromHex("f0f0f0"),
                child: Text(
                   "Challenge $index",
                   style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _size.height * 20 / ConstraintHelper.screenHeightCoe
                   ),
                ),
              ),
              onTap: () async {
                _challenge.setData(result.data);
                await _challengeProvider.getChallengeData(result.data);
              },
            ),
          ),
          itemCount: result.data.length,
        )
        : Center(
          child: Platform.isAndroid
              ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),)
              : CupertinoActivityIndicator(),
        )
      ),
    );
  }

}