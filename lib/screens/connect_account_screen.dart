import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/providers/backend_provider.dart';
import 'package:lol_rewarder/providers/ddragon_provider.dart';
import 'package:lol_rewarder/providers/lol_provider.dart';
import 'package:lol_rewarder/screens/login_screen.dart';
import 'package:lol_rewarder/screens/main_screen.dart';

class ConnectAccountScreen extends StatefulWidget {

  static const routeName = "/connect_account_screen";

  @override
  _ConnectAccountScreenState createState() => _ConnectAccountScreenState();
}

class _ConnectAccountScreenState extends State<ConnectAccountScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey();

  // Constants
  final List<String> _serverTagList = ["BR","EUW","EUN","JP","KR","NA","LAN","LAS","OC","RU","TR"];
  String _iconFinderUrl = "https://ddragon.leagueoflegends.com/cdn/10.19.1/img/profileicon/";
  // Custom Exception constants
  final String _summonerNotFoundCustomExceptionMsg = "SUMMONER_NOT_FOUND";
  // Tools
  final _lolProvider = LoLProvider();
  final _backendProvider = BackendProvider();
  final _ddragonProvider = DDragonProvider();
  // Singletons
  Summoner _summoner = Summoner();
  // Vars
  String _summonerName = "";
  String _serverTag = "EUW";
  bool _isLoading = false;

  @override
  void initState() {
    _iconFinderUrl = "https://ddragon.leagueoflegends.com/cdn/${_ddragonProvider.gameVersion}/img/profileicon/";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
            color: Colors.white,
            iconSize: _size.height * 25 / ConstraintHelper.screenHeightCoe,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
          ),
        ),
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
                              Container(
                                width: _size.width * 0.8,
                                child: Text(
                                  "CONNECT SUMMONER ACCOUNT",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23 * _size.height / ConstraintHelper.screenHeightCoe
                                  ),
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
                                        " we will send gift skins to specified summoner account.",
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
                                            return "Please enter summoner name";
                                          }
                                        },
                                        onSaved: (value) {
                                          _summonerName = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                    width: _size.width * 0.8,
                                    height: _size.height * 0.1,
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
                                          _serverTag = newValue;
                                        });
                                      },
                                      value: _serverTag,
                                      items: _serverTagList.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    )
                                ),
                                SizedBox(
                                  height: _size.height * 0.05,
                                ),
                                Container(
                                  height: _size.height * 0.1,
                                  alignment: Alignment.center,
                                  child: ButtonTheme(
                                    minWidth: _size.height * 250 / ConstraintHelper.screenHeightCoe,
                                    height: _size.height * 40 / ConstraintHelper.screenHeightCoe,
                                    child: RaisedButton(
                                      child: Text(
                                        "Find Summoner",
                                        style: TextStyle(
                                          fontSize: _size.height * 17 / ConstraintHelper.screenHeightCoe,
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
                                      onPressed: _submit,
                                    ),
                                  ),
                                ),
                                Text(
                                  "* you cannot change account after its connection",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: _size.height * 11 / ConstraintHelper.screenHeightCoe
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                _isLoading ? Center(
                  child: Platform.isAndroid
                      ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),)
                      : CupertinoActivityIndicator(),
                ) : Center()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await _lolProvider.getSummonerInfoByName(_summonerName, _serverTag);
      _showSummonerDialog();
    } on SocketException catch (error) {
      String errorMessage = "Connection failed, try again later";
      if(error.osError.message == "Network is unreachable" || error.osError.message == "No address associated with hostname") {
        errorMessage = "No internet connection";
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      String errorMassage = "Failed to get summoner information,try again later";
      if(error.message == _summonerNotFoundCustomExceptionMsg) {
        errorMassage = "Summoner not found";
      }
      _showErrorDialog(errorMassage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => Platform.isAndroid
        ? AlertDialog(
          title: Text("Request failed"),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text("OK", style: TextStyle(color: Colors.amber),),
              onPressed: () {Navigator.of(ctx).pop();},
            )
          ],
        )
        : CupertinoAlertDialog(
          title: Text("Request failed"),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {Navigator.of(ctx).pop();},
            )
          ],
        )
    );
  }

  void _showSummonerDialog() {
    showDialog(
        context: context,
        builder: (ctx) => Platform.isAndroid
        ? AlertDialog(
          title: Text("Add Summoner",textAlign: TextAlign.center,),
          content: Column(
            children: [
              Image.network("$_iconFinderUrl${_summoner.iconId}.png",fit: BoxFit.fill,),
              Text(_summoner.name),
              Text("LVL ${_summoner.summonerLevel}"),
            ],
          ),
          actions: [
            FlatButton(
              child: Text("CANCEL", style: TextStyle(color: Colors.black87),),
              onPressed: () {Navigator.of(ctx).pop();},
            ),
            FlatButton(
              child: Text("ADD SUMMONER", style: TextStyle(color: Colors.amber),),
              onPressed: () async {
                try {
                  final QuerySnapshot result = await _backendProvider.checkIfSummonerExists(_summoner.name,_summoner.serverTag);
                  if(result.documents.isEmpty) {
                    // Summoner not found, so you can add new summoner to firebase
                    await _backendProvider.addSummoner();
                    Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
                  }else{
                    Navigator.of(context).pop();
                    String errorMessage = "Summoner already exists, use different summoner account";
                    _showErrorDialog(errorMessage);
                  }
                }catch (error) {
                  String errorMessage = "Failed to get summoner information,try again later";
                  _showErrorDialog(errorMessage);
                }
              },
            )
          ],
        )
        : CupertinoAlertDialog(
          title: Text("Add Summoner",textAlign: TextAlign.center,),
          content: Column(
            children: [
              Image.network("$_iconFinderUrl${_summoner.iconId}.png",fit: BoxFit.fill,),
              Text(_summoner.name),
              Text("LVL ${_summoner.summonerLevel}"),
            ],
          ),
          actions: [
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {Navigator.of(ctx).pop();},
            ),
            FlatButton(
              child: Text("ADD SUMMONER"),
              onPressed: () async {
                try {
                  final QuerySnapshot result = await _backendProvider.checkIfSummonerExists(_summoner.name,_summoner.serverTag);
                  if(result.documents.isEmpty) {
                    // Summoner not found, so you can add new summoner to firebase
                    await _backendProvider.addSummoner();
                    Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
                  }else{
                    Navigator.of(context).pop();
                    String errorMessage = "Summoner already exists, use different summoner account";
                    _showErrorDialog(errorMessage);
                  }
                }catch (error) {
                  String errorMessage = "Failed to get summoner information,try again later";
                  _showErrorDialog(errorMessage);
                }
              }
            )
          ],
        )
    );
  }

}
