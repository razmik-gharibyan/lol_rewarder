import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lol_rewarder/model/active_challenge.dart';
import 'package:lol_rewarder/model/challenge.dart';
import 'package:lol_rewarder/model/skin.dart';
import 'package:lol_rewarder/model/summoner.dart';
import 'package:lol_rewarder/model/user.dart';
import 'package:lol_rewarder/providers/challenge_provider.dart';

class BackendProvider {

  static final BackendProvider _backendProvider = BackendProvider.privateConstructor();

  factory BackendProvider() {
    return _backendProvider;
  }

  BackendProvider.privateConstructor();

  // Constants
  final String _summonerCollection = "summoners";
  final String _rewardsCollection = "rewards";
  final String _allRewardsCollection = "all-rewards";
  final String _thisMonthRewardsDocument = "month-rewards";
  // Singletons
  Summoner _summoner = Summoner();
  Challenge _challenge = Challenge();
  User _user = User();
  // Tools
  final Firestore _firestore = Firestore.instance;
  final _challengeProvider = ChallengeProvider();

  Future<void> addSummoner() async {
    String userUID = _user.uid;
    await _firestore.collection(_summonerCollection).document(userUID).setData(_convertSummonerToMap());
  }

  Future<void> updateSummoner() async {
    String userUID = _user.uid;
    await _firestore.collection(_summonerCollection).document(userUID).updateData(_convertSummonerToMap());
  }

  Future<void> checkIfSummonerConnectedAndGetData() async {
    String userUID = _user.uid;
    final DocumentSnapshot result = await _firestore.collection(_summonerCollection).document(userUID).get();
    if(result.exists) {
      // If connected summoner account exists, then write its data into Summoner singleton
      _convertMapToSummoner(result.data);
    }else{
      throw Exception("Summoner not found");
    }
  }

  Future<QuerySnapshot> checkIfSummonerExists(String summonerName,String serverTag) async {
    return await _firestore.collection(_summonerCollection)
        .where("name", isEqualTo: summonerName)
        .where("serverTag", isEqualTo: serverTag)
        .getDocuments();
  }
  
  Future<List<DocumentSnapshot>> getChallengeListByType(String type) async {
    final result = await _firestore.collection("$type-challenges").getDocuments();
    List<DocumentSnapshot> challengeList = List<DocumentSnapshot>();
    if(result.documents.isNotEmpty) {
      for(var document in result.documents) {
        challengeList.add(document);
      }
      return challengeList;
    }
    return challengeList;
  }

  Future<void> getChallengeDocumentById(ActiveChallenge activeChallenge) async {
    // Get challenge document by it's ID
    final result = await _firestore.collection("${activeChallenge.activeChallengeType}-challenges")
        .document(activeChallenge.activeChallengeId)
        .get();
    // Update and rewrite active challenge data
    _challenge.setType(activeChallenge.activeChallengeType);
    _challenge.setData(result);
    await _challengeProvider.getChallengeData(result);
  }

  Future<void> addSkinToDatabase(String skinName) async {
    final DocumentReference result = await _firestore.collection(_rewardsCollection).add(_convertSkinDataToMap(skinName));
    if(result == null) {
      throw Exception("Skin was not added");
    }
  }

  Future<void> addRewardToSummonerRewardList(Skin skin,String champion) async {
    await checkIfSummonerConnectedAndGetData();
    List<dynamic> rewardList = _summoner.rewardList;
    if(rewardList == null) {
      rewardList = List<dynamic>();
      rewardList.add(_convertSkinToMap(skin,champion));
    }else{
      rewardList.add(_convertSkinToMap(skin,champion));
    }
    _summoner.setRewardList(rewardList);
    updateSummoner();
  }

  Future<List<dynamic>> getThisMonthAllRewards() async {
    final DocumentSnapshot result = await _firestore.collection(_allRewardsCollection).document(_thisMonthRewardsDocument).get();
    return result.data["rewardList"];
  }

  Future<void> updateAllRewards(Map<String,dynamic> map) async {
    await _firestore.collection(_allRewardsCollection).document(_thisMonthRewardsDocument).updateData(map);
  }

  Map<String,dynamic> _convertSummonerToMap() {
    Map<String,dynamic> resultMap = {
      "puuid": _summoner.puuid,
      "accountId": _summoner.accountId,
      "name": _summoner.name,
      "serverTag": _summoner.serverTag,
      "iconId": _summoner.iconId,
      "summonerLevel": _summoner.summonerLevel,
      "activeChallenge": _convertActiveChallengeToMap(_summoner.activeChallenge),
      "rewardList": _summoner.rewardList
    };
    return resultMap;
  }

  void _convertMapToSummoner(Map<String,dynamic> data) {
    _summoner.setPuuid(data["puuid"]);
    _summoner.setAccountId(data["accountId"]);
    _summoner.setName(data["name"]);
    _summoner.setServerTag(data["serverTag"]);
    _summoner.setIconId(data["iconId"]);
    _summoner.setSummonerLevel(data["summonerLevel"]);
    _summoner.setActiveChallenge(_convertActiveChallengeMapToActiveChallenge(data["activeChallenge"]));
    _summoner.setRewardList(data["rewardList"]);
  }

  Map<String,dynamic> _convertActiveChallengeToMap(ActiveChallenge activeChallenge) {
    Map<String, dynamic> resultMap;
    if(activeChallenge != null) {
       resultMap = {
        "activeChallengeId": activeChallenge.activeChallengeId,
        "activeChallengeType": activeChallenge.activeChallengeType,
        "activeChallengeTimestamp": activeChallenge.activeChallengeTimestamp
      };
    }
    return resultMap;
  }

  ActiveChallenge _convertActiveChallengeMapToActiveChallenge(Map<String,dynamic> activeChallengeMap) {
    if(activeChallengeMap != null) {
      return ActiveChallenge(
          activeChallengeMap["activeChallengeId"],
          activeChallengeMap["activeChallengeType"],
          activeChallengeMap["activeChallengeTimestamp"]
      );
    }
    return null;
  }

  Map<String,dynamic> _convertSkinDataToMap(String skinName) {
    return {
      "skinName": skinName,
      "summonerName": _summoner.name,
      "serverTag": _summoner.serverTag.toUpperCase()
    };
  }

  Map<String,dynamic> _convertSkinToMap(Skin skin, String champion) {
    return {
      "name": skin.name,
      "num": skin.num,
      "champion": champion
    };
  }

}