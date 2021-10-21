import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/view/parts/player_widget.dart';
import 'package:kk_amongus_tool/view_model/player_view_model.dart';
import 'package:kk_amongus_tool/view_model/round_view_model.dart';
import 'package:provider/provider.dart';

class UsedButton extends StatelessWidget {
  const UsedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playModel = Provider.of<PlayerViewModel>(context);
    final players = playModel.allPlayer;
    return Container(
      color: Colors.blue,
      child: GridView.count(
        crossAxisCount: 5,
        childAspectRatio: 0.4,
        crossAxisSpacing: 1,
        children: List.generate(
          players.length,
          (index) {
            return ChangeNotifierProvider<Player>.value(
              value: players[index],
              child: const PlayerButton(),
            );
          },
        ),
      ),
    );
  }
}

class PlayerButton extends StatelessWidget {
  const PlayerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        PlayerWidget(RoundViewModel.maxRound, true),
      ],
    );
  }
}
