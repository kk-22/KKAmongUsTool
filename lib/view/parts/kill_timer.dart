import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/game_setting.dart';
import 'package:kk_amongus_tool/view/screen/home_screen.dart';
import 'package:provider/provider.dart';

class KillTimer extends StatefulWidget {
  const KillTimer({Key? key}) : super(key: key);

  @override
  State<KillTimer> createState() {
    return _KillTimerState();
  }
}

class _KillTimerState extends State<KillTimer> {
  static const _startSec = -3;

  int _elapsedSec = _startSec;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    final isActive = _timer != null && _timer!.isActive;
    return Container(
      height: HomeScreen.overlayBarHeight,
      color: Colors.white,
      child: Column(
        children: [
          Consumer<GameSetting>(builder: (context, setting, child) {
            final numberOfKills =
                _elapsedSec ~/ setting.coolTimeSec(CoolTimeType.kill);
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
              width: 50,
              color: backgroundColor,
              alignment: Alignment.centerRight,
              child: Text(
                "$_elapsedSec秒",
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            );
          }),
          SizedBox(
            height: 30,
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: isActive
                      ? null
                      : () {
                          _elapsedSec = _startSec;
                          startTimer();
                        },
                  icon: Image.asset(
                    "assets/icon/reload.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    if (isActive) {
                      _timer?.cancel();
                      setState(() {}); // ボタン表示を切り替えるため
                    } else {
                      startTimer();
                    }
                  },
                  icon: Image.asset(
                    isActive ? "assets/icon/pause.png" : "assets/icon/play.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        setState(() {
          _elapsedSec++;
        });
      },
    );
    setState(() {}); // ボタン表示を切り替えるため
  }
}
