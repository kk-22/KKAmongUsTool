import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/game_setting.dart';
import 'package:kk_amongus_tool/View/home_screen.dart';
import 'package:provider/provider.dart';

class CoolTimeList extends StatefulWidget {
  final CoolTimeType type;
  final String title;
  final int min;
  final int max;
  final double increment;

  const CoolTimeList(this.type, this.title, this.min, this.max, this.increment,
      {Key? key})
      : super(key: key);

  @override
  State<CoolTimeList> createState() {
    return _CoolTimeListState();
  }
}

class _CoolTimeListState extends State<CoolTimeList> {
  var _isExpanding = false;

  static const _minHeight = HomeScreen.buttonBarHeight / 2;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<GameSetting>(context, listen: false);
    return Container(
      color: Colors.white,
      width: 85,
      child: GestureDetector(
        child: MouseRegion(
          onEnter: (_) => setState(() {
            _isExpanding = true;
          }),
          onExit: (_) => setState(() {
            _isExpanding = false;
          }),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: _minHeight,
                child: Text(
                  "${widget.title}${setting.coolTimeSec(widget.type)}秒",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 15,
                    decoration:
                        _isExpanding ? TextDecoration.underline : null,
                    color: Colors.blue,
                  ),
                ),
              ),
              if (_isExpanding) valueList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget valueList() {
    int count = (widget.max - widget.min) ~/ widget.increment + 1;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, index) {
        final value = widget.min + (widget.increment * index).toInt();
        return SizedBox(
          child: TextButton(
            child: Text(
              "$value",
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            onPressed: () {
              final setting = Provider.of<GameSetting>(context, listen: false);
              setting.updateCoolTimeSec(widget.type, value);
              setState(() {});
            },
          ),
        );
      },
    );
  }
}
