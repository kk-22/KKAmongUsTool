import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';
import 'package:kk_amongus_tool/View/dialog/status_changer.dart';

class PlayerWidget extends StatelessWidget {
  static const Size size = Size(50, _nameHeight + _charHeight);
  static const double _nameHeight = 23;
  static const double _charHeight = 24;

  final Player player;
  final HomeViewModel _viewModel;
  final bool disableButton;
  final bool useCurrentRound;

  const PlayerWidget(
      this.player, this._viewModel, this.disableButton, this.useCurrentRound,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 現在のラウンドで死んだプレイヤーもtrueになる
    final isDied = useCurrentRound
        ? (player.diedRound ?? Player.maxRound) <= _viewModel.currentRound
        : player.diedRound != null;
    return Column(
      children: [
        Container(
          height: _nameHeight,
          alignment: Alignment.center,
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(color: Colors.black),
          ),
          child: Text(
            player.name,
            maxLines: 1,
            overflow: TextOverflow.visible,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),
        Stack(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: disableButton
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatusChanger(player, _viewModel);
                        },
                      );
                    },
              icon: Image.asset(
                player.color.imageName,
                fit: BoxFit.contain,
                height: _charHeight,
              ),
            ),
            if (isDied && player.status == PlayerStatus.killed)
              IgnorePointer(
                child: Image.asset(
                  "assets/icon/skull.png",
                  fit: BoxFit.contain,
                  height: _charHeight * 0.6,
                ),
              ),
            if (isDied && player.status == PlayerStatus.ejected)
              IgnorePointer(
                child: Image.asset(
                  "assets/icon/cross.png",
                  fit: BoxFit.contain,
                  height: _charHeight * 0.8,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
