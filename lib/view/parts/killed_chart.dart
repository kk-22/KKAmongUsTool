import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/view/parts/player_widget.dart';
import 'package:kk_amongus_tool/view/screen/home_screen.dart';
import 'package:kk_amongus_tool/view_model/player_view_model.dart';
import 'package:kk_amongus_tool/view_model/round_view_model.dart';
import 'package:provider/provider.dart';

class KilledChart extends StatelessWidget {
  const KilledChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerModel = Provider.of<PlayerViewModel>(context);
    final killedPlayers = playerModel.allPlayer
        .where((element) => element.status == PlayerStatus.killed)
        .toList();
    killedPlayers.sort((a, b) => a.diedRound!.compareTo(b.diedRound!));
    final roundModel = Provider.of<RoundViewModel>(context, listen: false);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: killedPlayers.length,
        /*
        エラーの抑制に必要
        "The provided ScrollController is currently attached to more than one ScrollPosition."
         */
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ChangeNotifierProvider<Player>.value(
            value: killedPlayers[index],
            builder: (context, child) {
              final killedPlayer = Provider.of<Player>(context);
              final killedRound = killedPlayer.diedRound!;
              final killers = killersOf(killedPlayer, playerModel);
              return Row(
                children: [
                  const SizedBox(
                      width: 40,
                      child: PlayerWidget(RoundViewModel.maxRound, true)),
                  SizedBox(
                    width: 20,
                    child: TextButton(
                      onPressed: () {
                        roundModel.changeRound(killedRound);
                      },
                      child: Text("${killedRound + 1}"),
                    ),
                  ),
                  SizedBox(
                    width: HomeScreen.rightAreaWidth - 60,
                    height: PlayerWidget.size.height,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: killers.length,
                      itemBuilder: (context, index) {
                        final killer = killers[index];
                        final isWhite = killedPlayer.caseOfDeath!.whitePlayers
                            .contains(killer);

                        return SizedBox(
                          width: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              killedPlayer.toggleWhiteList(killer);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              primary: isWhite ? Colors.white : Colors.black,
                            ),
                            child: ChangeNotifierProvider<Player>.value(
                              value: killer,
                              child: const PlayerWidget(
                                  RoundViewModel.maxRound, true),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  killersOf(Player killedPlayer, PlayerViewModel playerModel) {
    final killers = playerModel.allPlayer.where((player) {
      if (player.status == PlayerStatus.killed) return false;
      if (player.diedRound != null &&
          player.diedRound! < killedPlayer.diedRound!) {
        // キルより前に追放されたインポスターを除外
        return false;
      }
      return true;
    }).toList();
    killers.sort((a, b) {
      if (killedPlayer.caseOfDeath!.whitePlayers.contains(a)) return 1;
      if (killedPlayer.caseOfDeath!.whitePlayers.contains(b)) return -1;
      if (a.status == PlayerStatus.ejected) return -1;
      if (b.status == PlayerStatus.ejected) return 1;
      return 0;
    });
    return killers;
  }
}
