import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/view/parts/player_widget.dart';
import 'package:kk_amongus_tool/view/screen/home_screen.dart';
import 'package:kk_amongus_tool/view_model/player_view_model.dart';
import 'package:kk_amongus_tool/view_model/round_view_model.dart';
import 'package:kk_amongus_tool/view_model/timer_view_model.dart';
import 'package:kk_amongus_tool/view_model/wnd_view_model.dart';
import 'package:provider/provider.dart';

class SuspicionChart extends StatelessWidget {
  const SuspicionChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return ElevatedButton(
        onPressed: () {
          context.read<WndViewModel>().expandWnd();
          final timerModel = context.read<TimerViewModel>();
          timerModel.didExpandApp();
        },
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          padding: const EdgeInsets.all(0),
          primary: Colors.red.withOpacity(0),
        ),
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
      if (players.isEmpty) return const SizedBox.shrink();
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
                final score = player.totalSuspicionScore;
                if (1 <= score) {
                  color = Colors.white; // ?????????????????????
                } else if (mostLowScore == 0) {
                  color = Colors.grey; // ???????????????
                } else if (mostLowScore == score) {
                  color = Colors.black; // ???????????????
                } else {
                  var ratio = max(0.1, (score / mostLowScore).abs());
                  if (-10 < mostLowScore) {
                    // ???????????????????????????????????????????????????
                    ratio = max(0.1, ratio - 0.2);
                  }
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
