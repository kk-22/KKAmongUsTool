import 'dart:core';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class MovingRoute with ChangeNotifier {
  List<List<Offset>> _undoList = <List<Offset>>[];
  List<List<Offset>> _paintList = <List<Offset>>[];
  bool _isDragging = false;

  List<List<Offset>> get undoList => _undoList;

  List<List<Offset>> get paintList => _paintList;

  bool get isDragging => _isDragging;

  bool get canRedo => _undoList.isNotEmpty;

  bool get canUndo => _paintList.isNotEmpty;

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
    final _last = paintList.last;
    _undoList = List.of(undoList)..removeLast();
    _paintList = List.of(paintList)..add(_last);
    notifyListeners();
  }

  void clear() {
    if (!isDragging) {
      _undoList = [];
      _paintList = [];
      notifyListeners();
    }
  }

  void addPaint(Offset startPoint) {
    if (!isDragging) {
      _isDragging = true;
      _undoList = []; // redoできないようにする
      _paintList = List.of(paintList)..add([startPoint]); // 新たに開始地点を追加
      notifyListeners();
    }
  }

  void updatePaint(Offset nextPoint) {
    if (isDragging) {
      // 最終位置として追加
      final paintList = List<List<Offset>>.of(_paintList);
      final offsetList = List<Offset>.of(_paintList.lastOrNull ?? <Offset>[])
        ..add(nextPoint);
      if (paintList.isEmpty) {
        paintList.add(offsetList);
      } else {
        paintList.last = offsetList;
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
