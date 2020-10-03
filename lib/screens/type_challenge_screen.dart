import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/admob/ad_manager.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/widgets/app_drawer.dart';
import 'package:lol_rewarder/widgets/type_challenge_listview.dart';

class TypeChallengeScreen extends StatefulWidget {

  static const routeName = "/type_challenge_screen";

  @override
  _TypeChallengeScreenState createState() => _TypeChallengeScreenState();
}

class _TypeChallengeScreenState extends State<TypeChallengeScreen> {

  // AdMob
  BannerAd _bannerAd;
  // Tools
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();


  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );
    _loadBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

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
            padding: EdgeInsets.only(top: _size.height * 15 / ConstraintHelper.screenHeightCoe),
            child: TypeChallengeListView()
        ),
    );
  }

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

}
