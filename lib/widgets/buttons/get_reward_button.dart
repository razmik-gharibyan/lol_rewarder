import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/screens/choose_skin_screen.dart';

class GetRewardButton extends StatelessWidget {

  Size size;
  bool isAllChallengesComplete;

  GetRewardButton(this.size,this.isAllChallengesComplete);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        "GET REWARD",
        style: TextStyle(
            fontSize: size.height * 17 / ConstraintHelper.screenHeightCoe,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      color: Colors.black87,
      textColor: Colors.white70,
      splashColor: Colors.amber,
      onPressed: () async {
        _checkIfAllChallengesCompleted(context);
      },
    );
  }

  void _checkIfAllChallengesCompleted(BuildContext context) {
    if(isAllChallengesComplete) {
      Navigator.of(context).pushNamed(ChooseSkinScreen.routeName);
    }else{
      Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Complete all challenges to unlock reward"),
            duration: Duration(seconds: 5),
          )
      );
    }
  }

}
