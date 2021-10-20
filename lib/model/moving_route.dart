import 'dart:core';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';

class MovingRoute with ChangeNotifier {
  List<Route> _undoList = <Route>[];
  List<Route> _paintList = <Route>[];
  bool _isDragging = false;

  PlayerColor _selectingColor = PlayerColor.white;

  List<Route> get undoList => _undoList;

  List<Route> get paintList => _paintList;

  bool get isDragging => _isDragging;

  bool get canRedo => _undoList.isNotEmpty;

  bool get canUndo => _paintList.isNotEmpty;

  set selectingColor(PlayerColor value) {
    _selectingColor = value;
  }

  void undo() {
    if (isDragging || !canUndo) {
      return;
    }
    // paintListの最後をundoListへ移動
    final _last = paintList.last;
    _undoList = List.of(undoList)..add(_last);
    _paintList = List.of(paintList)..removeLast();
    notifyListeners();
  }

  void redo() {
    if (isDragging || !canRedo) {
      return;
    }
    // undoListの最後を取って、paintListに追加する
    final _last = _undoList.last;
    _undoList = List.of(undoList)..removeLast();
    _paintList = List.of(paintList)..add(_last);
    notifyListeners();
  }

  void clear() {
    if (!isDragging) {
      // 間違えた場合に戻せるようにundoに残す
      _undoList = List.of(paintList.reversed);
      _paintList = [];
      notifyListeners();
    }
  }

  void addPaint(Offset startPoint) {
    if (!isDragging) {
      _isDragging = true;
      _undoList = []; // redoできないようにする
      _paintList = List.of(paintList)
        ..add(Route([startPoint], _selectingColor)); // 新たに開始地点を追加
      notifyListeners();
    }
  }

  void updatePaint(Offset nextPoint) {
    if (isDragging) {
      // 最終位置として追加
      final paintList = List<Route>.of(_paintList);
      final route = _paintList.lastOrNull ?? Route(<Offset>[], _selectingColor);
      route.addOffset(nextPoint);
      if (paintList.isEmpty) {
        paintList.add(route);
      } else {
        paintList.last = route;
      }
      _paintList = paintList;
      notifyListeners();
    }
  }

  void endPaint() {
    _isDragging = false;
    notifyListeners();
  }
}

class Route {
  final List<Offset> offsets;
  final PlayerColor color;

  Route(this.offsets, this.color);

  void addOffset(Offset offset) {
    offsets.add(offset);
  }
}
