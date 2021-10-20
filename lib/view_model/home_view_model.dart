import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/view/dialog/map_selector.dart';
import 'package:kk_amongus_tool/model/moving_route.dart';

class HomeViewModel extends ChangeNotifier {
  final MovingRoute _movingRoute;
  List<Player> _players = [];
  String mapPath = MapSelector.defaultMapPath;
  int currentRound = 0; // 表示中のラウンド
  int lastRound = 0; // 最終ラウンド

  List<Player> get allPlayer => _players;

  HomeViewModel(this._movingRoute) {
    // デバッグ用初期値
    _players = [
      Player("KK", PlayerColor.cyan),
      Player("赤色", PlayerColor.red),
      Player("みどり", PlayerColor.green),
      Player("yellow", PlayerColor.yellow),
      Player("TAN", PlayerColor.tan),
      Player("むらさき色", PlayerColor.purple),
    ];
    _players[0].isMyself = true;
    clearPlayerInfo();
  }

  void touchedPlayer(Player player) {
    _movingRoute.selectingColor = player.color;
  }

  void clearPlayerInfo() {
    for (var player in _players) {
      player.status = PlayerStatus.survive;
      player.diedRound = null;
      player.resetOffset();
    }
    currentRound = 0;
    _movingRoute.clear(false);
    notifyListeners();
  }

  void movePlayer(Player player, Offset offset) {
    player.offsets[currentRound] = offset;
    _updateLastRoundIfNeeded();
    touchedPlayer(player);
    notifyListeners();
  }

  void updateSuspicion(Player player, Offset offset) {
    player.mappingOffset = offset;
    notifyListeners();
  }

  Player? playerOfColor(PlayerColor color) =>
      _players.firstWhereOrNull((player) => player.color == color);

  Player? playerOfIndex(int index) => _players[index];

  int numberOfPlayers() => _players.length;

  List<int> numberOfPlayerEachStatus() {
    return [
      _players
          .where((element) => element.status == PlayerStatus.survive)
          .length,
      _players.where((element) => element.status == PlayerStatus.killed).length,
      _players
          .where((element) => element.status == PlayerStatus.ejected)
          .length,
    ];
  }

  // 引数がfalseなら最終ラウンドの会議時点で生存しているプレイヤーのみ返す
  List<Player> survivingPlayers(bool isCurrentRound) {
    final round = isCurrentRound ? currentRound : lastRound + 1;
    return _players.where((element) => element.isSurviving(round)).toList();
  }

  void changeMySelf(PlayerColor? nextColor, PlayerColor? prevColor) {
    if (nextColor != null) {
      playerOfColor(nextColor)?.isMyself = true;
    }
    if (prevColor != null) {
      playerOfColor(prevColor)?.isMyself = false;
    }
    notifyListeners();
  }

  void changeName(String name, PlayerColor color) {
    var player = playerOfColor(color);
    if (name.isEmpty) {
      _players.remove(player);
    } else if (player != null) {
      player.name = name;
    } else {
      _players.add(Player(name, color));
    }
    notifyListeners();
  }

  void changePlayerStatus(Player player, PlayerStatus status) {
    switch (status) {
      case PlayerStatus.survive:
        player.diedRound = null;
        break;
      case PlayerStatus.killed:
      case PlayerStatus.ejected:
        player.diedRound = currentRound;
        break;
    }
    player.status = status;
    _updateLastRoundIfNeeded();
    notifyListeners();
  }

  void changeMap(String path) {
    mapPath = path;
    notifyListeners();
  }

  void changeRound(int index) {
    currentRound = index;
    notifyListeners();
  }

  void _updateLastRoundIfNeeded() {
    if (lastRound < currentRound) {
      lastRound = currentRound;
    }
  }
}
