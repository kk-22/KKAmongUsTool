import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/View/map_widget.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, model, child) {
      return Center(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('clearボタン'),
              onPressed: () {
                model.clearPlayers();
              },
            ),
            const SizedBox(
              width: 1000,
              height: 500,
              child: MapWidget(),
            )
          ],
        ),
      );
    });
  }
}
