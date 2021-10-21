import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/moving_route.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/model/round.dart';

class HomeViewModel extends ChangeNotifier {
  final Round _round;
  final MovingRoute _movingRoute;
  List<Player> _players = [];

  List<Player> get allPlayer => _players;

  HomeViewModel(this._round, this._movingRoute) {
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
    _round.changeRound(0);
    _movingRoute.clear(true);
    notifyListeners();
  }

  void movePlayer(Player player, Offset offset) {
    touchedPlayer(player);
    _round.updateLastRoundIfNeeded();
    player.move(_round.currentRound, offset);
  }

  void updateSuspicion(Player player, Offset offset) {
    player.changeSuspicion(offset);
    // `headerChart` の一覧に影響するためここで通知
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
    final round = isCurrentRound ? _round.currentRound : _round.lastRound + 1;
    return _players.where((element) => element.isSurviving(round)).toList();
  }

  void changeMySelf(PlayerColor? nextColor, PlayerColor? prevColor) {
    if (nextColor != null) {
      playerOfColor(nextColor)?.isMyself = true;
    }
    if (prevColor != null) {
      playerOfColor(prevColor)?.isMyself = false;
    }
    // `headerChart` の一覧に影響するためここで通知
    notifyListeners();
  }

  void changeName(String name, PlayerColor color) {
    var player = playerOfColor(color);
    if (name.isEmpty) {
      _players.remove(player);
      notifyListeners();
    } else if (player != null) {
      player.rename(name);
    } else {
      _players.add(Player(name, color));
      notifyListeners();
    }
  }

  void changePlayerStatus(Player player, PlayerStatus status) {
    player.changedStatus(status, _round.currentRound);
    _round.updateLastRoundIfNeeded();
    // survivingPlayers メソッドの戻り値に影響するためここで通知
    notifyListeners();
  }
}
