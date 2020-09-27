import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackendProvider {

  static final BackendProvider _backendProvider = BackendProvider.privateConstructor();

  factory BackendProvider() {
    return _backendProvider;
  }

  BackendProvider.privateConstructor();

  // Constants
  final String _summonerCollection = "summoners";
  // Singletons
  Summoner _summoner = Summoner();
  User _user = User();
  // Tools
  final Firestore _firestore = Firestore.instance;

  Future<void> addSummoner() async {
    String userUID = _user.uid;
    await _firestore.collection(_summonerCollection).document(userUID).setData(_convertSummonerToMap());
  }

  Future<void> checkIfSummonerConnected() async {
    String userUID = _user.uid;
    final DocumentSnapshot result = await _firestore.collection(_summonerCollection).document(userUID).get();
    if(!result.exists) {
      throw Exception("Summoner not found");
    }
  }

  Future<QuerySnapshot> checkIfSummonerExists(String summonerName) async {
    return await _firestore.collection(_summonerCollection)
        .where("name", isEqualTo: summonerName)
        .getDocuments();
  }

  Map<String,dynamic> _convertSummonerToMap() {
    Map<String,dynamic> resultMap = {
      "puuid": _summoner.puuid,
      "accountId": _summoner.accountId,
      "name": _summoner.name,
      "serverTag": _summoner.serverTag,
      "iconId": _summoner.iconId,
      "summonerLevel": _summoner.summonerLevel
    };
    return resultMap;
  }

}