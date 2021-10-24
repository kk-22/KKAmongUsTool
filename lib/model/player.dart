import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:kk_amongus_tool/view_model/round_view_model.dart';

class Player with ChangeNotifier {
  static const defaultRatioOffset = Offset(0.5, 0);

  String _name;
  final PlayerColor color;

  var isMyself = false;
  DeathInfo? _deathInfo;
  int? _usedButtonOrder; // ボタンを使用した順番。未使用ならnull。1番目の値は0
  List<Offset> offsets = <Offset>[]; // ラウンド毎の位置
  Offset mappingRatioOffset = defaultRatioOffset; // 割合。画像の幅があるため1.0にはならない
  bool isManualOffset = true; // true なら容疑者情報に応じて自動配置する

  Player(this._name, this.color) {
    resetOffset();
  }

  String get name => _name; // 引数のラウンドで死んだプレイヤーもレスポンスに含まれる
  int? get usedButtonOrder => _usedButtonOrder;

  PlayerStatus get status =>
      _deathInfo == null ? PlayerStatus.survive : _deathInfo!.status;

  int? get diedRound => _deathInfo?.round;

  DeathInfo? get deathInfo => _deathInfo;

  bool isSurviving(int round) =>
      round <= (diedRound ?? RoundViewModel.maxRound);

  void resetWithNewRound() {
    _deathInfo = null;
    _usedButtonOrder = null;
    resetOffset();
    notifyListeners();
  }

  void move(int currentRound, Offset offset) {
    offsets[currentRound] = offset;
    notifyListeners();
  }

  void changeSuspicion(Offset ratioOffset) {
    mappingRatioOffset = ratioOffset;
    isManualOffset = false;
    notifyListeners();
  }

  void resetOffset() {
    offsets = List.filled(RoundViewModel.maxRound, Offset.zero);
    mappingRatioOffset = defaultRatioOffset;
    isManualOffset = true;
  }

  void rename(String newName) {
    _name = newName;
    notifyListeners();
  }

  void changedStatus(PlayerStatus status, int currentRound) {
    switch (status) {
      case PlayerStatus.survive:
        _deathInfo = null;
        break;
      case PlayerStatus.killed:
      case PlayerStatus.ejected:
        _deathInfo = DeathInfo(status, currentRound);
        break;
    }
    notifyListeners();
  }

  void useButton(int? order) {
    _usedButtonOrder = order;
    notifyListeners();
  }

  void toggleWhiteList(Player player) {
    if (deathInfo!.whitePlayers.contains(player)) {
      deathInfo!.whitePlayers.remove(player);
    } else {
      deathInfo!.whitePlayers.add(player);
    }
    notifyListeners();
    player.notifyListeners(); // 疑惑度マッピングを更新するため
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

class DeathInfo with ChangeNotifier {
  final PlayerStatus status;
  final int round;
  final List<Player> whitePlayers = <Player>[]; // キルができないプレイヤー

  DeathInfo(this.status, this.round);
}
