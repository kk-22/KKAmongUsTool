import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';

class NameRegistrationScreen extends StatelessWidget {
  final HomeViewModel viewModel;

  const NameRegistrationScreen(this.viewModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        SizedBox(
          width: 900,
          height: 250,
          child: GridView.count(
            crossAxisCount: 9,
            childAspectRatio: 0.9,
            children: List.generate(PlayerColorExtension.count, (index) {
              return gridItem(index);
            }),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            "プレイヤー数：${viewModel.numberOfPlayers()}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
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
          height: 35,
          width: 100,
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
