import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/game_setting.dart';
import 'package:kk_amongus_tool/View/dialog/map_selector.dart';
import 'package:kk_amongus_tool/View/dialog/name_register.dart';
import 'package:kk_amongus_tool/View/parts/cool_time_list.dart';
import 'package:kk_amongus_tool/View/parts/field_map.dart';
import 'package:kk_amongus_tool/View/parts/kill_timer.dart';
import 'package:kk_amongus_tool/View/parts/player_counter.dart';
import 'package:kk_amongus_tool/View/parts/round_selector.dart';
import 'package:kk_amongus_tool/View/parts/suspicion_mapping.dart';
import 'package:kk_amongus_tool/view_model/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const buttonBarHeight = 50.0;
  static const secondButtonBarHeight = 28.0;

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, model, child) {
      return Stack(
        children: [
          // 各Widgetの上に描画されるように、Y座標の高いWidgetから順に配置
          Container(
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.only(top: buttonBarHeight),
            child: FieldMap(GlobalKey()),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: buttonBarHeight + secondButtonBarHeight),
            child: RoundSelector(model),
          ),
          Padding(
            padding: const EdgeInsets.only(top: buttonBarHeight),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  child: const Text("マップ変更"),
                  onPressed: () async {
                    final String? mapPath = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        return const MapSelector();
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
                        return NameRegister(model);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlayerCounter(model),
              partitionLine(),
              Column(
                children: const [
                  CoolTimeList(CoolTimeType.button, "ボタン：", 10, 60, 5),
                  CoolTimeList(CoolTimeType.kill, "キル：", 10, 60, 2.5),
                ],
              ),
              partitionLine(),
              const KillTimer(),
              partitionLine(),
              Expanded(child: SuspicionMapping()),
            ],
          ),
        ],
      );
    });
  }

  Widget partitionLine() {
    return Container(
      width: 5,
      height: buttonBarHeight,
      color: Colors.white,
      alignment: Alignment.center,
      child: const VerticalDivider(
        width: 1,
        color: Colors.black,
      ),
    );
  }
}
