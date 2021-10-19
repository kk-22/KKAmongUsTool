import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';
import 'package:kk_amongus_tool/view_model/home_view_model.dart';

class StatusChanger extends StatelessWidget {
  final Player _player;
  final HomeViewModel _viewModel;

  const StatusChanger(this._player, this._viewModel, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusTexts = ["生存", "殺害", "追放"];
    final statusList = [
      PlayerStatus.survive,
      PlayerStatus.killed,
      PlayerStatus.ejected
    ];
    return SimpleDialog(
      title: const Text("プレイヤー状態変更"),
      children: List.generate(statusTexts.length, (index) {
        return SimpleDialogOption(
          onPressed: () {
            _viewModel.changePlayerStatus(_player, statusList[index]);
            Navigator.pop(context);
          },
          child: Text(statusTexts[index]),
        );
      }),
    );
  }
}
