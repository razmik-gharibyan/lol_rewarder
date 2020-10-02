import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';

class SlideDot extends StatelessWidget {

  final bool _isDotActive;

  SlideDot(this._isDotActive);

  @override
  Widget build(BuildContext context) {

    final _mediaQuery = MediaQuery.of(context);

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: _mediaQuery.size.height * 5 / ConstraintHelper.screenHeightCoe),
      width: _isDotActive ? _mediaQuery.size.height * 10 / ConstraintHelper.screenHeightCoe : _mediaQuery.size.height * 6 / ConstraintHelper.screenHeightCoe,
      height: _isDotActive ? _mediaQuery.size.height * 10 / ConstraintHelper.screenHeightCoe : _mediaQuery.size.height * 6 / ConstraintHelper.screenHeightCoe,
      decoration: BoxDecoration(
          color: _isDotActive ? Colors.amber : Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(_mediaQuery.size.height * 10 / ConstraintHelper.screenHeightCoe))
      ),
    );
  }
}