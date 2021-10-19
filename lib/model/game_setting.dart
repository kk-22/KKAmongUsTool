import 'package:flutter/material.dart';

class GameSetting with ChangeNotifier {
  final Map<CoolTimeType, int> _coolTimeSecs = {
    CoolTimeType.button: 15,
    CoolTimeType.kill: 30,
  };

  int coolTimeSec(CoolTimeType type) {
    return _coolTimeSecs[type] ?? -1;
  }

  void updateCoolTimeSec(CoolTimeType type, int value) {
    _coolTimeSecs[type] = value;
    notifyListeners();
  }
}

enum CoolTimeType {
  button,
  kill,
}
