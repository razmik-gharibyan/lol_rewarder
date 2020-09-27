import 'package:flutter/material.dart';
import 'package:lol_rewarder/screens/connect_account_screen.dart';
import 'package:lol_rewarder/screens/login_screen.dart';
import 'package:lol_rewarder/screens/main_screen.dart';
import 'package:lol_rewarder/screens/signup_screen.dart';

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
      home: LoginScreen(),
      routes: {
        SignUpScreen.routeName: (ctx) => SignUpScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        ConnectAccountScreen.routeName: (ctx) => ConnectAccountScreen(),
        MainScreen.routeName: (ctx) => MainScreen(),
      },
    );
  }
}
