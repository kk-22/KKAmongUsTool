import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/view/screen/home_screen.dart';
import 'package:kk_amongus_tool/view_model/setting_view_model.dart';
import 'package:kk_amongus_tool/view_model/timer_view_model.dart';
import 'package:provider/provider.dart';

class KillTimer extends StatelessWidget {
  const KillTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timerModel = context.read<TimerViewModel>();
    return SizedBox(
      height: HomeScreen.overlayBarHeight,
      width: 50,
      child: Stack(
        children: [
          Consumer2<TimerViewModel, SettingViewModel>(
              builder: (context, timerModel, settingModel, child) {
            final numberOfKills = timerModel.elapsedSec ~/
                settingModel.coolTimeSec(CoolTimeType.kill);
            Color backgroundColor = Colors.white;
            switch (numberOfKills) {
              case 0:
                break;
              case 1:
                backgroundColor = Colors.yellow;
                break;
              default:
                backgroundColor = Colors.red;
                break;
            }
            return Container(
              color: backgroundColor,
              alignment: Alignment.centerRight,
              child: Text(
                "${timerModel.elapsedSec}秒",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => timerModel.addSec(-5),
                  child: const SizedBox.shrink(),
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: Colors.red.withOpacity(0),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => timerModel.addSec(5),
                  child: const SizedBox.shrink(),
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: Colors.red.withOpacity(0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
