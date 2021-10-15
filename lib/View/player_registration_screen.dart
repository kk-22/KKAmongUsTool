import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';

class PlayerRegistrationScreen extends StatelessWidget {
  final HomeViewModel viewModel;

  const PlayerRegistrationScreen(this.viewModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        SizedBox(
          width: 900,
          height: 200,
          child: GridView.count(
            crossAxisCount: 9,
            children: List.generate(PlayerColorExtension.count, (index) {
              return gridItem(index);
            }),
          ),
        ),
        const SizedBox(height: 50),
        SizedBox(
          width: 200,
          child: ElevatedButton(
            child: const Text('全名前リセット'),
            onPressed: () {
              viewModel.clearPlayerName();
            },
          ),
        ),
      ],
    );
  }

  Widget gridItem(int index) {
    final color = PlayerColor.values[index];
    var player = viewModel.playerOfColor(color);
    final controller = TextEditingController(text: player?.name ?? "");
    controller.addListener(() {
      viewModel.changeName(controller.text, color);
    });
    return Column(
      children: [
        SizedBox(
          height: 25,
          width: 80,
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "name",
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 65,
          child: Image.asset(
            color.imageName,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
