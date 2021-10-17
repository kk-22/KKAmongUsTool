import 'package:flutter/cupertino.dart';
import 'package:kk_amongus_tool/View/player_widget.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';

class SuspicionGraphWidget extends StatelessWidget {
  final HomeViewModel viewModel;

  const SuspicionGraphWidget(this.viewModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final players = viewModel.allPlayer;
    return SizedBox(
      width: 300,
      child: Stack(
        children: List.generate(players.length, (index) {
          final player = players[index];
          return Positioned(
            child: PlayerWidget(player, viewModel),
          );
        }),
      ),
    );
  }
}
