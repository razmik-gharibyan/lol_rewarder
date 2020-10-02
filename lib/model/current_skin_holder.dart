import 'package:lol_rewarder/model/skin.dart';

class CurrentSkinHolder {

  static final CurrentSkinHolder _currentSkinHolder = CurrentSkinHolder._privateConstructor();

  factory CurrentSkinHolder() {
    return _currentSkinHolder;
  }

  CurrentSkinHolder._privateConstructor();

  String _championName;
  List<Skin> _skinList;

  String get championName => _championName;
  List<Skin> get skinList => _skinList;

  void setChampionName(String newValue) {
    _championName = newValue;
  }

  void setSkinList(List<Skin> newValue) {
    _skinList = newValue;
  }

}