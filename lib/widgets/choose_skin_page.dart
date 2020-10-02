import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/current_skin_holder.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/widgets/skinpicker/slide_dot.dart';
import 'package:lol_rewarder/widgets/skinpicker/slider_item.dart';

class ChooseSkinPage extends StatefulWidget {

  @override
  _ChooseSkinPageState createState() => _ChooseSkinPageState();
}

class _ChooseSkinPageState extends State<ChooseSkinPage> {

  // Tools
  var _pageController = PageController(initialPage: 0);
  // Singletons
  Summoner _summoner = Summoner();
  CurrentSkinHolder _currentSkinHolder = CurrentSkinHolder();
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

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: _size.height * 0.7,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              onPageChanged: _onPageChanged,
              itemBuilder: (ctx, index) => SliderItem(_currentSkinHolder.skinList[index],_currentSkinHolder.championName),
              itemCount: _currentSkinHolder.skinList.length,
            ),
          ),
          Container(
            height: _size.height * 0.02,
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
          ButtonTheme(
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
                _showInformationDialog(context,_currentSkinHolder.skinList[_currentIndex].name);
              },
            )
          ),
        ],
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showInformationDialog(BuildContext context, String skinName) {
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
                _showConfirmationDialog(context, skinName);
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
                _showConfirmationDialog(context, skinName);
              },
            )
          ],
        )
    );
  }

  void _showConfirmationDialog(BuildContext context,String skinName) {
    showDialog(
        context: context,
        builder: (ctx) => Platform.isAndroid
        ? AlertDialog(
          title: Text("Are you sure?"),
          content: Text("Are you sure you want to get $skinName skin?"
              " Skin will be gifted to ${_summoner.name} summoner in ${_summoner.serverTag.toUpperCase()} server"),
          actions: [
            FlatButton(
              child: Text("CANCEL", style: TextStyle(color: Colors.black87),),
              onPressed: () {Navigator.of(ctx).pop();},
            ),
            FlatButton(
              child: Text("GET SKIN", style: TextStyle(color: Colors.amber),),
              onPressed: () async {
                sendEmail(skinName);
              },
            )
          ],
        )
        : CupertinoAlertDialog(
          title: Text("Are you sure?"),
          content: Text("Are you sure you want to get $skinName skin?"
              " Skin will be gifted to ${_summoner.name} summoner in ${_summoner.serverTag.toUpperCase()} server"),
          actions: [
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {Navigator.of(ctx).pop();},
            ),
            FlatButton(
              child: Text("GET SKIN"),
              onPressed: () async {
                sendEmail(skinName);
              },
            )
          ],
        )
    );
  }

  void sendEmail(String skinName) async {

  }

}
