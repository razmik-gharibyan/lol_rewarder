import 'package:sqflite/sqflite.dart';

const String path = "lol_rewarder.db";
const String table = "games";
const String columnId = "_id";
const String columnGameId ="gameId";
const String columnTowerKills ="towerKills";
const String columnGameDuration = "gameDuration";
const String columnChampion = "champion";
const String columnKills = "kills";
const String columnAssists = "assists";

class GameHelper {

  int id;
  int gameId;
  int towerKills;
  int gameDuration;
  String champion;
  int kills;
  int assists;

  GameHelper({this.gameId,this.towerKills,this.gameDuration,this.champion,this.kills,this.assists});

  Map<String,dynamic> toMap() {
    var map = <String,dynamic> {
      columnGameId: gameId,
      columnTowerKills: towerKills,
      columnGameDuration: gameDuration,
      columnChampion: champion,
      columnKills: kills,
      columnAssists: assists
    };
    if(id != null) {
      map[columnId] = id;
    }
    return map;
  }

  GameHelper.fromMap(Map<String,dynamic> map) {
    id = map[columnId];
    gameId = map[columnGameId];
    towerKills = map[columnTowerKills];
    gameDuration = map[columnGameDuration];
    champion = map[columnChampion];
    kills = map[columnKills];
    assists = map[columnAssists];
  }

}

class DBHelperProvider {

  static final DBHelperProvider _dbHelperProvider = DBHelperProvider.privateConstructor();
  factory DBHelperProvider() {
    return _dbHelperProvider;
  }
  DBHelperProvider.privateConstructor();

  Database db;

  void open() async {
    db = await openDatabase(path,version: 1,
        onCreate: (Database db,int version) async {
          await db.execute('''
            create table $table (
            $columnId integer primary key autoincrement,
            $columnGameId integer not null,
            $columnTowerKills integer not null,
            $columnGameDuration integer not null,
            $columnChampion text not null,
            $columnKills integer not null,
            $columnAssists integer not null)
          ''');
        });
  }

  Future<GameHelper> insertData(GameHelper helper) async {
    helper.id = await db.insert(table, helper.toMap());
    return helper;
  }
  
  Future<void> insertDataIfDontExists(GameHelper helper) async {
    db.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO $table($columnGameId, $columnTowerKills, $columnGameDuration, $columnChampion, $columnKills, $columnAssists) '
          'SELECT * FROM (SELECT ${helper.gameId}, ${helper.towerKills}, ${helper.gameDuration}, "${helper.champion}", ${helper.kills}, ${helper.assists}) AS "values"'
          //'VALUES(${helper.gameId}, ${helper.towerKills}, ${helper.gameDuration}, "${helper.champion}", ${helper.kills}, ${helper.assists})'
          'WHERE NOT EXISTS(SELECT ${helper.gameId} FROM $table WHERE $columnGameId=${helper.gameId})'
      );
    });
  }

  Future<List<GameHelper>> getGames() async {
    List<Map> mapList = await db.query(table,
      columns: [columnId,columnTowerKills,columnGameDuration,columnChampion,columnKills,columnAssists]
    );
    if(mapList.isNotEmpty) {
      return mapList.map((e) => GameHelper.fromMap(e)).toList();
    }
    return Future.value(List<GameHelper>());
  }

  Future<int> deleteGames() async {
    return await db.delete(table);
  }

  Future<int> updateGame(GameHelper helper) async {
    return await db.update(table, helper.toMap(),where: "$columnId = ?",whereArgs: [helper.id]);
  }

  void close() async => db.close();

}