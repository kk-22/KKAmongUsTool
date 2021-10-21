import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/view/dialog/map_selector.dart';

class GameSetting with ChangeNotifier {
  final Map<CoolTimeType, int> _coolTimeSecs = {
    CoolTimeType.button: 15,
    CoolTimeType.kill: 30,
  };
  String mapPath = MapSelector.defaultMapPath;

  int coolTimeSec(CoolTimeType type) {
    return _coolTimeSecs[type] ?? -1;
  }

  void updateCoolTimeSec(CoolTimeType type, int value) {
    _coolTimeSecs[type] = value;
    notifyListeners();
  }

  void changeMap(String path) {
    mapPath = path;
    notifyListeners();
  }
}

enum CoolTimeType {
  button,
  kill,
}
