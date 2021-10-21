import 'dart:core';

import 'package:flutter/material.dart';

class RoundViewModel with ChangeNotifier {
  static const int maxRound = 15;

  int _currentRound = 0; // 表示中のラウンド
  int _lastRound = 0;

  int get currentRound => _currentRound;

  int get lastRound => _lastRound; // 最終ラウンド

  void changeRound(int index) {
    _currentRound = index;
    notifyListeners();
  }

  void updateLastRoundIfNeeded() {
    if (_lastRound < _currentRound) {
      _lastRound = _currentRound;
    }
  }
}
