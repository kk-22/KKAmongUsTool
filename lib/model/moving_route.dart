import 'dart:core';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/model/round.dart';

class MovingRoute with ChangeNotifier {
  final Round _round;
  final _roundRoutes = List<RoundRoute>.generate(10, (index) => RoundRoute());
  bool _isDragging = false;

  PlayerColor _selectingColor = PlayerColor.white;

  MovingRoute(this._round);

  List<OneStroke> get roundStrokes => _currentRoundRoute.strokes;

  bool get isDragging => _isDragging;

  bool get canRedo => _currentRoundRoute.undoStrokes.isNotEmpty;

  bool get canUndo => _currentRoundRoute.strokes.isNotEmpty;

  RoundRoute get _currentRoundRoute => _roundRoutes[_round.currentRound];

  set selectingColor(PlayerColor value) {
    _selectingColor = value;
  }

  void undo() {
    if (isDragging || !canUndo) {
      return;
    }
    // _strokes の最後を _undoStrokes へ移動
    final _last = _currentRoundRoute.strokes.last;
    _currentRoundRoute.undoStrokes.add(_last);
    _currentRoundRoute.strokes.removeLast();
    notifyListeners();
  }

  void redo() {
    if (isDragging || !canRedo) {
      return;
    }
    // _undoStrokes の最後を取って、 _strokes に追加する
    final _last = _currentRoundRoute.undoStrokes.last;
    _currentRoundRoute.undoStrokes.removeLast();
    _currentRoundRoute.strokes.add(_last);
    notifyListeners();
  }

  void clear(bool allRound) {
    if (isDragging) {
      return;
    }
    if (allRound) {
      for (var element in _roundRoutes) {
        element.clear();
      }
    } else {
      // 現在のラウンドだけ削除。間違えた場合に戻せるようにundoに残す
      _currentRoundRoute.undoStrokes.clear();
      _currentRoundRoute.undoStrokes
          .addAll(_currentRoundRoute.strokes.reversed);
      _currentRoundRoute.strokes.clear();
    }
    notifyListeners();
  }

  void addPaint(Offset startPoint) {
    if (!isDragging) {
      _isDragging = true;
      _currentRoundRoute.strokes
          .add(OneStroke([startPoint], _selectingColor)); // 新たに開始地点を追加
      notifyListeners();
    }
  }

  void updatePaint(Offset nextPoint) {
    if (isDragging) {
      // 最終位置として追加
      final stroke = _currentRoundRoute.strokes.lastOrNull ??
          OneStroke(<Offset>[], _selectingColor);
      stroke.addOffset(nextPoint);
      if (_currentRoundRoute.strokes.isEmpty) {
        _currentRoundRoute.strokes.add(stroke);
      } else {
        _currentRoundRoute.strokes.last = stroke;
      }
      notifyListeners();
    }
  }

  void endPaint() {
    _isDragging = false;
    if (_currentRoundRoute.strokes.last.offsets.length == 1) {
      // 1点のタップのみなら、経路を無かった事にする
      _currentRoundRoute.strokes.removeLast();
    } else {
      _currentRoundRoute.undoStrokes.clear(); // redoできないようにする
    }
    notifyListeners();
  }
}

// ラウンド内での移動経路
class RoundRoute {
  final strokes = <OneStroke>[];
  final undoStrokes = <OneStroke>[];

  void clear() {
    strokes.clear();
    undoStrokes.clear();
  }
}

// 一筆書きの座標と色
class OneStroke {
  final List<Offset> offsets;
  final PlayerColor color;

  OneStroke(this.offsets, this.color);

  void addOffset(Offset offset) {
    offsets.add(offset);
  }
}
