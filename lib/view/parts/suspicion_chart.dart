import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/util/hwnd_util.dart';
import 'package:kk_amongus_tool/view/parts/player_widget.dart';
import 'package:kk_amongus_tool/view/screen/home_screen.dart';
import 'package:kk_amongus_tool/view_model/player_view_model.dart';
import 'package:kk_amongus_tool/view_model/round_view_model.dart';
import 'package:kk_amongus_tool/view_model/timer_view_model.dart';
import 'package:provider/provider.dart';

class SuspicionChart extends StatelessWidget {
  const SuspicionChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return TextButton(
        onPressed: () {
          HwndUtil.expandWnd();
          final timerModel = context.read<TimerViewModel>();
          timerModel.didExpandApp();
        },
        child: Container(
          height: HomeScreen.overlayBarHeight,
          color: Colors.white,
          alignment: Alignment.centerLeft,
          child: headerChart(constraints.maxWidth),
        ),
      );
    });
  }

  Widget headerChart(double parentWidth) {
    return Consumer<PlayerViewModel>(builder: (context, model, child) {
      var players = model.playersWithScore();
      players.sort(
          (a, b) => a.totalSuspicionScore.compareTo(b.totalSuspicionScore));
      final mostLowScore = players.first.totalSuspicionScore;
      return FittedBox(
        child: Row(
          children: List.generate(players.length, (index) {
            return ChangeNotifierProvider<Player>.value(
              value: players[index],
              builder: (context, child) {
                final player = Provider.of<Player>(context, listen: false);
                Color color;
                if (2 <= player.totalSuspicionScore) {
                  color = Colors.white;
                } else if (1 == player.totalSuspicionScore) {
                  color = Colors.black12;
                } else if (0 == player.totalSuspicionScore) {
                  color = Colors.black26;
                } else {
                  double ratio = min(
                      1.0,
                      max(0.0,
                          ((player.totalSuspicionScore) / mostLowScore).abs()));
                  color = Color.fromARGB((ratio * 255).toInt(), 0, 0, 0);
                }
                return Container(
                    color: color,
                    child: const PlayerWidget(RoundViewModel.maxRound, true));
              },
            );
          }),
        ),
      );
    });
  }
}
