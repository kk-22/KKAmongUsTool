import 'dart:async';

import 'package:flutter/material.dart';

class TimerViewModel with ChangeNotifier {
  static const _startSec = -5;
  static const _minInterval = 20; // 下回ったら前回の秒数に戻す
  int _elapsedSec = _startSec;
  int _prevElapsedSec = 0;
  Timer? _timer;

  int get elapsedSec => _elapsedSec;

  void didShrinkApp() {
    _startTimerIfNeeded();
  }

  void didExpandApp() {
    _stopTimerIfNeeded();
    if (_elapsedSec < _minInterval) {
      _updateSec(_prevElapsedSec);
    }
  }

  void _startTimerIfNeeded() {
    if (_timer != null) return;

    _prevElapsedSec = _elapsedSec;
    _updateSec(_startSec);

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        _updateSec(_elapsedSec + 1);
      },
    );
  }

  void _stopTimerIfNeeded() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      _timer = null;
    }
  }

  void _updateSec(int value) {
    _elapsedSec = value;
    notifyListeners();
  }
}
