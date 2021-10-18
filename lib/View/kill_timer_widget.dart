import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KillTimerWidget extends StatefulWidget {
  const KillTimerWidget({Key? key}) : super(key: key);

  @override
  State<KillTimerWidget> createState() {
    return _KillTimerWidgetState();
  }
}

class _KillTimerWidgetState extends State<KillTimerWidget> {
  DateTime _time = DateTime.utc(0, 0, 0);
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    final isActive = _timer != null && _timer!.isActive;
    return Column(
      children: [
        Text(
          DateFormat.ms().format(_time),
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
                        _time = DateTime.utc(0, 0, 0);
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
          _time = _time.add(const Duration(seconds: 1));
        });
      },
    );
    setState(() {}); // ボタン表示を切り替えるため
  }
}
