import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/menu_item.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/providers/backend_provider.dart';
import 'package:lol_rewarder/providers/challenge_provider.dart';
import 'package:lol_rewarder/screens/all_challenges_screen.dart';
import 'package:lol_rewarder/screens/all_rewards_screen.dart';
import 'package:lol_rewarder/screens/challenge_screen.dart';
import 'package:lol_rewarder/screens/my_rewards_screen.dart';

class MainMenuGrid extends StatefulWidget {

  // Constants
  @override
  _MainMenuGridState createState() => _MainMenuGridState();
}

class _MainMenuGridState extends State<MainMenuGrid> {
  final List<MenuItem> _menuItemList = [
    MenuItem("All challenges", "assets/images/challenges.png", "View all available challenges", AllChallengesScreen.routeName),
    MenuItem("Active challenge", "assets/images/mychallenge.png", "View currently active challenge", ChallengeScreen.routeName),
    MenuItem("All rewards", "assets/images/allrewards.png", "Available rewards for this month", "/"),
    MenuItem("My rewards", "assets/images/myrewards.png", "View all your rewards", "/")
  ];

  Summoner _summoner = Summoner();

  // Tools
  final _backendProvider = BackendProvider();
  final _challengeProvider = ChallengeProvider();

  @override
  void didChangeDependencies() {
    _challengeProvider.addSkinFunctionCallback = _addSkinCallback;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return GridView.builder(
      padding: EdgeInsets.all(_size.height * 10 / ConstraintHelper.screenHeightCoe),
      itemCount: _menuItemList.length,
      itemBuilder: (ctx, index) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ]
        ),
        child: Padding(
          padding: EdgeInsets.all(_size.height * 8 / ConstraintHelper.screenHeightCoe),
          child: InkWell(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: _size.width * 0.1,
                        height: _size.width * 0.1,
                        child: Image.asset(_menuItemList[index].imageAsset, fit: BoxFit.fill,),
                      ),
                      Text(
                        _menuItemList[index].title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: _size.height * 14 / ConstraintHelper.screenHeightCoe
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _menuItemList[index].description,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: _size.height * 12 / ConstraintHelper.screenHeightCoe
                    ),
                  ),
                ],
              ),
            ),
            onTap: () async {
              await _menuItemPressed(index);
            },
          ),
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,childAspectRatio: 3/2,crossAxisSpacing: 10,mainAxisSpacing: 10
      ),
    );
  }

  Future<void> _menuItemPressed(int index) async {
    switch(_menuItemList[index].title) {
      case "All challenges":
        Navigator.of(context).pushNamed(_menuItemList[index].navigation);
        break;
      case "Active challenge":
        if(_summoner.activeChallenge != null) {
          await _backendProvider.getChallengeDocumentById(_summoner.activeChallenge);
          Navigator.of(context).pushNamed(_menuItemList[index].navigation);
        }else{
          setState(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("You don't have active challenge"),
                duration: Duration(seconds: 3),
              )
            );
          });
        }
        break;
      case "All rewards":
        Navigator.of(context).pushNamed(AllRewardsScreen.routeName);
        break;
      case "My rewards":
        Navigator.of(context).pushNamed(MyRewardsScreen.routeName);
        break;
    }
  }

  void _addSkinCallback() {
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Skin successfully ordered. It will be gifted to ${_summoner.name}"
              " summoner on ${_summoner.serverTag.toUpperCase()} server within 1 day. Thanks"),
          duration: Duration(seconds: 15),
        )
    );
  }

}
