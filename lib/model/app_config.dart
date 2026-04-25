import 'dart:convert';
import 'dart:io';
import 'package:kk_amongus_tool/model/player.dart';

class PlayerConfig {
  final String name;
  final PlayerColor color;
  final bool isMyself;
  final bool isEnabled;
  PlayerConfig(this.name, this.color,
      {this.isMyself = false, this.isEnabled = false});
}

class AppConfig {
  final List<PlayerConfig> players;
  AppConfig(this.players);

  static File get _configFile {
    final exeDir = File(Platform.resolvedExecutable).parent.path;
    return File('$exeDir${Platform.pathSeparator}config.json');
  }

  static List<PlayerConfig> get _defaultPlayers =>
      PlayerColor.values.map((color) {
        if (color == PlayerColor.cyan) {
          return PlayerConfig('KK', color, isMyself: true, isEnabled: true);
        }
        return PlayerConfig('', color);
      }).toList();

  static Future<AppConfig> load() async {
    try {
      final file = _configFile;
      if (!file.existsSync()) {
        final config = AppConfig(_defaultPlayers);
        await save(config.players);
        return config;
      }
      final map = json.decode(await file.readAsString()) as Map<String, dynamic>;
      final colorMap = <PlayerColor, PlayerConfig>{};
      for (final e in map['players'] as List) {
        final colorName = e['color'] as String? ?? '';
        final color = PlayerColor.values.firstWhere(
          (c) => c.name == colorName,
          orElse: () => PlayerColor.red,
        );
        final name = e['name'] as String? ?? '';
        final isMyself = e['isMyself'] as bool? ?? false;
        final isEnabled = e['isEnabled'] as bool? ?? false;
        colorMap[color] =
            PlayerConfig(name, color, isMyself: isMyself, isEnabled: isEnabled);
      }
      final players = PlayerColor.values
          .map((c) => colorMap[c] ?? PlayerConfig('', c))
          .toList();
      return AppConfig(players);
    } catch (_) {
      return AppConfig(_defaultPlayers);
    }
  }

  static Future<void> save(List<PlayerConfig> players) async {
    try {
      final map = {
        'players': players.map((p) {
          return {
            'color': p.color.name,
            'name': p.name,
            if (p.isMyself) 'isMyself': true,
            'isEnabled': p.isEnabled,
          };
        }).toList(),
      };
      await _configFile
          .writeAsString(const JsonEncoder.withIndent('  ').convert(map));
    } catch (_) {}
  }
}
