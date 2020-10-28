import 'package:sqflite/sqflite.dart';

const String table = "games";
const String columnId = "_id";
const String columnTowerKills ="towerKills";
const String columnGameDuration = "gameDuration";
const String columnChampion = "champion";
const String columnKills = "kills";
const String columnAssists = "assists";

class GameHelper {

  int id;
  int towerKills;
  int gameDuration;
  String champion;
  int kills;
  int assists;

  GameHelper();

  Map<String,dynamic> toMap() {
    var map = <String,dynamic> {
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
    towerKills = map[columnTowerKills];
    gameDuration = map[columnGameDuration];
    champion = map[columnChampion];
    kills = map[columnKills];
    assists = map[columnAssists];
  }

}

class DBHelperProvider {

  Database db;

  Future open(String path) async {
    db = await openDatabase(path,version: 1,
        onCreate: (Database db,int version) async {
          await db.execute('''
            create table $table (
            $columnId integer primary key autoincrement,
            $columnTowerKills integer not null,
            $columnGameDuration integer not null,
            $columnChampion text not null,
            $columnKills integer not null,
            $columnAssists integer not null)
          ''');
        });
  }

  Future<GameHelper> insertData(GameHelper dbHelper) async {
    dbHelper.id = await db.insert(table, dbHelper.toMap());
    return dbHelper;
  }

  Future<List<GameHelper>> getGames() async {
    List<Map> mapList = await db.query(table,
      columns: [columnId,columnTowerKills,columnGameDuration,columnChampion,columnKills,columnAssists]
    );
    if(mapList.isNotEmpty) {
      return mapList.map((e) => GameHelper.fromMap(e)).toList();
    }
    return null;
  }

  Future<int> deleteGames() async {
    return await db.delete(table);
  }

  Future<int> updateGame(GameHelper helper) async {
    return await db.update(table, helper.toMap(),where: "$columnId = ?",whereArgs: [helper.id]);
  }

  Future close() async => db.close();

}