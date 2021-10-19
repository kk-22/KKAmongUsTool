import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';
import 'package:kk_amongus_tool/dialog/map_selection_dialog.dart';

class HomeViewModel extends ChangeNotifier {
  List<Player> _players = [];
  String mapPath = MapSelectionDialog.defaultMapPath;
  int currentRound = 0; // 表示中のラウンド
  int lastRound = 0; // 最終ラウンド

  List<Player> get allPlayer => _players;

  HomeViewModel() {
    // デバッグ用初期値
    _players = [
      Player("cyan", PlayerColor.cyan),
      Player("赤色", PlayerColor.red),
      Player("みどり", PlayerColor.green),
    ];
    clearPlayerInfo();
  }

  void clearPlayerInfo() {
    for (var player in _players) {
      player.status = PlayerStatus.survive;
      player.diedRound = null;
      player.resetOffset();
    }
    currentRound = 0;
    notifyListeners();
  }

  void removeAllPlayer() {
    _players.clear();
    notifyListeners();
  }

  void movePlayer(Player player, Offset offset) {
    player.offsets[currentRound] = offset;
    if (currentRound < lastRound) {
      lastRound = currentRound;
    }
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

  List<Player> survivingPlayers() =>
      _players.where((element) => element.isSurviving(currentRound)).toList();

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
}
