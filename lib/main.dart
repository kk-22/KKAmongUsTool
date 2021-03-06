//▼main.dart

import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/view_model/player_view_model.dart';
import 'package:kk_amongus_tool/view_model/round_view_model.dart';
import 'package:kk_amongus_tool/view_model/route_view_model.dart';
import 'package:kk_amongus_tool/view_model/setting_view_model.dart';
import 'package:kk_amongus_tool/view_model/timer_view_model.dart';
import 'package:kk_amongus_tool/view_model/wnd_view_model.dart';
import 'package:provider/provider.dart';

import 'view/screen/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _roundModel = RoundViewModel();
  late final RouteViewModel _route;
  late final PlayerViewModel _playerModel;
  late final WndViewModel _wndModel;

  MyApp({Key? key}) : super(key: key) {
    _route = RouteViewModel(_roundModel);
    _playerModel = PlayerViewModel(_roundModel, _route);
    _wndModel = WndViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlayerViewModel>.value(value: _playerModel),
        ChangeNotifierProvider<RoundViewModel>.value(value: _roundModel),
        ChangeNotifierProvider<RouteViewModel>.value(value: _route),
        ChangeNotifierProvider<WndViewModel>.value(value: _wndModel),
        ChangeNotifierProvider<SettingViewModel>(
          create: (_) => SettingViewModel(),
        ),
        ChangeNotifierProvider<TimerViewModel>(
          create: (_) => TimerViewModel(_roundModel, _wndModel),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'provider demo',
        home: Scaffold(
          body: HomeScreen(),
        ),
      ),
    );
  }
}
