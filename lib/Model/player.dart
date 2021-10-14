import 'dart:ui';

class Player {
  String name = "名前";
  PlayerColor color = PlayerColor.unknown;
  List<Offset> offsets = <Offset>[]; // ターン毎の位置
}

enum PlayerColor {
  unknown,
  red,
  blue,
}

extension PlayerColorExtension on PlayerColor {
  static final _names = {
    PlayerColor.unknown: "cyan",
    PlayerColor.red: "cyan",
    PlayerColor.blue: "cyan",
  };
  String get imageName => "assets/player/${_names[this]}.png";
}