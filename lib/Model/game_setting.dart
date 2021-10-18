import 'package:flutter/material.dart';

class GameSetting with ChangeNotifier {
  final Map<CoolTimeType, int> _coolTimeSecs = {
    CoolTimeType.button: 10,
    CoolTimeType.kill: 10,
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
