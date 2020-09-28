import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/widgets/app_drawer.dart';
import 'package:lol_rewarder/widgets/main_menu_grid.dart';

class MainScreen extends StatefulWidget {

  static const routeName = "/main_screen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black87,
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
      body: Center(
        child: MainMenuGrid(),
      ),
    );
  }
}
