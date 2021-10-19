import 'dart:ui';

import 'package:flutter/foundation.dart';

class Player {
  static const int maxRound = 15;

  String name;
  final PlayerColor color;

  var status = PlayerStatus.survive;
  int? diedRound;
  List<Offset> offsets = <Offset>[]; // ラウンド毎の位置
  Offset mappingOffset = Offset.zero;

  Player(this.name, this.color) {
    resetOffset();
  }

  // 引数のラウンドで死んだプレイヤーもレスポンスに含まれる
  bool isSurviving(int round) => round <= (diedRound ?? maxRound);

  void resetOffset() {
    offsets = List.filled(Player.maxRound, Offset.zero);
    mappingOffset = Offset.zero;
  }
}

enum PlayerStatus {
  survive,
  killed,
  ejected,
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
