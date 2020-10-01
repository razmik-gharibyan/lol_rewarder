import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';

class GetRewardButton extends StatelessWidget {

  Size size;


  GetRewardButton(this.size,);

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

      },
    );
  }
}
