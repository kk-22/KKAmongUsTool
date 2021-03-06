import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/view_model/player_view_model.dart';
import 'package:kk_amongus_tool/view_model/round_view_model.dart';
import 'package:provider/provider.dart';

class PlayerWidget extends StatelessWidget {
  static const Size size = Size(50, _nameHeight + _charHeight);
  static const double _nameHeight = 23;
  static const double _charHeight = 24;

  final int _currentRound;
  final bool disableButton;

  const PlayerWidget(this._currentRound, this.disableButton, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<Player>(context);
    // 現在のラウンドで死んだプレイヤーもtrueになる
    final isDied =
        (player.diedRound ?? RoundViewModel.maxRound) <= _currentRound;
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
            overflow: TextOverflow.clip, // ellipsis だと表示される文字がさらに減る
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
                      final playerModel =
                          Provider.of<PlayerViewModel>(context, listen: false);
                      playerModel.touchedPlayer(player);
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
