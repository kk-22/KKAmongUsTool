import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';
import 'package:provider/provider.dart';

class PlayerWidget extends StatelessWidget {
  final int playerIndex;
  const PlayerWidget(this.playerIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, model, child) {
      final player = model.playerOfIndex(playerIndex);
      if (player == null) {
        return const Text("null");
      }
      return Center(
        child: Column(
          children: [
            Text(player.name),
            Image.asset(player.color.imageName),
          ],
        ),
      );
    });
  }
}