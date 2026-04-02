import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:kk_amongus_tool/model/player.dart';

class PlayerConfig {
  final String name;
  final PlayerColor color;
  final bool isMyself;
  PlayerConfig(this.name, this.color, {this.isMyself = false});
}

class AppConfig {
  final List<PlayerConfig> players;
  AppConfig(this.players);

  static AppConfig get _fallback => AppConfig([
        PlayerConfig("KK", PlayerColor.cyan, isMyself: true),
      ]);

  static Future<AppConfig> load() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/config.json');
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      final players = (map['players'] as List)
          .map((e) {
            final name = e['name'] as String? ?? '';
            if (name.isEmpty) return null;
            final colorName = e['color'] as String;
            final color = PlayerColor.values.firstWhere(
              (c) => c.name == colorName,
              orElse: () => PlayerColor.red,
            );
            return PlayerConfig(name, color,
                isMyself: e['isMyself'] as bool? ?? false);
          })
          .whereType<PlayerConfig>()
          .toList();
      return AppConfig(players.isEmpty ? _fallback.players : players);
    } catch (_) {
      return _fallback;
    }
  }
}
