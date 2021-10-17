import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';
import 'package:kk_amongus_tool/dialog/player_status_dialog.dart';

class PlayerWidget extends StatelessWidget {
  // 幅は画像の幅。名前用Textの幅は可変。
  static const Size size = Size(40, _nameHeight + _charHeight);
  static const double _nameHeight = 23;
  static const double _charHeight = 24;

  final Player player;
  final HomeViewModel _viewModel;

  const PlayerWidget(this.player, this._viewModel, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 現在のラウンドで死んだプレイヤーもtrueになる
    final isDied =
        (player.diedRound ?? Player.maxRound) <= _viewModel.currentRound;
    return Column(
      children: [
        Container(
          height: _nameHeight,
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(color: Colors.black),
          ),
          child: Text(
            player.name,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
        Stack(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
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
              child: IgnorePointer(
                child: Image.asset(
                  "assets/icon/skull.png",
                  fit: BoxFit.contain,
                  height: _charHeight * 0.6,
                ),
              ),
            ),
            Visibility(
              visible: isDied && player.status == PlayerStatus.ejected,
              child: IgnorePointer(
                child: Image.asset(
                  "assets/icon/cross.png",
                  fit: BoxFit.contain,
                  height: _charHeight * 0.8,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
