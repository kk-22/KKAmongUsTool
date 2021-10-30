import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/view/screen/home_screen.dart';
import 'package:kk_amongus_tool/view_model/setting_view_model.dart';
import 'package:provider/provider.dart';

class CoolTimeList extends StatelessWidget {
  final CoolTimeType type;
  final String title;
  final int min;
  final int max;
  final double increment;

  static const _minHeight = HomeScreen.overlayBarHeight / 2;

  const CoolTimeList(this.type, this.title, this.min, this.max, this.increment,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<SettingViewModel>(context);
    return Container(
      color: Colors.white,
      width: 85,
      height: _minHeight,
      child: TextButton(
        onPressed: () async {
          final int? value = await showDialog<int>(
            context: context,
            builder: (context) {
              int count = (max - min) ~/ increment + 1;
              return SimpleDialog(
                title: Text(title),
                children: List.generate(count, (index) {
                  final value = min + (increment * index).toInt();
                  return SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, value),
                    child: Text("$value"),
                  );
                }),
              );
            },
          );
          if (value != null) {
            final setting = context.read<SettingViewModel>();
            setting.updateCoolTimeSec(type, value);
          }
        },
        child: SizedBox(
          width: 85,
          child: Text(
            "$title：${setting.coolTimeSec(type)}s",
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
