//▼main.dart

import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/game_setting.dart';
import 'package:provider/provider.dart';

import 'View/screen/home_screen.dart';
import 'model/moving_route.dart';
import 'model/round.dart';
import 'view_model/player_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _round = Round();
  late final MovingRoute _route;
  late final PlayerViewModel _playerModel;

  MyApp({Key? key}) : super(key: key) {
    _route = MovingRoute(_round);
    _playerModel = PlayerViewModel(_round, _route);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'provider demo',
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<PlayerViewModel>.value(value: _playerModel),
          ChangeNotifierProvider<Round>.value(value: _round),
          ChangeNotifierProvider<MovingRoute>.value(value: _route),
          ChangeNotifierProvider<GameSetting>(
            create: (_) => GameSetting(),
          ),
        ],
        child: const Scaffold(
          body: HomeScreen(),
        ),
      ),
    );
  }
}
