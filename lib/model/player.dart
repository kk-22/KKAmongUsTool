import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:kk_amongus_tool/view_model/round_view_model.dart';

class Player with ChangeNotifier {
  String _name;
  final PlayerColor color;

  var isMyself = false;
  var totalSuspicionScore = 0;
  var subjectiveSuspicionScore = 0;
  CauseOfDeath? _caseOfDeath;
  int? _usedButtonOrder; // ボタンを使用した順番。未使用ならnull。1番目の値は0
  List<Offset> offsets = <Offset>[]; // ラウンド毎の位置

  Player(this._name, this.color) {
    resetOffset();
  }

  String get name => _name; // 引数のラウンドで死んだプレイヤーもレスポンスに含まれる
  int? get usedButtonOrder => _usedButtonOrder;

  PlayerStatus get status =>
      _caseOfDeath == null ? PlayerStatus.survive : _caseOfDeath!.status;

  int? get diedRound => _caseOfDeath?.round;

  CauseOfDeath? get caseOfDeath => _caseOfDeath;

  bool isSurviving(int round) =>
      round <= (diedRound ?? RoundViewModel.maxRound);

  void resetWithNewRound() {
    _caseOfDeath = null;
    _usedButtonOrder = null;
    subjectiveSuspicionScore = 0;
    resetOffset();
    notifyListeners();
  }

  void move(int currentRound, Offset offset) {
    offsets[currentRound] = offset;
    notifyListeners();
  }

  void resetOffset() {
    offsets = List.filled(RoundViewModel.maxRound, Offset.zero);
  }

  void rename(String newName) {
    _name = newName;
    notifyListeners();
  }

  void changedStatus(PlayerStatus status, int currentRound) {
    switch (status) {
      case PlayerStatus.survive:
        _caseOfDeath = null;
        break;
      case PlayerStatus.killed:
      case PlayerStatus.ejected:
      _caseOfDeath = CauseOfDeath(status, currentRound);
        break;
    }
    notifyListeners();
  }

  void useButton(int? order) {
    _usedButtonOrder = order;
    notifyListeners();
  }

  void toggleWhiteList(Player player) {
    if (caseOfDeath!.whitePlayers.contains(player)) {
      caseOfDeath!.whitePlayers.remove(player);
    } else {
      caseOfDeath!.whitePlayers.add(player);
    }
  }
}

enum PlayerStatus {
  survive,
  killed,
  ejected,
}

extension PlayerStatusExtension on PlayerStatus {
  String imageName(PlayerColor color) {
    switch (this) {
      case PlayerStatus.survive:
        return color.imageName;
      case PlayerStatus.killed:
        return "assets/icon/skull.png";
      case PlayerStatus.ejected:
        return "assets/icon/cross.png";
    }
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

  Color hexColor() {
    switch (this) {
      case PlayerColor.red:
        return const Color(0xffec1c24);
      case PlayerColor.blue:
        return const Color(0xff3f48cc);
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

class CauseOfDeath with ChangeNotifier {
  final PlayerStatus status;
  final int round;
  final List<Player> whitePlayers = <Player>[]; // キルができないプレイヤー

  CauseOfDeath(this.status, this.round);
}
