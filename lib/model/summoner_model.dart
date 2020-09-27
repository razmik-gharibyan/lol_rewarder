class SummonerModel {

  String puuid;
  String accountId;
  String name;
  String serverTag;
  int iconId;
  int summonerLevel;

  @override
  bool operator ==(Object other) {
    if(other is SummonerModel &&
        puuid == other.puuid &&
        accountId == other.accountId &&
        name == other.name &&
        serverTag == other.serverTag &&
        iconId == other.iconId &&
        summonerLevel == other.summonerLevel) {
      return true;
    }else{
      return false;
    }
  }

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + puuid.hashCode;
    result = 37 * result + accountId.hashCode;
    result = 37 * result + name.hashCode;
    result = 37 * result + serverTag.hashCode;
    result = 37 * result + iconId.hashCode;
    result = 37 * result + summonerLevel.hashCode;
    return result;
  }

}