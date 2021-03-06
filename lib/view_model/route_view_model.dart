import 'dart:core';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/model/route.dart';
import 'package:kk_amongus_tool/view_model/round_view_model.dart';

class RouteViewModel with ChangeNotifier {
  final RoundViewModel _roundModel;
  final _roundRoutes = List<RoundRoute>.generate(
      RoundViewModel.maxRound, (index) => RoundRoute());
  bool _isDragging = false;

  PlayerColor _selectingColor = PlayerColor.white;

  RouteViewModel(this._roundModel);

  List<OneStroke> get roundStrokes => _currentRoundRoute.strokes;

  bool get isDragging => _isDragging;

  bool get canRedo => _currentRoundRoute.undoStrokes.isNotEmpty;

  bool get canUndo => _currentRoundRoute.strokes.isNotEmpty;

  RoundRoute get _currentRoundRoute => _roundRoutes[_roundModel.currentRound];

  set selectingColor(PlayerColor value) {
    _selectingColor = value;
  }

  void undo() {
    if (isDragging || !canUndo) {
      return;
    }
    if (clearOfColor(false)) {
      // 選択中の色が描画されていればそれを削除
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

  // 現在のラウンドから選択中の色を削除
  bool clearOfColor(bool isAll) {
    if (isAll) {
      _currentRoundRoute.undoStrokes.clear();
    }
    int clearCount = 0;
    for (var i = _currentRoundRoute.strokes.length - 1; 0 <= i; i--) {
      final stroke = _currentRoundRoute.strokes[i];
      if (stroke.color == _selectingColor) {
        clearCount++;
        _currentRoundRoute.strokes.remove(stroke);
        // 間違えた場合に進むボタンで復元できるようにundoに残す
        _currentRoundRoute.undoStrokes.add(stroke);
        if (!isAll) {
          break;
        }
      }
    }
    if (0 < clearCount) {
      notifyListeners();
      return true;
    }
    return false;
  }

  void clear() {
    if (isDragging) {
      return;
    }
    for (var element in _roundRoutes) {
      element.clear();
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
