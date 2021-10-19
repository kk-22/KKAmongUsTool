//▼main.dart

import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/game_setting.dart';
import 'package:provider/provider.dart';

import 'View/screen/home_screen.dart';
import 'view_model/home_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'provider demo',
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeViewModel>(
            create: (_) => HomeViewModel(),
          ),
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
