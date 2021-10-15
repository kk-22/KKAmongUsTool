import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';

class PlayerWidget extends StatelessWidget {
  // 幅は画像の幅。名前用Textの幅は可変。
  static const Size size = Size(40, _nameHeight + _charHeight);
  static const double _nameHeight = 23;
  static const double _charHeight = 30;

  final Player player;

  const PlayerWidget(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: _nameHeight,
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(color: Colors.black),
          ),
          child: Text(
            player.name,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        Image.asset(
          player.color.imageName,
          fit: BoxFit.contain,
          height: _charHeight,
        ),
      ],
    );
  }
}
