import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';

class PlayerWidget extends StatelessWidget {
  static const Size size = Size(40, 70);

  final Player player;

  const PlayerWidget(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            player.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Image.asset(player.color.imageName),
      ],
    );
  }
}
