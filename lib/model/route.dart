import 'dart:core';

import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';

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
