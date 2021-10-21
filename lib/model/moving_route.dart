import 'dart:core';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';

class MovingRoute with ChangeNotifier {
  List<OneStroke> _routeList = <OneStroke>[];
  List<OneStroke> _undoList = <OneStroke>[];
  bool _isDragging = false;

  PlayerColor _selectingColor = PlayerColor.white;

  List<OneStroke> get routeList => _routeList;

  List<OneStroke> get undoList => _undoList;

  bool get isDragging => _isDragging;

  bool get canRedo => _undoList.isNotEmpty;

  bool get canUndo => _routeList.isNotEmpty;

  set selectingColor(PlayerColor value) {
    _selectingColor = value;
  }

  void undo() {
    if (isDragging || !canUndo) {
      return;
    }
    // _routeListの最後を_undoListへ移動
    final _last = _routeList.last;
    _undoList.add(_last);
    _routeList.removeLast();
    notifyListeners();
  }

  void redo() {
    if (isDragging || !canRedo) {
      return;
    }
    // _undoListの最後を取って、_routeListに追加する
    final _last = _undoList.last;
    _undoList.removeLast();
    _routeList.add(_last);
    notifyListeners();
  }

  void clear(bool keepUndo) {
    if (!isDragging) {
      // 間違えた場合に戻せるようにundoに残す
      _undoList = keepUndo ? List.of(_routeList.reversed) : [];
      _routeList = [];
      notifyListeners();
    }
  }

  void addPaint(Offset startPoint) {
    if (!isDragging) {
      _isDragging = true;
      _undoList = []; // redoできないようにする
      _routeList.add(OneStroke([startPoint], _selectingColor)); // 新たに開始地点を追加
      notifyListeners();
    }
  }

  void updatePaint(Offset nextPoint) {
    if (isDragging) {
      // 最終位置として追加
      final route =
          _routeList.lastOrNull ?? OneStroke(<Offset>[], _selectingColor);
      route.addOffset(nextPoint);
      if (_routeList.isEmpty) {
        _routeList.add(route);
      } else {
        _routeList.last = route;
      }
      notifyListeners();
    }
  }

  void endPaint() {
    _isDragging = false;
    notifyListeners();
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
