import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';

class HomeViewModel extends ChangeNotifier {
  List<Player> _players = [];
  String mapPath = "assets/map/4_Airship.png";
  int currentRound = 0; // 表示中のラウンド
  int lastRound = 0; // 最終ラウンド

  HomeViewModel() {
    clearPlayers();
  }

  void clearPlayers() {
    final p1 = Player();
    p1.name = "青色";
    p1.color = PlayerColor.blue;
    p1.offsets = List.filled(Player.maxRound, const Offset(100, 100));
    _players = [
      p1,
    ];
    notifyListeners();
  }

  void movePlayer(int index, Offset offset) {
    playerOfIndex(index)?.offsets[currentRound] = offset;
    if (currentRound < lastRound) {
      lastRound = currentRound;
    }
    notifyListeners();
  }

  Player? playerOfColor(PlayerColor color) {
    _players.firstWhere((element) => element.color == color);
  }

  Player? playerOfIndex(int index) => _players[index];

  int numberOfPlayers() => _players.length;
}
