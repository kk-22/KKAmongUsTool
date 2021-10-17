import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';

class NameRegistrationScreen extends StatefulWidget {
  final HomeViewModel viewModel;

  const NameRegistrationScreen(this.viewModel, {Key? key}) : super(key: key);

  @override
  State<NameRegistrationScreen> createState() {
    return _NameRegistrationScreenState();
  }
}

class _NameRegistrationScreenState extends State<NameRegistrationScreen> {
  late List<FieldItem> items;

  @override
  void initState() {
    super.initState();
    items = PlayerColor.values.map((color) {
      var player = widget.viewModel.playerOfColor(color);
      final controller = TextEditingController(text: player?.name ?? "");
      controller.addListener(() {
        widget.viewModel.changeName(controller.text, color);
        setState(() {});
      });
      final item = FieldItem(color, controller);
      item.focusNode.addListener(() {
        if (item.focusNode.hasFocus) {
          controller.selection = TextSelection(
              baseOffset: 0, extentOffset: controller.text.length);
        }
      });
      return item;
    }).toList();
  }

  @override
  void dispose() {
    for (var item in items) {
      item.controller.dispose();
      item.focusNode.dispose();
    }
    super.dispose();
  }

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
            crossAxisSpacing: 1,
            children: List.generate(PlayerColorExtension.count, (index) {
              return gridChild(items[index]);
            }),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            "プレイヤー数：${widget.viewModel.numberOfPlayers()}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget gridChild(FieldItem item) {
    return Column(
      children: [
        SizedBox(
          height: 35,
          width: 90,
          child: TextField(
            controller: item.controller,
            focusNode: item.focusNode,
            decoration: const InputDecoration(
              hintText: "name",
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          color:
              item.controller.text.isEmpty ? Colors.grey : Colors.transparent,
          height: 65,
          width: MediaQuery.of(context).size.width,
          child: IconButton(
            onPressed: () {
              if (item.controller.text.isEmpty) {
                item.focusNode.requestFocus();
                item.controller.text = "dummy";
              } else {
                item.controller.clear();
              }
            },
            icon: Image.asset(
              item.color.imageName,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

class FieldItem {
  final PlayerColor color;
  final TextEditingController controller;
  final focusNode = FocusNode();

  FieldItem(this.color, this.controller);
}
