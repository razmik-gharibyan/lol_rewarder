class MatchMain {

  final Map<String,dynamic> jsonResponse;
  final Map<String,dynamic> stats;
  final int gameDuration;
  final int teamId;
  final String champion;
  final int towerKills;
  final String win;

  MatchMain(this.jsonResponse,this.stats,this.gameDuration,this.teamId,this.champion,this.towerKills,this.win);

}