class MatchMain {

  final Map<String,dynamic> jsonResponse;
  final Map<String,dynamic> stats;
  final int gameDuration;
  final int queueId;
  final int teamId;
  final String champion;
  final int towerKills;
  final String win;

  MatchMain(
      this.jsonResponse,
      this.stats,
      this.gameDuration,
      this.queueId,
      this.teamId,
      this.champion,
      this.towerKills,
      this.win);

}