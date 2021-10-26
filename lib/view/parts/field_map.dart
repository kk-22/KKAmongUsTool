import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/other/route_board.dart';
import 'package:kk_amongus_tool/view/parts/button_history.dart';
import 'package:kk_amongus_tool/view/parts/player_widget.dart';
import 'package:kk_amongus_tool/view/parts/status_changer.dart';
import 'package:kk_amongus_tool/view/screen/home_screen.dart';
import 'package:kk_amongus_tool/view_model/player_view_model.dart';
import 'package:kk_amongus_tool/view_model/round_view_model.dart';
import 'package:kk_amongus_tool/view_model/setting_view_model.dart';
import 'package:provider/provider.dart';

class FieldMap extends StatelessWidget {
  static const topPadding =
      ButtonHistory.widgetHeight - HomeScreen.totalBarHeight;

  final GlobalKey _globalKey;

  const FieldMap(this._globalKey) : super(key: _globalKey);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final mapImage =
          Consumer<SettingViewModel>(builder: (context, value, child) {
        return Container(
            color: Colors.black,
            width: constraints.maxWidth,
            padding: const EdgeInsets.only(top: topPadding + 60),
            alignment: Alignment.centerLeft,
            child: Image.asset(value.mapPath, fit: BoxFit.contain));
      });
      return Consumer2<PlayerViewModel, RoundViewModel>(
          builder: (context, model, round, child) {
        final players = model.survivingPlayers(true);
        List<Widget> list = List.generate(players.length, (index) {
          return ChangeNotifierProvider<Player>.value(
            value: players[index],
            child: MapPlayerIcon(
                index, model, round, _globalKey, constraints.maxWidth),
          );
        });
        list.insert(0, mapImage);
        list.insert(1, const RouteBoard());
        list.add(ChangeNotifierProvider<SelectingColor>.value(
          value: model.selectingColor,
          builder: (context, child) {
            final color = context.watch<SelectingColor>().value;
            if (color == null) {
              return const SizedBox.shrink();
            }
            final player = model.playerOfColor(color);
            var offset =
                player!.offsets[context.read<RoundViewModel>().currentRound];
            final centerDy =
                offset.dx + (PlayerWidget.size.width - StatusChanger.width) / 2;
            return Positioned(
              top: offset.dy + PlayerWidget.size.height,
              left: max(
                  0, min(constraints.maxWidth - StatusChanger.width, centerDy)),
              child: StatusChanger(player),
            );
          },
        ));
        return Stack(
          children: list,
        );
      });
    });
  }
}

class MapPlayerIcon extends StatelessWidget {
  final int index;
  final PlayerViewModel _playerModel;
  final RoundViewModel _roundModel;
  final GlobalKey mapKey;
  final double _maxWidth;

  const MapPlayerIcon(this.index, this._playerModel, this._roundModel,
      this.mapKey, this._maxWidth,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<Player>(context);
    var offset = player.offsets[_roundModel.currentRound];
    if (offset == Offset.zero) {
      // プレイヤー初期位置
      int numberOfLine = index ~/ 5;
      final startDx = _maxWidth - PlayerWidget.size.width * 5;
      offset = Offset(startDx + PlayerWidget.size.width * (index % 5),
          10.0 + 50 * numberOfLine);
      player.offsets[_roundModel.currentRound] = offset;
    }
    return Positioned(
      top: offset.dy,
      left: offset.dx,
      child: Draggable(
        child: PlayerWidget(_roundModel.currentRound, false),
        feedback: Material(
          color: Colors.transparent,
          child: ChangeNotifierProvider<Player>.value(
            value: player,
            child: PlayerWidget(_roundModel.currentRound, true),
          ),
        ),
        data: player.name,
        childWhenDragging: const SizedBox.shrink(),
        onDragStarted: () => _playerModel.cancelSelectingColor(),
        onDragEnd: (details) {
          final box = mapKey.currentContext?.findRenderObject() as RenderBox;
          final offset = box.globalToLocal(details.offset);
          // マップ外に配置されないように位置を補正
          final lastDx = min(
              box.size.width - PlayerWidget.size.width, max(0.0, offset.dx));
          final lastDy = min(box.size.height - PlayerWidget.size.height,
              max(FieldMap.topPadding, offset.dy));
          _playerModel.movePlayer(player, Offset(lastDx, lastDy));
        },
      ),
    );
  }
}
