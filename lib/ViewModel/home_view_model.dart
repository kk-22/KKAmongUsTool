import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';

class HomeViewModel extends ChangeNotifier {
  List<Player> _players = [];

  HomeViewModel() {
    clearPlayers();
  }

  void clearPlayers() {
    final p1 = Player();
    p1.name = "青色";
    p1.color = PlayerColor.blue;
    _players = [
      p1,
    ];
    notifyListeners();
  }

  Player? playerOfColor(PlayerColor color) {
    _players.firstWhere((element) => element.color == color);
  }

  Player? playerOfIndex(int index) => _players[index];

  int numberOfPlayers() => _players.length;
}