import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lol_rewarder/helper/constraint_helper.dart';
import 'package:lol_rewarder/providers/auth_provider.dart';
import 'package:lol_rewarder/screens/connect_account_screen.dart';
import 'package:lol_rewarder/screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {

  static const routeName = "/sign_up_screen";

  // Tools
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  // Tools
  final _authProvider = AuthProvider();
  final _passwordController = TextEditingController();
  // Vars
  var _emailValid = true;
  var _passwordValid = true;
  var _passwordConfirmValid = true;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
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
                  SizedBox(
                    height: _size.height * 0.05,
                  ),
                  Container(
                    height: _size.height * 0.25,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "LOLRewarder",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 40 * _size.height / ConstraintHelper.screenHeightCoe
                          ),
                        ),
                        Container(
                          width: _size.width * 0.9,
                          height: _size.height * 0.05,
                          padding: EdgeInsets.all(5 * _size.height / ConstraintHelper.screenHeightCoe),
                          color: Colors.black87,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "PlAY GAMES | COMPLETE CHALLENGES | EARN SKINS",
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11 * _size.height / ConstraintHelper.screenHeightCoe
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: _size.width * 0.9,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: _size.width * 0.2,
                                height: _size.height * 0.001,
                                color: Colors.black87,
                              ),
                              Container(
                                width: _size.width * 0.45,
                                padding: EdgeInsets.all(_size.height * 5 / ConstraintHelper.screenHeightCoe),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: _size.height * 0.001,
                                    color: Colors.black87
                                  ),
                                ),
                                child: Text(
                                  "Create new account",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15 * _size.height / ConstraintHelper.screenHeightCoe
                                  ),
                                ),
                              ),
                              Container(
                                width: _size.width * 0.2,
                                height: _size.height * 0.001,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: _size.width * 0.8,
                    height: _size.height * 0.4,
                    alignment: Alignment.center,
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: _size.height * 0.13,
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: (_size.height * 14) / ConstraintHelper.screenHeightCoe,
                                ),
                                cursorColor: Colors.black87,
                                decoration: InputDecoration(
                                    labelText: "E-mail",
                                    prefixIcon: Icon(
                                      Icons.email,
                                      size: _size.height * 25 / ConstraintHelper.screenHeightCoe,
                                      color: Colors.grey,
                                    ),
                                    labelStyle: TextStyle(
                                        fontSize: _size.height * 20 / ConstraintHelper.screenHeightCoe,
                                        color: Colors.black87
                                    ),
                                    isDense: true,
                                    contentPadding: _emailValid ? EdgeInsets.symmetric(vertical: 2) : EdgeInsets.only(bottom: 2),
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
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if(value.isEmpty) {
                                    _emailValid = false;
                                    return "Please enter e-mail address";
                                  }else if (!value.contains('@') || !value.contains('.')) {
                                    _emailValid = false;
                                    return "Please enter a valid e-mail address";
                                  }else if (value.contains('@') && value.contains('.')) {
                                    final index = value.indexOf('@');
                                    final dotIndex = value.indexOf('.');
                                    final midWord = value.substring(index,dotIndex);
                                    final afterWord = value.substring(dotIndex);
                                    if(midWord.length == 1 || afterWord == 1) {
                                      _emailValid = false;
                                      return "Please enter a valid e-mail address";
                                    }
                                  }
                                },
                                onSaved: (value) {
                                  _authData['email'] = value;
                                },
                              ),
                            ),
                            Container(
                              height: _size.height * 0.13,
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                style: TextStyle(
                                  fontSize: (_size.height * 14) / ConstraintHelper.screenHeightCoe,
                                ),
                                cursorColor: Colors.black87,
                                decoration: InputDecoration(
                                    labelText: "Password",
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      size: _size.height * 25 / ConstraintHelper.screenHeightCoe,
                                      color: Colors.grey,
                                    ),
                                    labelStyle: TextStyle(
                                        fontSize: _size.height * 20 / ConstraintHelper.screenHeightCoe,
                                        color: Colors.black87
                                    ),
                                    isDense: true,
                                    contentPadding: _passwordValid ? EdgeInsets.symmetric(vertical: 2) : EdgeInsets.only(bottom: 2),
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
                                  if (value.isEmpty) {
                                    _passwordValid = false;
                                    return "Please enter password";
                                  } else if (value.length < 5) {
                                    _passwordValid = false;
                                    return "Password is too short";
                                  }
                                },
                                onSaved: (value) {
                                  _authData['password'] = value;
                                },
                              ),
                            ),
                            Container(
                              height: _size.height * 0.13,
                              child: TextFormField(
                                obscureText: true,
                                style: TextStyle(
                                  fontSize: _size.height * 14 / ConstraintHelper.screenHeightCoe,
                                ),
                                cursorColor: Colors.black87,
                                decoration: InputDecoration(
                                    labelText: "Confirm Password",
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      size: _size.height * 25 / ConstraintHelper.screenHeightCoe,
                                      color: Colors.grey,
                                    ),
                                    labelStyle: TextStyle(
                                        fontSize: _size.height * 20 / ConstraintHelper.screenHeightCoe,
                                        color: Colors.black87
                                    ),
                                    isDense: true,
                                    contentPadding: _passwordConfirmValid ? EdgeInsets.symmetric(vertical: 2) : EdgeInsets.only(bottom: 2),
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
                                      fontSize: _size.height * 14 / ConstraintHelper.screenHeightCoe,
                                    )
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    _passwordConfirmValid = false;
                                    return "Please enter password";
                                  } else if (value.length < 5) {
                                    _passwordConfirmValid = false;
                                    return "Password is too short";
                                  } else if (value != _passwordController.text) {
                                    _passwordConfirmValid = false;
                                    return "Passwords does not match";
                                  }
                                },
                                onSaved: (value) {
                                  _authData['password'] = value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: _size.height * 0.1,
                    alignment: Alignment.center,
                    child: ButtonTheme(
                      minWidth: _size.height * 250 / ConstraintHelper.screenHeightCoe,
                      height: _size.height * 40 / ConstraintHelper.screenHeightCoe,
                      child: RaisedButton(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: _size.height * 17 / ConstraintHelper.screenHeightCoe,
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
                  Container(
                    width: _size.width * 0.7,
                    height: _size.height * 0.2,
                    alignment: Alignment.center,
                      child: Container(
                          height: _size.height * 0.07,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have account?",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: _size.height * 15 / ConstraintHelper.screenHeightCoe
                                  ),
                                ),
                                ButtonTheme(
                                  minWidth: _size.height * 50 / ConstraintHelper.screenHeightCoe,
                                  height: _size.height * 30 / ConstraintHelper.screenHeightCoe,
                                  child: RaisedButton(
                                    child: Text(
                                      "LOGIN",
                                      style: TextStyle(
                                        fontSize: _size.height * 14 / ConstraintHelper.screenHeightCoe,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    color: Colors.black87,
                                    textColor: Colors.white70,
                                    splashColor: Colors.amber,
                                    onPressed: () {
                                      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                                    },
                                  ),
                                ),
                              ]
                          )
                      ),
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
      await _authProvider.signUpNewUser(_authData["email"].trim(), _authData["password"].trim());
      Navigator.of(context).pushReplacementNamed(ConnectAccountScreen.routeName);
    } on PlatformException catch (error) {
      var errorMassage = "Authentication Error";
      if (error.toString().contains("ERROR_EMAIL_ALREADY_IN_USE")) {
        errorMassage = "This email is already in use";
      } else if (error.toString().contains("ERROR_INVALID_EMAIL")) {
        errorMassage = "Invalid email address";
      } else if(error.toString().contains("ERROR_NETWORK_REQUEST_FAILED")) {
        errorMassage = "Check your internet connection and try again";
      }
      _showErrorDialog(errorMassage);
    } catch (error) {
      final errorMassage = "Authentication failed, please try again later";
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
          title: Text("Authentication Failed"),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.amber
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        )
        : CupertinoAlertDialog(
          title: Text("Authentication Failed"),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        )
    );
  }
}
