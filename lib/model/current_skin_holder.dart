import 'package:lol_rewarder/model/skin.dart';

class CurrentSkinHolder {

  static final CurrentSkinHolder _currentSkinHolder = CurrentSkinHolder._privateConstructor();

  factory CurrentSkinHolder() {
    return _currentSkinHolder;
  }

  CurrentSkinHolder._privateConstructor();

  String _championName;
  List<Skin> _skinList;
  String _currentSkinName;

  String get championName => _championName;
  List<Skin> get skinList => _skinList;
  String get currentSkinName => _currentSkinName;

  void setChampionName(String newValue) {
    _championName = newValue;
  }

  void setSkinList(List<Skin> newValue) {
    _skinList = newValue;
  }

  void setCurrentSkinName(String newValue) {
    _currentSkinName = newValue;
  }

  void clear() {
    _championName = null;
    _skinList = null;
    _currentSkinName = null;
  }

}