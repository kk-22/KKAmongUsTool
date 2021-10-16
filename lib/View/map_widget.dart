import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/View/player_widget.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey globalKey = GlobalKey();
    return Consumer<HomeViewModel>(builder: (context, model, child) {
      List<Widget> list = List.generate(model.numberOfPlayers(), (index) {
        return playerItem(index, model, globalKey);
      });
      list.insert(0, Image.asset(model.mapPath, fit: BoxFit.contain));

      return Stack(
        key: globalKey,
        children: list,
      );
    });
  }

  Widget playerItem(int index, HomeViewModel model, GlobalKey globalKey) {
    final player = model.playerOfIndex(index);
    if (player == null) {
      return const Text("No player");
    }
    var offset = player.offsets[model.currentRound];
    if (offset == Offset.zero) {
      offset = Offset(10.0 + 50 * index, 30.0);
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
          model.movePlayer(index, Offset(lastDx, lastDy));
        },
      ),
    );
  }
}
