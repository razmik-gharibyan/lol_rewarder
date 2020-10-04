import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/providers/backend_provider.dart';

class AllRewardsGridView extends StatefulWidget {
  @override
  _AllRewardsGridViewState createState() => _AllRewardsGridViewState();
}

class _AllRewardsGridViewState extends State<AllRewardsGridView> {

  // Constants
  final String _availableSkinAsset = "assets/images/skin.png";
  final String _ownedSkinAsset = "assets/images/skin_owned.png";
  // Tools
  final _backendProvider = BackendProvider();

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: _backendProvider.getThisMonthAllRewards(),
        builder: (ct, result) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: _size.height * 0.8,
              child: GridView.builder(
                padding: EdgeInsets.all(_size.height * 10 / ConstraintHelper.screenHeightCoe),
                itemCount: result.connectionState == ConnectionState.done ? result.data.length : 0,
                itemBuilder: (ctx, index) => Container(
                  child: Padding(
                    padding: EdgeInsets.all(_size.height * 8 / ConstraintHelper.screenHeightCoe),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: _size.width * 0.2,
                            height: _size.height * 0.2,
                            child: Image.asset(result.data[index] ? _availableSkinAsset : _ownedSkinAsset, fit: BoxFit.fill,),
                          ),
                          Expanded(
                            child: Text(
                              result.data[index] ? "Skin Available" : "Skin Owned",
                              style: TextStyle(
                                color: result.data[index] ? Colors.amber : Colors.black87,
                                fontSize: _size.height * 11 / ConstraintHelper.screenHeightCoe,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,childAspectRatio: 1/2,crossAxisSpacing: 0,mainAxisSpacing: 0
                ),
              ),
            ),
            Container(
              width: _size.width,
              height: _size.height * 0.05,
              color: Colors.black87,
              alignment: Alignment.center,
              child: Text(
                "Skins available ${_findOwnedSkinCount(result.data != null ? result.data : List<dynamic>())} / "
                    "${result.data != null ? result.data.length : 0}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _size.height * 15 / ConstraintHelper.screenHeightCoe,
                  color: Colors.white
                ),
              ),
            )
          ],
        ),
    );
  }

  int _findOwnedSkinCount(List<dynamic> skinList) {
    int ownedSkinsCount = 0;
    for(var skin in skinList) {
      if (skin) ownedSkinsCount++;
    }
    return ownedSkinsCount;
  }

}
