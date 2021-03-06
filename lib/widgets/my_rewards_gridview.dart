import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/providers/backend_provider.dart';

class MyRewardsGridView extends StatefulWidget {
  @override
  _MyRewardsGridViewState createState() => _MyRewardsGridViewState();
}

class _MyRewardsGridViewState extends State<MyRewardsGridView> {

  // Constants
  final String skinPathUrl = "https://ddragon.leagueoflegends.com/cdn/img/champion/loading/";
  // Tools
  final _backendProvider = BackendProvider();
  // Singletons
  Summoner _summoner = Summoner();

  @override
  Widget build(BuildContext context) {

  final _size = MediaQuery.of(context).size;
  final _itemWidth = _size.width * 0.3;
  final _itemHeight = _size.height * 0.3;

    return LayoutBuilder(
      builder: (c, constraint) => FutureBuilder(
        future: _backendProvider.checkIfSummonerConnectedAndGetData(),
        builder: (ct, result) => _summoner.rewardList != null ? GridView.builder(
          padding: EdgeInsets.all(_size.height * 10 / ConstraintHelper.screenHeightCoe),
          itemCount: _summoner.rewardList.length,
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
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 14,
                        child: Container(
                          child: Image.network("$skinPathUrl${_summoner.rewardList[index]["champion"]}_"
                              "${_summoner.rewardList[index]["num"]}.jpg", fit: BoxFit.fill,),
                        ),
                      ),
                       Expanded(
                         flex: 1,
                         child: Text(
                          _summoner.rewardList[index]["name"],
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: _size.height * 12 / ConstraintHelper.screenHeightCoe
                          ),
                         ),
                       ),
                    ],
                  ),
              ),
            ),
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,childAspectRatio: (_itemWidth / _itemHeight),crossAxisSpacing: 5,mainAxisSpacing: 5
          ),
        )
        : Center(
          child: Text(
            "You don't have rewards yet"
          ),
        )
      ),
    );
  }
}
