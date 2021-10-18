import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KillTimerWidget extends StatefulWidget {
  const KillTimerWidget({Key? key}) : super(key: key);

  @override
  State<KillTimerWidget> createState() {
    return _KillTimerWidgetState();
  }
}

class _KillTimerWidgetState extends State<KillTimerWidget> {
  int _elapsedSec = 0;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    final isActive = _timer != null && _timer!.isActive;
    return Column(
      children: [
        Text(
          "$_elapsedSec秒",
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
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
                        _elapsedSec = 0;
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
