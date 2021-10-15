import 'package:flutter/material.dart';

class MapSelectionDialog extends StatelessWidget {
  static const _maps = [
    "TheSkeld",
    "MIRA HQ",
    "Polus",
    "TheAirship",
  ];
  static final defaultMapPath = _mapPath(_maps.last);

  static String _mapPath(name) => "assets/map/$name.png";

  const MapSelectionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("マップ変更"),
      children: List.generate(_maps.length, (index) {
        return SimpleDialogOption(
          onPressed: () => Navigator.pop(context, _mapPath(_maps[index])),
          child: Text(_maps[index]),
        );
      }),
    );
  }
}
