import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/skin.dart';

class SliderItem extends StatelessWidget {

  final Skin skin;
  final String championName;

  SliderItem(this.skin,this.championName);

  @override
  Widget build(BuildContext context) {

    // Constants
    final String skinPathUrl = "https://ddragon.leagueoflegends.com/cdn/img/champion/loading/";

    final _mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (ctx, constraints) => Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: constraints.maxHeight * 0.9,
              child: Image.network(
                "$skinPathUrl${championName}_${skin.num}.jpg"
              ),
            ),
            Scrollbar(
              child: SingleChildScrollView(
                child: Text(
                  skin.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: _mediaQuery.size.height * 20 / ConstraintHelper.screenHeightCoe,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}