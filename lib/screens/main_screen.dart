import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/admob/ad_manager.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/helper/db_helper.dart';
import 'package:lol_rewarder/model/active_challenge.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/providers/backend_provider.dart';
import 'package:lol_rewarder/screens/choose_champion_screen.dart';
import 'package:lol_rewarder/widgets/app_drawer.dart';
import 'package:lol_rewarder/widgets/main_menu_grid.dart';

import 'package:lol_rewarder/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {

  static const routeName = "/main_screen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  // AdMob
  BannerAd _bannerAd;
  // Keys
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  // Tools
  final DBHelperProvider _dbHelperProvider = DBHelperProvider();
  final BackendProvider _backendProvider = BackendProvider();
  Summoner _summoner = Summoner();
  SharedPreferences _preferences;
  // Vars
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.smartBanner,
    );
    _loadBannerAd();
    _dbHelperProvider.open();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if(_isInit) {
      _preferences = await SharedPreferences.getInstance();
      _updateLatestTimestamp();
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
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
        body: LayoutBuilder(
          builder: (c, constraints) => Container(
            height: constraints.maxHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(
                  flex: 2,
                ),
                Flexible(
                  flex: 10,
                  child: Container(
                    child: MainMenuGrid()
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: _size.height * 5 / ConstraintHelper.screenHeightCoe),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text(
                            "Information",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: _size.height * 18 / ConstraintHelper.screenHeightCoe,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: SingleChildScrollView(
                            child: Text(
                              "* When starting a new challenge all previous challenge games statuses will be lost, only the games you play after"
                                  " starting a challenge will be calculated\n"
                              "* Each month will have limited amount of rewards (skins) available for players to get, but that amount is never"
                                  " less then 50\n"
                              "* If you have finished a challenge but can't get your reward because this months skins have already ended, don't worry"
                                  " wait until next month and then claim your reward\n"
                              "* You can chose any skin for any champion you want, just make sure that the skin you want is available for purchase"
                                  " in official League store (for example if it's Victorious skin it can't be purchased)\n"
                              "* After claiming a skin, it will be gifted to you. Gift will be sent to an registered League summoner within 24 hours"
                                  ", so make sure you have connected right account on right server",
                              style: TextStyle(
                                  fontSize: _size.height * 12 / ConstraintHelper.screenHeightCoe,
                                  color: Colors.black54
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text(
                            "Thank you and good luck!",
                            style: TextStyle(
                              fontSize: _size.height * 15 / ConstraintHelper.screenHeightCoe,
                              color: Colors.black54
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.top,anchorOffset: ConstraintHelper.appBarHeight);
    globals.bannerAd = _bannerAd;
  }

  void _updateLatestTimestamp() async {
    if (_preferences.containsKey(globals.TIMESTAMP)) {
      final latestTimestamp = _preferences.getInt(globals.TIMESTAMP);
      if(_summoner.activeChallenge.activeChallengeTimestamp != latestTimestamp) {
        _summoner.setActiveChallenge(ActiveChallenge(
            _summoner.activeChallenge.activeChallengeId, _summoner.activeChallenge.activeChallengeType, latestTimestamp));
        await _backendProvider.updateSummoner();
      }
    }
  }

}
