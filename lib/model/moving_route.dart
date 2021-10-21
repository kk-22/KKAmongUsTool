import 'dart:core';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';

class MovingRoute with ChangeNotifier {
  final _rounds = List.filled(Player.maxRound, RoundRoute());
  bool _isDragging = false;

  final int showingRound = 0;

  PlayerColor _selectingColor = PlayerColor.white;

  List<OneStroke> get roundStrokes => _rounds[showingRound].strokes;

  bool get isDragging => _isDragging;

  bool get canRedo => _rounds[showingRound].undoStrokes.isNotEmpty;

  bool get canUndo => _rounds[showingRound].strokes.isNotEmpty;

  set selectingColor(PlayerColor value) {
    _selectingColor = value;
  }

  void undo() {
    if (isDragging || !canUndo) {
      return;
    }
    // _strokes の最後を _undoStrokes へ移動
    final _last = _rounds[showingRound].strokes.last;
    _rounds[showingRound].undoStrokes.add(_last);
    _rounds[showingRound].strokes.removeLast();
    notifyListeners();
  }

  void redo() {
    if (isDragging || !canRedo) {
      return;
    }
    // _undoStrokes の最後を取って、 _strokes に追加する
    final _last = _rounds[showingRound].undoStrokes.last;
    _rounds[showingRound].undoStrokes.removeLast();
    _rounds[showingRound].strokes.add(_last);
    notifyListeners();
  }

  void clear(bool keepUndo) {
    if (!isDragging) {
      // 間違えた場合に戻せるようにundoに残す
      _rounds[showingRound].undoStrokes.clear();
      if (keepUndo) {
        _rounds[showingRound]
            .undoStrokes
            .addAll(_rounds[showingRound].strokes.reversed);
      }
      _rounds[showingRound].strokes.clear();
      notifyListeners();
    }
  }

  void addPaint(Offset startPoint) {
    if (!isDragging) {
      _isDragging = true;
      _rounds[showingRound].undoStrokes.clear(); // redoできないようにする
      _rounds[showingRound]
          .strokes
          .add(OneStroke([startPoint], _selectingColor)); // 新たに開始地点を追加
      notifyListeners();
    }
  }

  void updatePaint(Offset nextPoint) {
    if (isDragging) {
      // 最終位置として追加
      final stroke = _rounds[showingRound].strokes.lastOrNull ??
          OneStroke(<Offset>[], _selectingColor);
      stroke.addOffset(nextPoint);
      if (_rounds[showingRound].strokes.isEmpty) {
        _rounds[showingRound].strokes.add(stroke);
      } else {
        _rounds[showingRound].strokes.last = stroke;
      }
      notifyListeners();
    }
  }

  void endPaint() {
    _isDragging = false;
    notifyListeners();
  }
}

// ラウンド内での移動経路
class RoundRoute {
  final strokes = <OneStroke>[];
  final undoStrokes = <OneStroke>[];
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
