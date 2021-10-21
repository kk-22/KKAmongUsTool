import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/game_setting.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/model/round.dart';
import 'package:kk_amongus_tool/other/route_board.dart';
import 'package:kk_amongus_tool/view/parts/player_widget.dart';
import 'package:kk_amongus_tool/view/parts/suspicion_mapping.dart';
import 'package:kk_amongus_tool/view/screen/home_screen.dart';
import 'package:kk_amongus_tool/view_model/home_view_model.dart';
import 'package:provider/provider.dart';

class FieldMap extends StatelessWidget {
  final _topPadding = SuspicionMapping.widgetHeight - HomeScreen.totalBarHeight;

  final GlobalKey _globalKey;

  FieldMap(this._globalKey) : super(key: _globalKey);

  @override
  Widget build(BuildContext context) {
    return Consumer3<HomeViewModel, Round, GameSetting>(
        builder: (context, model, round, setting, child) {
      final players = model.survivingPlayers(true);
      List<Widget> list = List.generate(players.length, (index) {
        return playerItem(players[index], index, model, round, _globalKey);
      });
      list.insert(
          0,
          Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: _topPadding, right: 40),
              alignment: Alignment.centerLeft,
              child: Image.asset(setting.mapPath, fit: BoxFit.contain)));
      list.insert(1, const RouteBoard());
      return Stack(
        children: list,
      );
    });
  }

  Widget playerItem(Player player, int index, HomeViewModel model, Round round,
      GlobalKey globalKey) {
    var offset = player.offsets[round.currentRound];
    if (offset == Offset.zero) {
      // プレイヤー初期位置
      int numberOfLine = index ~/ 5;
      offset = Offset(10.0 + 50 * (index % 5), 10.0 + 50 * numberOfLine);
    }
    return Positioned(
      top: offset.dy,
      left: offset.dx,
      child: Draggable(
        child: PlayerWidget(player, model, round.currentRound, false),
        feedback: Material(
          color: Colors.transparent,
          child: PlayerWidget(player, model, round.currentRound, true),
        ),
        data: player.name,
        childWhenDragging: const SizedBox.shrink(),
        onDragEnd: (details) {
          final box = globalKey.currentContext?.findRenderObject() as RenderBox;
          final offset = box.globalToLocal(details.offset);
          // マップ外に配置されないように位置を補正
          final lastDx = min(
              box.size.width - PlayerWidget.size.width, max(0.0, offset.dx));
          final lastDy = min(box.size.height - PlayerWidget.size.height,
              max(_topPadding, offset.dy));
          model.movePlayer(player, Offset(lastDx, lastDy));
        },
      ),
    );
  }
}
