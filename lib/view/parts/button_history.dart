import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/view/parts/player_widget.dart';
import 'package:kk_amongus_tool/view_model/player_view_model.dart';
import 'package:kk_amongus_tool/view_model/round_view_model.dart';
import 'package:provider/provider.dart';

class ButtonHistory extends StatelessWidget {
  const ButtonHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerModel = Provider.of<PlayerViewModel>(context);
    final players = List.of(playerModel.allPlayer);
    players.sort((a, b) {
      final status = a.status.index.compareTo(b.status.index);
      if (status != 0) return status;
      if (a.usedButtonOrder == null) return -1;
      if (b.usedButtonOrder == null) return 1;
      return a.usedButtonOrder!.compareTo(b.usedButtonOrder!);
    });

    return GridView.count(
      crossAxisCount: 5,
      childAspectRatio: 0.5,
      crossAxisSpacing: 1,
      children: List.generate(
        players.length,
        (index) {
          return ChangeNotifierProvider<Player>.value(
            value: players[index],
            child: PlayerButton(playerModel),
          );
        },
      ),
    );
  }
}

class PlayerButton extends StatelessWidget {
  final PlayerViewModel _playerModel;

  const PlayerButton(this._playerModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<Player>(context);
    final order = player.usedButtonOrder;
    return Column(
      children: [
        const PlayerWidget(RoundViewModel.maxRound, true),
        if (order != null)
          TextButton(
            onPressed: () {
              // 間違えて押した場合用に元に戻す
              _playerModel.resetButtonOrder(player);
            },
            child: Text(
              "${order + 1}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        else if (player.diedRound == null)
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              final usedCount = _playerModel.allPlayer
                  .where((element) => element.usedButtonOrder != null)
                  .length;
              player.useButton(usedCount);
            },
            icon: Image.asset("assets/icon/emergency_button.png"),
          )
        else
          const Icon(Icons.clear),
      ],
    );
  }
}
