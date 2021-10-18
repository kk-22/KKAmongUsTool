import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/View/kill_timer_widget.dart';
import 'package:kk_amongus_tool/View/map_widget.dart';
import 'package:kk_amongus_tool/View/player_counter.dart';
import 'package:kk_amongus_tool/View/round_selection_widget.dart';
import 'package:kk_amongus_tool/View/suspicion_graph_widget.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';
import 'package:kk_amongus_tool/dialog/map_selection_dialog.dart';
import 'package:provider/provider.dart';

import '../dialog/name_registration_screen.dart';

class HomeScreen extends StatelessWidget {
  static const fixedAreaHeight = 50.0;

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, model, child) {
      return Stack(
        children: [
          SizedBox(
            height: fixedAreaHeight,
            child: Row(
              children: [
                PlayerCounter(model),
                const SizedBox(
                  width: 5,
                ),
                const KillTimerWidget(),
                const SizedBox(
                  width: 5,
                ),
                SuspicionGraphWidget(model),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.only(top: fixedAreaHeight),
            child: MapWidget(GlobalKey()),
          ),
          Padding(
            padding: const EdgeInsets.only(top: fixedAreaHeight),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  child: const Text("マップ変更"),
                  onPressed: () async {
                    final String? mapPath = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        return const MapSelectionDialog();
                      },
                    );
                    if (mapPath != null) {
                      model.changeMap(mapPath);
                    }
                  },
                ),
                ElevatedButton(
                  child: const Text("位置リセット"),
                  onPressed: () {
                    model.clearPlayerInfo();
                  },
                ),
                ElevatedButton(
                  child: const Text("プレイヤー登録"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return NameRegistrationScreen(model);
                      },
                    );
                  },
                ),
                RoundSelectionWidget(model),
              ],
            ),
          ),
        ],
      );
    });
  }
}
