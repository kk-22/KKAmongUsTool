import 'dart:core';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';

class MovingRoute with ChangeNotifier {
  final List<OneStroke> _strokes = <OneStroke>[];
  final List<OneStroke> _undoStrokes = <OneStroke>[];
  bool _isDragging = false;

  PlayerColor _selectingColor = PlayerColor.white;

  List<OneStroke> get strokes => _strokes;

  List<OneStroke> get undoStrokes => _undoStrokes;

  bool get isDragging => _isDragging;

  bool get canRedo => _undoStrokes.isNotEmpty;

  bool get canUndo => _strokes.isNotEmpty;

  set selectingColor(PlayerColor value) {
    _selectingColor = value;
  }

  void undo() {
    if (isDragging || !canUndo) {
      return;
    }
    // _strokes の最後を _undoStrokes へ移動
    final _last = _strokes.last;
    _undoStrokes.add(_last);
    _strokes.removeLast();
    notifyListeners();
  }

  void redo() {
    if (isDragging || !canRedo) {
      return;
    }
    // _undoStrokes の最後を取って、 _strokes に追加する
    final _last = _undoStrokes.last;
    _undoStrokes.removeLast();
    _strokes.add(_last);
    notifyListeners();
  }

  void clear(bool keepUndo) {
    if (!isDragging) {
      // 間違えた場合に戻せるようにundoに残す
      _undoStrokes.clear();
      if (keepUndo) _undoStrokes.addAll(_strokes.reversed);
      _strokes.clear();
      notifyListeners();
    }
  }

  void addPaint(Offset startPoint) {
    if (!isDragging) {
      _isDragging = true;
      _undoStrokes.clear(); // redoできないようにする
      _strokes.add(OneStroke([startPoint], _selectingColor)); // 新たに開始地点を追加
      notifyListeners();
    }
  }

  void updatePaint(Offset nextPoint) {
    if (isDragging) {
      // 最終位置として追加
      final stroke =
          _strokes.lastOrNull ?? OneStroke(<Offset>[], _selectingColor);
      stroke.addOffset(nextPoint);
      if (_strokes.isEmpty) {
        _strokes.add(stroke);
      } else {
        _strokes.last = stroke;
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
