import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/view/parts/player_widget.dart';
import 'package:kk_amongus_tool/view/screen/home_screen.dart';
import 'package:kk_amongus_tool/view_model/player_view_model.dart';
import 'package:kk_amongus_tool/view_model/round_view_model.dart';
import 'package:provider/provider.dart';

class SuspicionMapping extends StatelessWidget {
  const SuspicionMapping({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        height: HomeScreen.overlayBarHeight,
        color: Colors.white,
        child: headerChart(constraints.maxWidth),
      );
    });
  }

  Widget headerChart(double parentWidth) {
    const ignoreMinX = 0.25;
    final ignoreMaxX = 0.75 - PlayerWidget.size.width / parentWidth;
    return Consumer<PlayerViewModel>(builder: (context, model, child) {
      var players = model.survivingPlayers(false).where((element) {
        if (element.isMyself) return false;
        final dx = element.mappingRatioOffset.dx;
        return dx < ignoreMinX || ignoreMaxX < dx;
      }).toList();

      final maxPlayerCount = parentWidth ~/ PlayerWidget.size.width;
      if (maxPlayerCount < players.length) {
        // 中央に近いPlayerを取り除く
        players.sort((a, b) {
          final bAbs =
              Player.defaultRatioOffset.dx - b.mappingRatioOffset.dx.abs();
          return (Player.defaultRatioOffset.dx - a.mappingRatioOffset.dx)
              .abs()
              .compareTo(bAbs);
        });
        players = players.sublist(players.length - maxPlayerCount);
      }

      players.sort(
          (a, b) => a.mappingRatioOffset.dx.compareTo(b.mappingRatioOffset.dx));
      var expandIndex = players
          .indexWhere((element) => ignoreMaxX <= element.mappingRatioOffset.dx);

      final playerCount = min(maxPlayerCount, players.length);
      if (expandIndex == -1) expandIndex = playerCount; // 全プレイヤー黒位置のケース

      return Stack(children: [
        Row(
          children: [
            Container(
              width: expandIndex * PlayerWidget.size.width,
              color: Colors.black,
            ),
            Expanded(
              child: Container(
                color: Colors.black12,
              ),
            ),
            Container(
              width: (playerCount - expandIndex) * PlayerWidget.size.width,
              color: Colors.white,
            ),
          ],
        ),
        Row(
          children: List.generate(playerCount + 1, (index) {
            if (index == expandIndex) {
              return const Expanded(
                child: SizedBox(),
              );
            }
            final playerIndex = (index < expandIndex ? index : index - 1);
            return ChangeNotifierProvider<Player>.value(
              value: players[playerIndex],
              child: const PlayerWidget(RoundViewModel.maxRound, true),
            );
          }),
        ),
      ]);
    });
  }
}
