import 'package:flutter/material.dart';
import 'package:lol_rewarder/extensions/hex_to_rgb.dart';
import 'package:lol_rewarder/helper/champion_id_helper.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/current_skin_holder.dart';
import 'package:lol_rewarder/providers/ddragon_provider.dart';
import 'package:lol_rewarder/screens/choose_skin_screen.dart';

class ChooseChampionListView extends StatefulWidget {
  @override
  _ChooseChampionListViewState createState() => _ChooseChampionListViewState();
}

class _ChooseChampionListViewState extends State<ChooseChampionListView> {

  // Tools
  final _ddragonProvider = DDragonProvider();
  // Singletons
  CurrentSkinHolder _currentSkinHolder = CurrentSkinHolder();

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return Container(
        child: ListView.builder(
          itemBuilder: (ctx, index) => Container(
            height: _size.height * 0.1,
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
            child: InkWell(
              child: Container(
                padding: EdgeInsets.only(left: _size.height * 25 / ConstraintHelper.screenHeightCoe),
                alignment: Alignment.centerLeft,
                color: HexColor.fromHex("f0f0f0"),
                child: Text(
                  ChampionIdHelper.champions.values.toList()[index],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _size.height * 20 / ConstraintHelper.screenHeightCoe
                  ),
                ),
              ),
              onTap: () async {
                final skinList = await _ddragonProvider.getSkinListForChampion(ChampionIdHelper.champions.values.toList()[index]);
                _currentSkinHolder.setSkinList(skinList);
                _currentSkinHolder.setChampionName(ChampionIdHelper.champions.values.toList()[index]);
                Navigator.of(context).pushNamed(ChooseSkinScreen.routeName);
              },
            ),
          ),
          itemCount: ChampionIdHelper.champions.length,
        )
    );
  }
}
