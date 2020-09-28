import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/menu_item.dart';

class MainMenuGrid extends StatelessWidget {

  // Constants
  final List<MenuItem> _menuItemList = [
    MenuItem("All challenges", "assets/images/challenges.png", "View all available challenges", "/"),
    MenuItem("Active challenge", "assets/images/mychallenge.png", "View currently active challenge", "/"),
    MenuItem("All rewards", "assets/images/allrewards.png", "Available rewards for this month", "/"),
    MenuItem("My rewards", "assets/images/myrewards.png", "View all your rewards", "/")
  ];

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
            onTap: () {
              Navigator.of(context).pushNamed(_menuItemList[index].navigation);
            },
          ),
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,childAspectRatio: 3/2,crossAxisSpacing: 10,mainAxisSpacing: 10
      ),
    );
  }

}
