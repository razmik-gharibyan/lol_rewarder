import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {

  static final AuthProvider _authProvider = AuthProvider.privateConstructor();

  factory AuthProvider() {
    return _authProvider;
  }

  AuthProvider.privateConstructor();

  // Tools
  final _auth = FirebaseAuth.instance;
  SharedPreferences _sharedPreferences;
  // Vars
  final String _USER_UID = "user_uid";

  Future<void> signUpNewUser(String email,String password) async {
    final AuthResult authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    // Write firebase user uid into sharedPreferences.
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString(_USER_UID, authResult.user.uid);
  }

  Future<void> logInUser(String email,String password) async {
    final AuthResult authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
    // Write firebase user uid into sharedPreferences.
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString(_USER_UID, authResult.user.uid);
  }

}