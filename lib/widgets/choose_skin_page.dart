import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/current_skin_holder.dart';
import 'package:lol_rewarder/widgets/skinpicker/slide_dot.dart';
import 'package:lol_rewarder/widgets/skinpicker/slider_item.dart';

class ChooseSkinPage extends StatefulWidget {

  @override
  _ChooseSkinPageState createState() => _ChooseSkinPageState();
}

class _ChooseSkinPageState extends State<ChooseSkinPage> {

  // Tools
  var _pageController = PageController(initialPage: 0);
  // Singletons
  CurrentSkinHolder _currentSkinHolder = CurrentSkinHolder();
  // Vars
  int _currentIndex = 0;


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: _size.height * 0.7,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              onPageChanged: _onPageChanged,
              itemBuilder: (ctx, index) => SliderItem(_currentSkinHolder.skinList[index],_currentSkinHolder.championName),
              itemCount: _currentSkinHolder.skinList.length,
            ),
          ),
          Container(
            height: _size.height * 0.02,
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for(int i = 0; i < _currentSkinHolder.skinList.length; i++)
                    if(i == _currentIndex)
                      SlideDot(true)
                    else
                      SlideDot(false)
                ],
              ),
            ),
          ),
          ButtonTheme(
            minWidth: _size.height * 150 / ConstraintHelper.screenHeightCoe,
            height: _size.height * 45 / ConstraintHelper.screenHeightCoe,
            child: RaisedButton(
              child: Text(
                "GET SKIN",
                style: TextStyle(
                    fontSize: _size.height * 15 / ConstraintHelper.screenHeightCoe,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: Colors.amber,
              textColor: Colors.white70,
              splashColor: Colors.amberAccent,
              onPressed: () async {

              },
            )
          ),
        ],
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

}
