import 'dart:math';

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
      final player0 = model.playerOfIndex(0);
      if (model.numberOfPlayers() == 0 || player0 == null) {
        return const Text("No player");
      }
      final offset = player0.offsets[model.currentRound];
      return Stack(
        key: globalKey,
        children: [
          FittedBox(
            fit: BoxFit.fitHeight,
            child: Image.asset(model.mapPath),
          ),
          Positioned(
            top: offset.dy,
            left: offset.dx,
            child: Draggable(
              child: PlayerWidget(player0),
              feedback: Material(
                child: PlayerWidget(player0),
              ),
              data: player0.name,
              childWhenDragging: const SizedBox.shrink(),
              onDragEnd: (details) {
                final box =
                    globalKey.currentContext?.findRenderObject() as RenderBox;
                final offset = box.globalToLocal(details.offset);
                // マップ外に配置されないように位置を補正
                final lastDx = min(box.size.width - PlayerWidget.size.width,
                    max(0.0, offset.dx));
                final lastDy = min(box.size.height - PlayerWidget.size.height,
                    max(0.0, offset.dy));
                model.movePlayer(0, Offset(lastDx, lastDy));
              },
            ),
          ),
        ],
      );
    });
  }
}
