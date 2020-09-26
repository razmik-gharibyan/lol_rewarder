import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';

class ConnectAccountScreen extends StatefulWidget {

  static const routeName = "/connect_account_screen";

  @override
  _ConnectAccountScreenState createState() => _ConnectAccountScreenState();
}

class _ConnectAccountScreenState extends State<ConnectAccountScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey();

  // Constants
  final List<String> _serverTagList = ["BR","EUW","EUN","JP","KR","NA","OC","RU","TR"];
  // Vars
  bool _summonerNameValid = true;
  String summonerName = "";
  String serverTag = "EUW";

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: _size.width,
          height: _size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
              image: AssetImage("assets/images/background_pattern.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        height: _size.height * 0.35,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "CONNECT SUMMONER ACCOUNT",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 23 * _size.height / ConstraintHelper.screenHeightCoe
                              ),
                            ),
                            Container(
                              width: _size.width * 0.8,
                              margin: EdgeInsets.symmetric(vertical: 8 * _size.height / ConstraintHelper.screenHeightCoe),
                              padding: EdgeInsets.all(8 * _size.height / ConstraintHelper.screenHeightCoe),
                              color: Colors.black87,
                                child: Text(
                                  "Enter you summoner name and game server below to connect Summoner account."
                                      " Connecting summoner is required, because after successfully completing challenges"
                                      " we will send gift skins to specified summoner account. You cannot change account after",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13 * _size.height / ConstraintHelper.screenHeightCoe
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        width: _size.width * 0.8,
                        height: _size.height * 0.45,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: _size.width * 0.8,
                                    height: _size.height * 0.1,
                                    child: TextFormField(
                                      style: TextStyle(
                                        fontSize: (_size.height * 14) / ConstraintHelper.screenHeightCoe,
                                      ),
                                      cursorColor: Colors.black87,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: "Summoner Name",
                                          labelStyle: TextStyle(
                                              fontSize: _size.height * 18 / ConstraintHelper.screenHeightCoe,
                                              color: Colors.black87
                                          ),
                                          contentPadding: EdgeInsets.symmetric(vertical: 2),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.amber),
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87),
                                          ),
                                          errorStyle: TextStyle(
                                            fontSize: (_size.height * 14) / ConstraintHelper.screenHeightCoe,
                                          )
                                      ),
                                      validator: (value) {
                                        if(value.isEmpty) {
                                          _summonerNameValid = false;
                                          return "Please enter e-mail address";
                                        }
                                      },
                                      onSaved: (value) {
                                        summonerName = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  width: _size.width * 0.8,
                                  child: DropdownButtonFormField<String>( // into this
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelText: 'Select Server',
                                      labelStyle: TextStyle(
                                        color: Colors.black87,
                                        fontSize: _size.height * 18 / ConstraintHelper.screenHeightCoe,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black87),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.amber),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black87),
                                      ),
                                      errorStyle: TextStyle(
                                        fontSize: (_size.height * 14) / ConstraintHelper.screenHeightCoe,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: _size.height * 9 / ConstraintHelper.screenHeightCoe),
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        serverTag = newValue;
                                      });
                                    },
                                    value: serverTag,
                                    items: _serverTagList.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  )
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
