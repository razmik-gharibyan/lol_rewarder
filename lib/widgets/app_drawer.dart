import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/providers/auth_provider.dart';
import 'package:lol_rewarder/screens/login_screen.dart';

class AppDrawer extends StatelessWidget {

  // Constants
  final String _iconFinderUrl = "http://ddragon.leagueoflegends.com/cdn/9.3.1/img/profileicon/";
  // Tools
  final _authProvider = AuthProvider();
  // Singletons
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
              Divider(),
              ListTile(
                title: Text(
                  "All Challenges",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onTap: () {
                  // Go to home page
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Active Challenge",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onTap: () {
                  // Go to home page
                },
              ),
              Divider(),
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
              Divider(),
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
              Divider(),
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
