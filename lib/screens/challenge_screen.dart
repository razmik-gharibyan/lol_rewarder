import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/widgets/app_drawer.dart';
import 'package:lol_rewarder/widgets/challenge_listview.dart';

class ChallengeScreen extends StatefulWidget {

  static const routeName = "/challenge-screen";

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
            color: Colors.white,
            iconSize: _size.height * 25 / ConstraintHelper.screenHeightCoe,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            RaisedButton(
              color: Colors.transparent,
              child: Text(
                "OPEN MENU",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              onPressed: () {
                if(!_scaffoldKey.currentState.isDrawerOpen) {
                  _scaffoldKey.currentState.openDrawer();
                }
              },
            )
          ],
        ),
        drawer: AppDrawer(),
        body: Container(
          child: Column(
            children: [
              Spacer(flex: 1,),
              Expanded(
                flex: 9,
                child: Container(
                  padding: EdgeInsets.only(top: _size.height * 15 / ConstraintHelper.screenHeightCoe),
                  child: ChallengeListView()
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
