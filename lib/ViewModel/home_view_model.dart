import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';

class HomeViewModel extends ChangeNotifier {
  List<Player> _players = [];
  String mapPath = "assets/map/4_Airship.png";
  int currentRound = 0; // 表示中のラウンド
  int lastRound = 0; // 最終ラウンド

  HomeViewModel() {
    // デバッグ用初期値
    _players = [
      Player("cyan", PlayerColor.cyan),
      Player("赤色", PlayerColor.red),
      Player("みどり", PlayerColor.green),
    ];
    clearPlayerOffsets();
  }

  void clearPlayerOffsets() {
    for (var player in _players) {
      player.resetOffset();
    }
    notifyListeners();
  }

  void clearPlayerName() {
    _players.clear();
    notifyListeners();
  }

  void movePlayer(int index, Offset offset) {
    playerOfIndex(index)?.offsets[currentRound] = offset;
    if (currentRound < lastRound) {
      lastRound = currentRound;
    }
    notifyListeners();
  }

  Player? playerOfColor(PlayerColor color) =>
      _players.firstWhereOrNull((player) => player.color == color);

  Player? playerOfIndex(int index) => _players[index];

  int numberOfPlayers() => _players.length;

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
}
