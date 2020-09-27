import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';

class MainScreen extends StatefulWidget {

  static const routeName = "/main_screen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
          color: Colors.white,
          iconSize: _size.height * 25 / ConstraintHelper.screenHeightCoe,
          onPressed: () {

          },
        ),
      ),
    );
  }
}
