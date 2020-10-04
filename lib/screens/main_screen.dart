import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/admob/ad_manager.dart';
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

    final _size = MediaQuery.of(context).size;

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
      body: Container(
        height: _size.height,
        child: Stack(
          children: [
            Container(
              height: _size.height,
              child: MainMenuGrid()
            ),
            Positioned(
              bottom: _size.height * 0.05,
              child: AdmobBanner(
                adUnitId: AdManager.bannerAdUnitId,
                adSize: AdmobBannerSize.FULL_BANNER
              ),
            )
          ],
        ),
      ),
    );
  }

}
