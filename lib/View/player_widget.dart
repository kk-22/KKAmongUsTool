import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';
import 'package:kk_amongus_tool/dialog/player_status_dialog.dart';

class PlayerWidget extends StatelessWidget {
  // 幅は画像の幅。名前用Textの幅は可変。
  static const Size size = Size(40, _nameHeight + _charHeight);
  static const double _nameHeight = 23;
  static const double _charHeight = 30;

  final Player player;
  final HomeViewModel _viewModel;

  const PlayerWidget(this.player, this._viewModel, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDied =
        (player.diedRound ?? Player.maxRound) <= _viewModel.currentRound;
    return Column(
      children: [
        Container(
          height: _nameHeight,
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(color: Colors.black),
          ),
          child: Text(
            player.name,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        Stack(
          children: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return PlayerStatusDialog(player, _viewModel);
                  },
                );
              },
              icon: Image.asset(
                player.color.imageName,
                fit: BoxFit.contain,
                height: _charHeight,
              ),
            ),
            Visibility(
              visible: isDied && player.status == PlayerStatus.killed,
              child: Image.asset(
                "assets/icon/skull.png",
                fit: BoxFit.contain,
                height: _charHeight * 0.7,
              ),
            ),
            Visibility(
              visible: isDied && player.status == PlayerStatus.ejected,
              child: Image.asset(
                "assets/icon/cross.png",
                fit: BoxFit.contain,
                height: _charHeight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
