class Summoner {

  static final Summoner _summoner = Summoner._privateConstructor();

  factory Summoner() {
    return _summoner;
  }

  String puuid;
  String accountId;

  Summoner._privateConstructor() {
    this.puuid = null;
    this.accountId = null;
  }

}