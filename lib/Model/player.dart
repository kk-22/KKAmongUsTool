import 'dart:ui';

import 'package:flutter/foundation.dart';

class Player {
  static const int maxRound = 15;

  var name = "";
  PlayerColor color;
  List<Offset> offsets = <Offset>[]; // ラウンド毎の位置

  Player(this.name, this.color) {
    resetOffset();
  }

  void resetOffset() {
    offsets = List.filled(Player.maxRound, Offset.zero);
  }
}

enum PlayerColor {
  red,
  blue,
  green,
  pink,
  orange,
  yellow,
  black,
  white,
  purple,
  brown,
  cyan,
  lime,
  maroon,
  rose,
  banana,
  grey,
  tan,
  coral,
}

extension PlayerColorExtension on PlayerColor {
  static const int count = 18;

  String get imageName => "assets/player/${describeEnum(this)}.png";
}
