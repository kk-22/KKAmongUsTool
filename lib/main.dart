//▼main.dart

import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/util/hwnd_util.dart';
import 'package:kk_amongus_tool/view_model/player_view_model.dart';
import 'package:kk_amongus_tool/view_model/round_view_model.dart';
import 'package:kk_amongus_tool/view_model/route_view_model.dart';
import 'package:kk_amongus_tool/view_model/setting_view_model.dart';
import 'package:kk_amongus_tool/view_model/timer_view_model.dart';
import 'package:provider/provider.dart';

import 'view/screen/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _roundModel = RoundViewModel();
  late final RouteViewModel _route;
  late final PlayerViewModel _playerModel;
  final _timerModel = TimerViewModel();

  var _isDeveloping = false;

  MyApp({Key? key}) : super(key: key) {
    _route = RouteViewModel(_roundModel);
    _playerModel = PlayerViewModel(_roundModel, _route);
  }

  @override
  Widget build(BuildContext context) {
    HwndUtil.isDeveloping().then((value) => _isDeveloping = value);
    return MouseRegion(
      onExit: (event) {
        if (!_isDeveloping) {
          HwndUtil.shrinkWnd();
          _timerModel.didShrinkApp();
        }
      },
      child: MaterialApp(
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
            ChangeNotifierProvider<TimerViewModel>(
              create: (_) => TimerViewModel(),
            ),
          ],
          child: Scaffold(
            body: HomeScreen(),
          ),
        ),
      ),
    );
  }
}
