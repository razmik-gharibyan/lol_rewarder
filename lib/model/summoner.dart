import 'package:lol_rewarder/model/active_challenge.dart';

class Summoner {

  static final Summoner _summoner = Summoner._privateConstructor();

  factory Summoner() {
    return _summoner;
  }

  Summoner._privateConstructor();

  String _puuid;
  String _accountId;
  String _name;
  String _serverTag;
  int _iconId;
  int _summonerLevel;
  ActiveChallenge _activeChallenge;
  List<dynamic> _rewardList;

  String get puuid => _puuid;
  String get accountId => _accountId;
  String get name => _name;
  String get serverTag => _serverTag;
  int get iconId => _iconId;
  int get summonerLevel => _summonerLevel;
  ActiveChallenge get activeChallenge => _activeChallenge;
  List<dynamic> get rewardList => _rewardList;

  void setPuuid(String newValue) {
    _puuid = newValue;
  }

  void setAccountId(String newValue) {
    _accountId = newValue;
  }

  void setName(String newValue) {
    _name = newValue;
  }

  void setServerTag(String newValue) {
    _serverTag = newValue;
  }

  void setIconId(int newValue) {
    _iconId = newValue;
  }

  void setSummonerLevel(int newValue) {
    _summonerLevel = newValue;
  }

  void setActiveChallenge(ActiveChallenge newValue) {
    _activeChallenge = newValue;
  }

  void setRewardList(List<dynamic> newValue) {
    _rewardList = newValue;
  }

}