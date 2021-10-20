import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/view/parts/player_widget.dart';
import 'package:kk_amongus_tool/view/screen/home_screen.dart';
import 'package:kk_amongus_tool/view_model/home_view_model.dart';
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
              child: Consumer<HomeViewModel>(builder: (context, model, child) {
                final players = model.allPlayer;
                return Stack(
                  key: _mappingKey,
                  children: List.generate(players.length, (index) {
                    return playerItem(
                        players[index], index, model, constraints.maxWidth);
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
    final ignoreMinX = parentWidth * 0.25;
    final ignoreMaxX = parentWidth * 0.75 - PlayerWidget.size.width;
    return Consumer<HomeViewModel>(builder: (context, model, child) {
      var players = model.survivingPlayers(false).where((element) {
        if (element.isMyself) return false;
        final dx = element.mappingOffset.dx;
        return 0 < dx && (dx < ignoreMinX || ignoreMaxX < dx);
      }).toList();

      final maxPlayerCount = parentWidth ~/ PlayerWidget.size.width;
      if (maxPlayerCount < players.length) {
        // 中央に近いPlayerを取り除く
        final centerDx = parentWidth / 2 - PlayerWidget.size.width / 2;
        players.sort((a, b) {
          return (centerDx - a.mappingOffset.dx)
              .abs()
              .compareTo((centerDx - b.mappingOffset.dx).abs());
        });
        players = players.sublist(players.length - maxPlayerCount);
      }

      players.sort((a, b) => a.mappingOffset.dx.compareTo(b.mappingOffset.dx));
      var expandIndex = players
          .indexWhere((element) => ignoreMaxX <= element.mappingOffset.dx);

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
            return PlayerWidget(players[playerIndex], model, true, false);
          }),
        ),
      ]);
    });
  }

  Widget playerItem(
      Player player, int index, HomeViewModel model, double parentWidth) {
    var offset = player.mappingOffset;
    if (offset == Offset.zero) {
      // プレイヤー初期位置
      const betweenWidthRatio = 0.5;
      const numberOfRow = 5;
      final numberOfLine = index ~/ numberOfRow;
      offset = Offset(
          (parentWidth / 2 - PlayerWidget.size.width * betweenWidthRatio / 2) +
              (PlayerWidget.size.width * betweenWidthRatio) *
                  (index % numberOfRow - numberOfRow / 2),
          PlayerWidget.size.height * numberOfLine);
    }
    return Positioned(
      top: offset.dy,
      left: offset.dx,
      child: Draggable(
        child: PlayerWidget(player, model, true, false),
        feedback: Material(
          color: Colors.transparent,
          child: PlayerWidget(player, model, true, false),
        ),
        data: player.name,
        childWhenDragging: const SizedBox.shrink(),
        onDragEnd: (details) {
          final box =
              _mappingKey.currentContext?.findRenderObject() as RenderBox;
          final offset = box.globalToLocal(details.offset);
          // マッピング外に配置されないように位置を補正。
          // 初期位置(Offset.zero)と同じにならないように、最小値は1.0とする。
          final lastDx = min(
              box.size.width - PlayerWidget.size.width, max(1.0, offset.dx));
          final lastDy = min(
              box.size.height - PlayerWidget.size.height, max(1.0, offset.dy));
          model.updateSuspicion(player, Offset(lastDx, lastDy));
        },
      ),
    );
  }
}
