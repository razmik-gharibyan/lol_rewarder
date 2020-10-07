import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/widgets/app_drawer.dart';
import 'package:lol_rewarder/widgets/my_rewards_gridview.dart';

class MyRewardsScreen extends StatelessWidget {

  static const routeName = "/my_rewards_screen";

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return Scaffold(
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
        height: _size.height,
        child: Column(
          children: [
            SizedBox(height: _size.height * 0.1,),
            Container(
              height: _size.height * 0.75,
              child: MyRewardsGridView(),
            ),
          ],
        ),
      ),
    );
  }
}
