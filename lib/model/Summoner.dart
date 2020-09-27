class Summoner {

  static final Summoner _summoner = Summoner._privateConstructor();

  factory Summoner() {
    return _summoner;
  }

  String puuid;
  String accountId;
  String name;
  String serverTag;
  int summonerLevel;

  Summoner._privateConstructor() {
    this.puuid = null;
    this.accountId = null;
    this.name = null;
    this.summonerLevel = null;
  }

}