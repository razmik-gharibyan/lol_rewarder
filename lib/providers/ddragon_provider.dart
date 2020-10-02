import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lol_rewarder/model/skin.dart';

class DDragonProvider {

  static final DDragonProvider _dDragonProvider = DDragonProvider.privateConstructor();

  factory DDragonProvider() {
    return _dDragonProvider;
  }

  DDragonProvider.privateConstructor();

  String gameVersion = "10.19.1";

  Future<void> updateGameVersion() async {
    final result = await http.get("https://ddragon.leagueoflegends.com/api/versions.json",
      headers: {
        "Content-Type": "application/json",
      },
    );
    if(result.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(result.body);
      gameVersion = jsonResponse.first;
    }
  }

  Future<List<Skin>> getSkinListForChampion(String championName) async {
    final result = await http.get("http://ddragon.leagueoflegends.com/cdn/$gameVersion/data/en_US/champion/$championName.json",
      headers: {
        "Content-Type": "application/json",
      },
    );
    List<Skin> skinList = List<Skin>();
    if(result.statusCode == 200) {
      Map<String,dynamic> jsonResponse = json.decode(result.body);
      List<dynamic> skinListRaw = jsonResponse["data"]["$championName"]["skins"];
      for(var skin in skinListRaw) {
        if(skin["num"] != 0) {
          skinList.add(Skin(skin["name"], skin["num"]));
        }
      }
    }
    return skinList;
  }

}