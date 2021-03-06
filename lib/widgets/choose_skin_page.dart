import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/helper/db_helper.dart';
import 'package:lol_rewarder/model/challenge.dart';
import 'package:lol_rewarder/model/current_skin_holder.dart';
import 'package:lol_rewarder/model/skin.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/providers/backend_provider.dart';
import 'package:lol_rewarder/providers/challenge_provider.dart';
import 'package:lol_rewarder/screens/choose_skin_screen.dart';
import 'package:lol_rewarder/screens/main_screen.dart';
import 'package:lol_rewarder/widgets/skinpicker/slide_dot.dart';
import 'package:lol_rewarder/widgets/skinpicker/slider_item.dart';

class ChooseSkinPage extends StatefulWidget {

  @override
  _ChooseSkinPageState createState() => _ChooseSkinPageState();
}

class _ChooseSkinPageState extends State<ChooseSkinPage> {

  // Tools
  var _pageController = PageController(initialPage: 0);
  final _backendProvider = BackendProvider();
  final _challengeProvider = ChallengeProvider();
  // Singletons
  Summoner _summoner = Summoner();
  CurrentSkinHolder _currentSkinHolder = CurrentSkinHolder();
  Challenge _challenge = Challenge();
  // Vars
  int _currentIndex = 0;


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (c,constraints) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 16,
              child: Container(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (ctx, index) => SliderItem(_currentSkinHolder.skinList[index],_currentSkinHolder.championName),
                  itemCount: _currentSkinHolder.skinList.length,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for(int i = 0; i < _currentSkinHolder.skinList.length; i++)
                        if(i == _currentIndex)
                          SlideDot(true)
                        else
                          SlideDot(false)
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                child: ButtonTheme(
                  minWidth: _size.height * 150 / ConstraintHelper.screenHeightCoe,
                  height: _size.height * 45 / ConstraintHelper.screenHeightCoe,
                  child: RaisedButton(
                    child: Text(
                      "GET SKIN",
                      style: TextStyle(
                          fontSize: _size.height * 15 / ConstraintHelper.screenHeightCoe,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: Colors.amber,
                    textColor: Colors.white70,
                    splashColor: Colors.amberAccent,
                    onPressed: () {
                      _showInformationDialog(context,_currentSkinHolder.skinList[_currentIndex],_currentSkinHolder.championName);
                    },
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showInformationDialog(BuildContext context, Skin skin,String champion) {
    showDialog(
        context: context,
        builder: (ctx) => Platform.isAndroid
        ? AlertDialog(
          title: Text("ATTENTION"),
          content: Text("Attention: Submit only those skins that are available for purchase in official League of Legends"
              " magazine."),
          actions: [
            FlatButton(
              child: Text("OK", style: TextStyle(color: Colors.amber),),
              onPressed: () {
                Navigator.of(ctx).pop();
                _showConfirmationDialog(context,skin,champion);
              },
            )
          ],
        )
        : CupertinoAlertDialog(
          title: Text("ATTENTION"),
          content: Text("Attention: Submit only those skins that are available for purchase in official League of Legends"
              " magazine."),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(ctx).pop();
                _showConfirmationDialog(context,skin,champion);
              },
            )
          ],
        )
    );
  }

  void _showConfirmationDialog(BuildContext context,Skin skin,String champion) {
    showDialog(
        context: context,
        builder: (ctx) => Platform.isAndroid
        ? AlertDialog(
          title: Text("Are you sure?"),
          content: Text("Are you sure you want to get ${skin.name} skin?"
              " Skin will be gifted to ${_summoner.name} summoner in ${_summoner.serverTag.toUpperCase()} server"),
          actions: [
            FlatButton(
              child: Text("CANCEL", style: TextStyle(color: Colors.black87),),
              onPressed: () {Navigator.of(ctx).pop();},
            ),
            FlatButton(
              child: Text("GET SKIN", style: TextStyle(color: Colors.amber),),
              onPressed: () async {
                final List<dynamic> thisMonthSkinList = await _backendProvider.getThisMonthAllRewards();
                if(thisMonthSkinList.contains(true)) {
                  await _addSkinToDatabase(context,skin,champion,thisMonthSkinList);
                }else{
                  _showNoAvailableSkin(context);
                }
              },
            )
          ],
        )
        : CupertinoAlertDialog(
          title: Text("Are you sure?"),
          content: Text("Are you sure you want to get ${skin.name} skin?"
              " Skin will be gifted to ${_summoner.name} summoner in ${_summoner.serverTag.toUpperCase()} server"),
          actions: [
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {Navigator.of(ctx).pop();},
            ),
            FlatButton(
              child: Text("GET SKIN"),
              onPressed: () async {
                final List<dynamic> thisMonthSkinList = await _backendProvider.getThisMonthAllRewards();
                if(thisMonthSkinList.contains(true)) {
                  await _addSkinToDatabase(context,skin,champion,thisMonthSkinList);
                }else{
                  _showNoAvailableSkin(context);
                }
              },
            )
          ],
        )
    );
  }

  Future<void> _addSkinToDatabase(BuildContext context,Skin skin,String champion,List<dynamic> list) async {
    try {
      await _backendProvider.addSkinToDatabase(skin.name);
      int availableSkinIndex = 0;
      for(var element in list) {
        if(element) {
          break;
        }
        availableSkinIndex++;
      }
      list[availableSkinIndex] = false;
      await _backendProvider.updateAllRewards({"rewardList": list});
      await _showSuccessSnackBar(context,skin,champion);
    }catch(error) {
      if(error.message == "Skin was not added") {
        _showErrorDialog(context);
      }
    }
  }

  Future<void> _showSuccessSnackBar(BuildContext context,Skin skin,String champion) async {
    Navigator.of(context).popUntil((route) => route.settings.name == MainScreen.routeName);
    await _backendProvider.addRewardToSummonerRewardList(skin,champion);
    _summoner.setActiveChallenge(null);
    _challenge.clear();
    _currentSkinHolder.clear();
    await DBHelperProvider().deleteGames();
    await _backendProvider.updateSummoner();
    _challengeProvider.addSkinFunctionCallback();
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => Platform.isAndroid
        ? AlertDialog(
          title: Text("REQUEST FAILED"),
          content: Text("Something went wrong please try again later."),
          actions: [
            FlatButton(
              child: Text("OK", style: TextStyle(color: Colors.amber),),
              onPressed: () {Navigator.of(ctx).pop();},
            )
          ],
        )
        : CupertinoAlertDialog(
          title: Text("REQUEST FAILED"),
          content: Text("Something went wrong please try again later."),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {Navigator.of(ctx).pop();},
            )
          ],
        )
    );
  }

  void _showNoAvailableSkin(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => Platform.isAndroid
        ? AlertDialog(
          title: Text("REQUEST FAILED"),
          content: Text("Available skins for this month are over. But you can always get your reward next month"),
          actions: [
            FlatButton(
              child: Text("OK", style: TextStyle(color: Colors.amber),),
              onPressed: () {Navigator.of(context).popUntil((route) => route.settings.name == ChooseSkinScreen.routeName);},
            )
          ],
        )
        : CupertinoAlertDialog(
          title: Text("REQUEST FAILED"),
          content: Text("Available skins for this month are over. But you can always get your reward next month"),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {Navigator.of(context).popUntil((route) => route.settings.name == ChooseSkinScreen.routeName);},
            )
          ],
        )
    );
  }
}
