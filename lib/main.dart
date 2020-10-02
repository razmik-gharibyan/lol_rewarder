import 'package:flutter/material.dart';
import 'package:lol_rewarder/screens/all_challenges_screen.dart';
import 'package:lol_rewarder/screens/challenge_screen.dart';
import 'package:lol_rewarder/screens/choose_champion_screen.dart';
import 'package:lol_rewarder/screens/connect_account_screen.dart';
import 'package:lol_rewarder/screens/login_screen.dart';
import 'package:lol_rewarder/screens/main_screen.dart';
import 'package:lol_rewarder/screens/signup_screen.dart';
import 'package:lol_rewarder/screens/splash_screen.dart';
import 'package:lol_rewarder/screens/type_challenge_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "LOLReward",
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      routes: {
        SplashScreen.routeName: (ctx) => SplashScreen(),
        SignUpScreen.routeName: (ctx) => SignUpScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        ConnectAccountScreen.routeName: (ctx) => ConnectAccountScreen(),
        MainScreen.routeName: (ctx) => MainScreen(),
        AllChallengesScreen.routeName: (ctx) => AllChallengesScreen(),
        TypeChallengeScreen.routeName: (ctx) => TypeChallengeScreen(),
        ChallengeScreen.routeName: (ctx) => ChallengeScreen(),
        ChooseChampionScreen.routeName: (ctx) => ChooseChampionScreen(),
      },
    );
  }
}
