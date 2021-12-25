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
                  onPressed: () => didTapButton(context, false),
                  onLongPress: () => didLongTapButton(context),
                  child: const SizedBox.shrink(),
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: Colors.red.withOpacity(0),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => didTapButton(context, true),
                  onLongPress: () => didLongTapButton(context),
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

  void didTapButton(BuildContext context, bool isRight) {
    final timerModel = context.read<TimerViewModel>();
    if (timerModel.isActiveTimer()) {
      timerModel.addSec(isRight ? 5 : -5);
      return;
    }
    showDialog(
      context: context,
      builder: (_) {
        final logSecs = timerModel.elapsedLogs;
        return AlertDialog(
          title: const Text("過去のキルタイマー"),
          content: SingleChildScrollView(
            child: ListBody(
              children: List.generate(logSecs.length, (index) {
                return Text(logSecs[index]);
              }),
            ),
          ),
        );
      },
    );
  }

  void didLongTapButton(BuildContext context) {
    final timerModel = context.read<TimerViewModel>();
    timerModel.restartTimer();
  }
}
