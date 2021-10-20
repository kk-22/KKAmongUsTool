//▼main.dart

import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/game_setting.dart';
import 'package:provider/provider.dart';

import 'View/screen/home_screen.dart';
import 'model/moving_route.dart';
import 'view_model/home_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _route = MovingRoute();
  late final HomeViewModel _viewModel;

  MyApp({Key? key}) : super(key: key) {
    _viewModel = HomeViewModel(_route);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'provider demo',
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeViewModel>.value(value: _viewModel),
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
