import 'dart:ui';

import 'package:flutter/foundation.dart';

class Player {
  static const int maxRound = 15;

  String name;
  final PlayerColor color;

  var isMyself = false;
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

  Color hexColor() {
    switch (this) {
      case PlayerColor.red:
        return const Color(0xffec1c24);
      case PlayerColor.blue:
        return const Color(0xff00a8f3);
      case PlayerColor.green:
        return const Color(0xff0ed145);
      case PlayerColor.pink:
        return const Color(0xffff6699);
      case PlayerColor.orange:
        return const Color(0xffec6800);
      case PlayerColor.yellow:
        return const Color(0xfffff200);
      case PlayerColor.black:
        return const Color(0xff000000);
      case PlayerColor.white:
        return const Color(0xffffffff);
      case PlayerColor.purple:
        return const Color(0xff961482);
      case PlayerColor.brown:
        return const Color(0xffb97a56);
      case PlayerColor.cyan:
        return const Color(0xff8cfffb);
      case PlayerColor.lime:
        return const Color(0xffc4ff0e);
      case PlayerColor.maroon:
        return const Color(0xff88001b);
      case PlayerColor.rose:
        return const Color(0xfffbc3d8);
      case PlayerColor.banana:
        return const Color(0xfffdeca6);
      case PlayerColor.grey:
        return const Color(0xffc3c3c3);
      case PlayerColor.tan:
        return const Color(0xffd2b48c);
      case PlayerColor.coral:
        return const Color(0xffff9888);
    }
  }
}
