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
  static final widgetHeight = HomeScreen.overlayBarHeight + 2 + _stackHeight;
  static final _stackHeight = PlayerWidget.size.height * 3;

  final _mappingKey = GlobalKey();

  SuspicionMapping({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        color: Colors.white,
        height: widgetHeight,
        child: Column(
          children: [
            SizedBox(
              height: HomeScreen.overlayBarHeight,
              child: headerChart(constraints.maxWidth),
            ),
            Container(
              height: _stackHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.centerLeft,
                  end: FractionalOffset.centerRight,
                  colors: [
                    Colors.black,
                    Colors.white,
                  ],
                ),
                border: Border(
                  left: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                  top: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
              ),
              child:
                  Consumer<PlayerViewModel>(builder: (context, model, child) {
                final players = model.survivingPlayers(false);
                return Stack(
                  key: _mappingKey,
                  children: List.generate(players.length, (index) {
                    return ChangeNotifierProvider<Player>.value(
                      value: players[index],
                      child: playerItem(
                          players[index], index, model, constraints.maxWidth),
                    );
                  }),
                );
              }),
            ),
          ],
        ),
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

  Widget playerItem(
      Player player, int index, PlayerViewModel model, double parentWidth) {
    var offset = player.mappingRatioOffset;
    if (player.isManualOffset) {
      // プレイヤー初期位置
      const betweenWidthRatio = 0.5;
      const numberOfRow = 5;
      final numberOfLine = index ~/ numberOfRow;
      offset = Offset(
          (parentWidth / 2 - PlayerWidget.size.width * betweenWidthRatio / 2) +
              (PlayerWidget.size.width * betweenWidthRatio) *
                  (index % numberOfRow - numberOfRow / 2),
          PlayerWidget.size.height * numberOfLine);
    } else {
      offset = Offset(player.mappingRatioOffset.dx * parentWidth,
          player.mappingRatioOffset.dy * parentWidth);
    }
    return Positioned(
      top: offset.dy,
      left: offset.dx,
      child: Draggable(
        child: const PlayerWidget(RoundViewModel.maxRound, true),
        feedback: Material(
          color: Colors.transparent,
          child: ChangeNotifierProvider<Player>.value(
            value: player,
            child: const PlayerWidget(RoundViewModel.maxRound, true),
          ),
        ),
        data: player.name,
        childWhenDragging: const SizedBox.shrink(),
        onDragEnd: (details) {
          final box =
              _mappingKey.currentContext?.findRenderObject() as RenderBox;
          final offset = box.globalToLocal(details.offset);
          // マッピング外に配置されないように位置を補正。
          final lastDx = min(
              box.size.width - PlayerWidget.size.width, max(0.0, offset.dx));
          final lastDy = min(
              box.size.height - PlayerWidget.size.height, max(0.0, offset.dy));
          model.updateSuspicion(
              player, Offset(lastDx / parentWidth, lastDy / parentWidth));
        },
      ),
    );
  }
}
