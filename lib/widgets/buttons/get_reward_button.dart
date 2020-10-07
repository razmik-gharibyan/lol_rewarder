import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/admob/ad_manager.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/screens/choose_champion_screen.dart';

class GetRewardButton extends StatefulWidget {

  Size size;
  bool isAllChallengesComplete;

  GetRewardButton(this.size,this.isAllChallengesComplete);

  @override
  _GetRewardButtonState createState() => _GetRewardButtonState();
}

class _GetRewardButtonState extends State<GetRewardButton> {

  // AdMob
  InterstitialAd _interstitialAd;
  // Vars
  bool _isInterstitialAdReady;

  @override
  void initState() {
    _isInterstitialAdReady = false;
    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: _onInterstitialAdEvent,
    );
    super.initState();
  }


  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _loadInterstitialAd();

    return RaisedButton(
      child: Text(
        "GET REWARD",
        style: TextStyle(
            fontSize: widget.size.height * 17 / ConstraintHelper.screenHeightCoe,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      color: Colors.black87,
      textColor: Colors.white70,
      splashColor: Colors.amber,
      onPressed: () async {
        _checkIfAllChallengesCompleted(context);
      },
    );
  }

  void _checkIfAllChallengesCompleted(BuildContext context) {
    //if(widget.isAllChallengesComplete) {
      _interstitialAd.show();
      Navigator.of(context).pushNamed(ChooseChampionScreen.routeName);
    //}else{
      //Scaffold.of(context).showSnackBar(
        //  SnackBar(
          //  content: Text("Complete all challenges to unlock reward"),
           // duration: Duration(seconds: 5),
         // )
     // );
   // }
  }

  void _loadInterstitialAd() {
    _interstitialAd.load();
  }

  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        _isInterstitialAdReady = true;
        break;
      case MobileAdEvent.failedToLoad:
        _isInterstitialAdReady = false;
        print('Failed to load an interstitial ad');
        break;
      case MobileAdEvent.closed:
        break;
      default:
      // do nothing
    }
  }
}
