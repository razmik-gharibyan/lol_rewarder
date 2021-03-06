import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/admob/ad_manager.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/model/user.dart';
import 'package:lol_rewarder/providers/auth_provider.dart';
import 'package:lol_rewarder/providers/backend_provider.dart';
import 'package:lol_rewarder/providers/ddragon_provider.dart';
import 'package:lol_rewarder/providers/lol_provider.dart';
import 'package:lol_rewarder/screens/connect_account_screen.dart';
import 'package:lol_rewarder/screens/login_screen.dart';
import 'package:lol_rewarder/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {

  static const routeName = "/splash_screen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // Tools
  final _authProvider = AuthProvider();
  final _backendProvider = BackendProvider();
  final _lolProvider = LoLProvider();
  final _ddragonProvider = DDragonProvider();
  // Singletons
  User _user = User();
  Summoner _summoner = Summoner();
  // Vars
  bool _isInit = true;
  bool _isAuthFailed = false;

  @override
  void didChangeDependencies() async {
    if(_isInit) {
      try {
        await _ddragonProvider.updateGameVersion();
      } on SocketException catch (error) {
        setState(() {
          _isAuthFailed = true;
        });
      } catch (error) {
        print("ERROR IN SPLASH SCREEN ${error.message}");
      }
      await _initAdMob();
      _navigateFromSplashOperation();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;
    ConstraintHelper.appWidth = _size.width;
    ConstraintHelper.appHeight = _size.height;
    ConstraintHelper.appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: _isAuthFailed
              ? RaisedButton(
                  color: Colors.black87,
                  child: Text(
                    "TRY AGAIN",
                    style: TextStyle(
                      color: Colors.white70
                    ),
                  ),
                  onPressed: _navigateFromSplashOperation
                )
              : Platform.isAndroid
                ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),)
                : CupertinoActivityIndicator(),
        )
      ),
    );
  }

  void _navigateFromSplashOperation() async {
    final FirebaseUser firebaseUser = await _authProvider.getCurrentUser();
    if(firebaseUser != null) {
      _user.setUid(firebaseUser.uid);
      // LoggedIn user found
      try {
        await _backendProvider.checkIfSummonerConnectedAndGetData();
        // Summoner account already connected , get latest information from puuid, and update firestore information with new values
        await _lolProvider.getSummonerInfoByPuuid(_summoner.puuid, _summoner.serverTag);
        await _backendProvider.updateSummoner();
        Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
      } catch (error) {
        final errorMassage = "Authentication failed, please check your network and try again later";
        if(error.message == "Summoner not found") {
          // Summoner account not connected, move to login_screen
          Navigator.of(context).pushNamed(ConnectAccountScreen.routeName);
        }else{
          _showErrorDialog(errorMassage);
        }
      }
    }else{
      // LoggedIn user not found
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => Platform.isAndroid
        ? AlertDialog(
          title: Text("Authentication failed"),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text("OK", style: TextStyle(color: Colors.amber),),
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() {_isAuthFailed = true;});
              },
            )
          ],
        )
        : CupertinoAlertDialog(
          title: Text("Authentication failed"),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() {_isAuthFailed = true;});
              },
            )
          ],
        )
    );
  }

  // Initialize adMob
  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

}
