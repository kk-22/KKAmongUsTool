//▼main.dart

import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/view_model/setting_view_model.dart';
import 'package:provider/provider.dart';

import 'View/screen/home_screen.dart';
import 'view_model/player_view_model.dart';
import 'view_model/round_view_model.dart';
import 'view_model/route_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _roundModel = RoundViewModel();
  late final RouteViewModel _route;
  late final PlayerViewModel _playerModel;

  MyApp({Key? key}) : super(key: key) {
    _route = RouteViewModel(_roundModel);
    _playerModel = PlayerViewModel(_roundModel, _route);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'provider demo',
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<PlayerViewModel>.value(value: _playerModel),
          ChangeNotifierProvider<RoundViewModel>.value(value: _roundModel),
          ChangeNotifierProvider<RouteViewModel>.value(value: _route),
          ChangeNotifierProvider<SettingViewModel>(
            create: (_) => SettingViewModel(),
          ),
        ],
        child: const Scaffold(
          body: HomeScreen(),
        ),
      ),
    );
  }
}
