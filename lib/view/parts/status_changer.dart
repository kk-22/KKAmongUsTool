import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/view_model/player_view_model.dart';
import 'package:provider/src/provider.dart';

class StatusChanger extends StatelessWidget {
  static const width = 152.0;
  final Player _player;

  const StatusChanger(this._player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusList = PlayerStatus.values
        .where((element) => element != _player.status)
        .toList()
        .reversed;
    final List<Widget> scoreWidgets = [-10, -1, 1, 10].map((score) {
      return Expanded(
        child: TextButton(
          onPressed: () {
            final playerModel = context.read<PlayerViewModel>();
            playerModel.addSubjectiveScore(_player, score);
          },
          child: Text(
            "$score",
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }).toList();
    scoreWidgets.insert(
      scoreWidgets.length ~/ 2,
      Expanded(
        child: Center(
          child: Text(
            "${_player.subjectiveSuspicionScore}",
          ),
        ),
      ),
    );

    return Column(
      children: [
        Row(
          children: statusList.map((status) {
            return Container(
              width: width / 2,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
              ),
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
        Container(
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            children: scoreWidgets,
          ),
        ),
      ],
    );
  }
}
