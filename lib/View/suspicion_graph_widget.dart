import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';
import 'package:kk_amongus_tool/View/home_screen.dart';
import 'package:kk_amongus_tool/View/player_widget.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';
import 'package:provider/provider.dart';

class SuspicionGraphWidget extends StatelessWidget {
  static final widgetHeight = HomeScreen.buttonBarHeight + 2 + _stackHeight;
  static final _stackHeight = PlayerWidget.size.height * 3;

  final _mappingKey = GlobalKey();

  SuspicionGraphWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        color: Colors.white,
        height: widgetHeight,
        child: Column(
          children: [
            Container(
              height: HomeScreen.buttonBarHeight,
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

  Widget playerItem(
      Player player, int index, HomeViewModel model, double parentWidth) {
    var offset = player.mappingOffset;
    if (offset == Offset.zero) {
      // プレイヤー初期位置
      const numberOfRow = 5;
      final numberOfLine = index ~/ numberOfRow;
      offset = Offset(
          parentWidth / 2 +
              (PlayerWidget.size.width * 0.5) *
                  (index % numberOfRow - numberOfRow / 2),
          PlayerWidget.size.height * numberOfLine);
    }
    return Positioned(
      top: offset.dy,
      left: offset.dx,
      child: Draggable(
        child: PlayerWidget(player, model),
        feedback: Material(
          color: Colors.transparent,
          child: PlayerWidget(player, model),
        ),
        data: player.name,
        childWhenDragging: const SizedBox.shrink(),
        onDragEnd: (details) {
          final box =
              _mappingKey.currentContext?.findRenderObject() as RenderBox;
          final offset = box.globalToLocal(details.offset);
          // マッピング外に配置されないように位置を補正
          final lastDx = min(
              box.size.width - PlayerWidget.size.width, max(0.0, offset.dx));
          final lastDy = min(
              box.size.height - PlayerWidget.size.height, max(0.0, offset.dy));
          model.updateSuspicion(player, Offset(lastDx, lastDy));
        },
      ),
    );
  }
}
