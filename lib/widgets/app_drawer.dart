import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/providers/auth_provider.dart';
import 'package:lol_rewarder/providers/backend_provider.dart';
import 'package:lol_rewarder/screens/all_challenges_screen.dart';
import 'package:lol_rewarder/screens/challenge_screen.dart';
import 'package:lol_rewarder/screens/login_screen.dart';
import 'package:lol_rewarder/screens/main_screen.dart';

class AppDrawer extends StatefulWidget {

  // Constants
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final String _iconFinderUrl = "http://ddragon.leagueoflegends.com/cdn/9.3.1/img/profileicon/";

  final _authProvider = AuthProvider();

  final _backendProvider = BackendProvider();

  Summoner _summoner = Summoner();

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
              ListTile(
                title: Text(
                  "Home",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
                },
              ),
              ListTile(
                title: Text(
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
              ListTile(
                title: Text(
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
                  }
                },
              ),
              ListTile(
                title: Text(
                  "My Rewards",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onTap: () {
                  // Go to home page
                },
              ),
              ListTile(
                title: Text(
                  "Available Rewards",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onTap: () {
                 // Go to home page
                },
              ),
              ListTile(
                title: Text(
                  "Log Out",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onTap: () async {
                  await _authProvider.logOutUser();
                  Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
                },
              ),
            ],),
          ),
      ),
    );
  }
}
