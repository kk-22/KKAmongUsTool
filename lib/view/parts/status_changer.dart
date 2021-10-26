import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/view_model/player_view_model.dart';
import 'package:provider/src/provider.dart';

class StatusChanger extends StatelessWidget {
  static const width = 100.0;
  final Player _player;

  const StatusChanger(this._player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusList = PlayerStatus.values
        .where((element) => element != _player.status)
        .toList();
    return SizedBox(
      width: width,
      child: Row(
        children: statusList.map((status) {
          return Container(
            width: width / 2,
            color: Colors.white,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                final playerModel = context.read<PlayerViewModel>();
                playerModel.changePlayerStatus(_player, status);
              },
              icon: Image.asset(
                status.imageName(_player.color),
                fit: BoxFit.contain,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
