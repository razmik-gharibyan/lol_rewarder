import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';

class AllChallengesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, index) => Container(
          height: _size.height * 0.115,
          margin: EdgeInsets.only(
            bottom: _size.height * 15 / ConstraintHelper.screenHeightCoe,
            left: _size.height * 15 / ConstraintHelper.screenHeightCoe,
            right: _size.height * 15 / ConstraintHelper.screenHeightCoe,
          ),
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
        ),
        itemCount: 6,
      ),
    );
  }
}
