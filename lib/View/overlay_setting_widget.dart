import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/game_setting.dart';
import 'package:kk_amongus_tool/View/cool_time_list.dart';

class OverlaySettingWidget extends StatelessWidget {
  const OverlaySettingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CoolTimeList(CoolTimeType.button, "ボタン：", 10, 60, 5),
        CoolTimeList(CoolTimeType.kill, "　キル：", 10, 60, 5),
      ],
    );
  }
}
