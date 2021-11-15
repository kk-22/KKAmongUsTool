import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/view_model/round_view_model.dart';
import 'package:kk_amongus_tool/view_model/route_view_model.dart';

class PlayerViewModel extends ChangeNotifier {
  final RoundViewModel _roundModel;
  final RouteViewModel _movingRoute;
  final SelectingColor _selectingColor =
      SelectingColor(); // プレイヤー毎のステータス変更Widget表示用
  List<Player> _players = [];

  // インスタンスをそのまま返すため、呼び出し元でsortメソッドはNG
  List<Player> get allPlayer => _players;

  SelectingColor get selectingColor => _selectingColor;

  Player? playerOfColor(PlayerColor color) =>
      _players.firstWhereOrNull((player) => player.color == color);

  Player? playerOfIndex(int index) => _players[index];

  int numberOfPlayers() => _players.length;

  PlayerViewModel(this._roundModel, this._movingRoute) {
    // デバッグ用初期値
    _players = [
      Player("KK", PlayerColorEx.myselfColor),
      Player("赤色", PlayerColor.red),
      Player("みどり", PlayerColor.green),
      Player("yellow", PlayerColor.yellow),
      Player("TAN", PlayerColor.tan),
      Player("むらさき色", PlayerColor.purple),
      Player("BLACK", PlayerColor.black),
      Player("白白白", PlayerColor.white),
    ];
    _players[0].isMyself = true;
    resetRound();
  }

  void resetRound() {
    for (var player in _players) {
      player.resetWithNewRound();
    }
    _roundModel.reset();
    _movingRoute.clear(true);
    cancelSelectingColor();
    notifyListeners();
  }

  void cancelSelectingColor() {
    selectingColor.value = null;
  }

  void touchedPlayer(Player player) {
    if (selectingColor.value == player.color) {
      cancelSelectingColor();
    } else {
      selectingColor.value = player.color;
    }
    _movingRoute.selectingColor = player.color;
  }

  void movePlayer(Player player, Offset offset) {
    _movingRoute.selectingColor = player.color;
    _roundModel.updateLastRoundIfNeeded();
    player.move(_roundModel.currentRound, offset);
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
        isCurrentRound ? _roundModel.currentRound : RoundViewModel.maxRound;
    return _players.where((element) => element.isSurviving(round)).toList();
  }

  List<Player> killedPlayers() {
    return _players
        .where((element) => element.status == PlayerStatus.killed)
        .toList();
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

    cancelSelectingColor();
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

  void addSubjectiveScore(Player player, int score) {
    player.subjectiveSuspicionScore += score;
    notifyListeners();
  }

  // スコアを設定したプレイヤーの一覧を返す
  List<Player> playersWithScore() {
    final players = survivingPlayers(false).where((element) {
      return !element.isMyself;
    }).toList();
    final blackLists = killedPlayers().map((killedPlayer) {
      return players
          .where((e) => !killedPlayer.caseOfDeath!.whitePlayers.contains(e))
          .toList();
    }).toList();

    for (final player in players) {
      var score = 0;
      for (final blackList in blackLists) {
        if (blackList.contains(player)) {
          score -= 2; // 容疑者である
        }
      }
      score += player.subjectiveSuspicionScore;
      player.totalSuspicionScore = score;
    }
    return players;
  }

  void toggleWhiteList(Player killedPlayer, Player killer) {
    killedPlayer.toggleWhiteList(killer);
    notifyListeners();
  }
}

class SelectingColor with ChangeNotifier {
  PlayerColor? _value;

  SelectingColor();

  PlayerColor? get value => _value;

  set value(PlayerColor? value) {
    _value = value;
    notifyListeners();
  }
}
