import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/view_model/round_view_model.dart';

class TimerViewModel with ChangeNotifier {
  static const _startSec = -10;
  static const _minInterval = 15; // 下回ったら前回の秒数に戻す
  final RoundViewModel _roundModel;
  int _elapsedSec = _startSec;
  int _prevElapsedSec = 0;
  Timer? _timer;
  final List<String> _elapsedLogs = [];

  TimerViewModel(this._roundModel);

  int get elapsedSec => _elapsedSec;

  List<String> get elapsedLogs => _elapsedLogs;

  void didShrinkApp() {
    _startTimerIfNeeded();
  }

  void didExpandApp() {
    _stopTimerIfNeeded();
    if (_elapsedSec < _minInterval) {
      _updateSec(_prevElapsedSec);
    }
  }

  void addSec(int sec) {
    _updateSec(_elapsedSec + sec);
    // 操作直後にタイマーで値が変わると違和感があるため再設定する
    _timer?.cancel();
    _fireTimer();
  }

  void resetTimer() {
    _elapsedLogs.clear();
    _updateSec(0);
  }

  bool isActiveTimer() {
    return _timer != null && _timer!.isActive;
  }

  void _startTimerIfNeeded() {
    if (_timer != null) return;

    _prevElapsedSec = _elapsedSec;
    _updateSec(_startSec);

    _fireTimer();
  }

  void _fireTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (Timer timer) {
        _updateSec(_elapsedSec + 1);
      },
    );
  }

  void _stopTimerIfNeeded() {
    if (isActiveTimer()) {
      _timer?.cancel();
      _timer = null;

      _elapsedLogs.add("${_roundModel.lastRound + 2} : $_elapsedSec秒");
    }
  }

  void _updateSec(int value) {
    _elapsedSec = value;
    notifyListeners();
  }
}
