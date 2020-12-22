import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/challenge.dart';
import 'package:lol_rewarder/model/current_skin_holder.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/model/user.dart';
import 'package:lol_rewarder/providers/auth_provider.dart';
import 'package:lol_rewarder/providers/backend_provider.dart';
import 'package:lol_rewarder/providers/ddragon_provider.dart';
import 'package:lol_rewarder/screens/all_challenges_screen.dart';
import 'package:lol_rewarder/screens/all_rewards_screen.dart';
import 'package:lol_rewarder/screens/challenge_screen.dart';
import 'package:lol_rewarder/screens/login_screen.dart';
import 'package:lol_rewarder/screens/main_screen.dart';
import 'package:lol_rewarder/screens/my_rewards_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lol_rewarder/globals.dart' as globals;

class AppDrawer extends StatefulWidget {

  // Constants
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {


  // Tools
  final _authProvider = AuthProvider();
  final _backendProvider = BackendProvider();
  final _ddragonProvider = DDragonProvider();
  // Vars
  String _iconFinderUrl = "https://ddragon.leagueoflegends.com/cdn/10.19.1/img/profileicon/";
  Summoner _summoner = Summoner();
  Challenge _challenge = Challenge();
  CurrentSkinHolder _currentSkinHolder = CurrentSkinHolder();
  User _user = User();

  @override
  void initState() {
    _iconFinderUrl = "https://ddragon.leagueoflegends.com/cdn/${_ddragonProvider.gameVersion}/img/profileicon/";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return Container(
      width: _size.width * 0.6,
      child: Drawer(
          child: Container(
            color: Colors.black87,
            child: Column(children: [
              AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  "Main Menu",
                  style: TextStyle(
                    color: Colors.black87
                  ),
                ),
                automaticallyImplyLeading: false,
              ),
              SizedBox(height: _size.height * 0.1,),
              Padding(
                padding: EdgeInsets.all(_size.height * 15 / ConstraintHelper.screenHeightCoe),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage("$_iconFinderUrl${_summoner.iconId}.png"),
                      radius: _size.height * 25 / ConstraintHelper.screenHeightCoe,
                    ),
                    Text(
                      _summoner.name,
                      style: TextStyle(
                        color: Colors.amber
                      ),
                    )
                  ],
                ),
              ),
              Divider(color: Colors.grey,),
              Container(
                height: _size.height * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Text(
                          "Home",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
                      },
                    ),
                   InkWell(
                     child: Text(
                          "All Challenges",
                          style: TextStyle(
                              color: Colors.white
                          ),
                     ),
                     onTap: () {
                       Navigator.of(context).pushNamedAndRemoveUntil(
                           AllChallengesScreen.routeName, (route) => (route.settings.name == MainScreen.routeName)
                       );
                     },
                   ),
                    InkWell(
                      child: Text(
                        "Active Challenge",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                      onTap: () async {
                        if(_summoner.activeChallenge != null) {
                          await _backendProvider.getChallengeDocumentById(_summoner.activeChallenge);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              ChallengeScreen.routeName, (route) => (route.settings.name == MainScreen.routeName)
                          );
                        }else{
                          setState(() {
                            Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("You don't have active challenge"),
                                  duration: Duration(seconds: 3),
                                )
                            );
                          });
                        }},
                    ),
                    InkWell(
                      child: Text(
                          "Available Rewards",
                          style: TextStyle(
                              color: Colors.white
                          ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            AllRewardsScreen.routeName, (route) => (route.settings.name == MainScreen.routeName)
                        );
                      },
                    ),
                    InkWell(
                      child: Text(
                          "My Rewards",
                          style: TextStyle(
                              color: Colors.white
                          ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            MyRewardsScreen.routeName, (route) => (route.settings.name == MainScreen.routeName)
                        );
                      },
                    ),
                    InkWell(
                      child: Text(
                          "Log Out",
                          style: TextStyle(
                              color: Colors.white
                          ),
                      ),
                      onTap: () async {
                        await _authProvider.logOutUser();
                        var preferences = await SharedPreferences.getInstance();
                        preferences.remove(globals.TIMESTAMP);
                        _summoner.clear();
                        _challenge.clear();
                        _currentSkinHolder.clear();
                        _user.clear();
                        Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
                      },
                    ),
                  ],
                ),
              )
            ],),
          ),
      ),
    );
  }
}
