import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';
import 'package:kk_amongus_tool/View/player_widget.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatelessWidget {
  final GlobalKey _globalKey;
  const MapWidget(this._globalKey) : super(key: _globalKey);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, model, child) {
      final players = model.survivingPlayers();
      List<Widget> list = List.generate(players.length, (index) {
        return playerItem(players[index], index, model, _globalKey);
      });
      list.insert(0, Image.asset(model.mapPath, fit: BoxFit.contain));

      return Stack(
        children: list,
      );
    });
  }

  Widget playerItem(Player player, int index, HomeViewModel model, GlobalKey globalKey) {
    var offset = player.offsets[model.currentRound];
    if (offset == Offset.zero) {
      offset = Offset(10.0 + 50 * index, 580.0);
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
          final box = globalKey.currentContext?.findRenderObject() as RenderBox;
          final offset = box.globalToLocal(details.offset);
          // マップ外に配置されないように位置を補正
          final lastDx = min(
              box.size.width - PlayerWidget.size.width, max(0.0, offset.dx));
          final lastDy = min(
              box.size.height - PlayerWidget.size.height, max(0.0, offset.dy));
          model.movePlayer(player, Offset(lastDx, lastDy));
        },
      ),
    );
  }
}
