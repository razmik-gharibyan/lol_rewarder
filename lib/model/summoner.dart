class Summoner {

  static final Summoner _summoner = Summoner._privateConstructor();

  factory Summoner() {
    return _summoner;
  }

  String _puuid;
  String _accountId;
  String _name;
  String _serverTag;
  int _iconId;
  int _summonerLevel;

  String get puuid => _puuid;
  String get accountId => _accountId;
  String get name => _name;
  String get serverTag => _serverTag;
  int get iconId => _iconId;
  int get summonerLevel => _summonerLevel;

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

  Summoner._privateConstructor();

}