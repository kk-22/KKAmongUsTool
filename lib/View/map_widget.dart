import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/View/player_widget.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, model, child) {
      if (model.numberOfPlayers() == 0) {
        return const Text("No player");
      }
      return Center(
        child: Column(
          children: const [
            PlayerWidget(0),
          ],
        ),
      );
    });
  }
}