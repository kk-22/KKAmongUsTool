//▼main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'View/home_screen.dart';
import 'ViewModel/home_view_model.dart';

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
      home: ChangeNotifierProvider<HomeViewModel>(
        create: (_) => HomeViewModel(),
        child: const Scaffold(
          body: HomeScreen(),
        ),
      ),
    );
  }
}