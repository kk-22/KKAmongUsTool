import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/view_model/round_view_model.dart';
import 'package:kk_amongus_tool/view_model/route_view_model.dart';

class PlayerViewModel extends ChangeNotifier {
  final RoundViewModel _roundModel;
  final RouteViewModel _movingRoute;
  List<Player> _players = [];

  List<Player> get allPlayer => _players;

  Player? playerOfColor(PlayerColor color) =>
      _players.firstWhereOrNull((player) => player.color == color);

  Player? playerOfIndex(int index) => _players[index];

  int numberOfPlayers() => _players.length;

  PlayerViewModel(this._roundModel, this._movingRoute) {
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
    resetRound();
  }

  void resetRound() {
    for (var player in _players) {
      player.resetWithNewRound();
    }
    _roundModel.changeRound(0);
    _movingRoute.clear(true);
    notifyListeners();
  }

  void touchedPlayer(Player player) {
    _movingRoute.selectingColor = player.color;
  }

  void movePlayer(Player player, Offset offset) {
    touchedPlayer(player);
    _roundModel.updateLastRoundIfNeeded();
    player.move(_roundModel.currentRound, offset);
  }

  void updateSuspicion(Player player, Offset offset) {
    player.changeSuspicion(offset);
    // `headerChart` の一覧に影響するためここで通知
    notifyListeners();
  }

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
    final round =
        isCurrentRound ? _roundModel.currentRound : _roundModel.lastRound + 1;
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
    player.changedStatus(status, _roundModel.currentRound);
    _roundModel.updateLastRoundIfNeeded();
    // survivingPlayers メソッドの戻り値に影響するためここで通知
    notifyListeners();
  }

  void resetButtonOrder(Player player) {
    player.useButton(null);
    final usedPlayers = allPlayer
        .where((element) => element.usedButtonOrder != null)
        .sorted((a, b) => a.usedButtonOrder!.compareTo(b.usedButtonOrder!));
    for (var i = 0; i < usedPlayers.length; i++) {
      usedPlayers[i].useButton(i);
    }
  }
}
