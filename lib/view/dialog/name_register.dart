import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';
import 'package:kk_amongus_tool/view_model/home_view_model.dart';

class NameRegister extends StatefulWidget {
  final HomeViewModel viewModel;

  const NameRegister(this.viewModel, {Key? key}) : super(key: key);

  @override
  State<NameRegister> createState() {
    return _NameRegisterState();
  }
}

class _NameRegisterState extends State<NameRegister> {
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
      item.isMyself = player?.isMyself ?? false;
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
          height: 410,
          child: GridView.count(
            crossAxisCount: 6,
            childAspectRatio: 0.85,
            crossAxisSpacing: 1,
            children: List.generate(PlayerColorExtension.count, (index) {
              return gridChild(items[index]);
            }),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 100,
              child: debugButton(),
            ),
            Center(
              child: Text(
                "プレイヤー数：${widget.viewModel.numberOfPlayers()}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              width: 100,
            ),
          ],
        ),
      ],
    );
  }

  Widget gridChild(FieldItem item) {
    final iconFocus = FocusNode();
    iconFocus.skipTraversal = true;
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
            focusNode: iconFocus,
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
        SizedBox(
          height: 20,
          child: Row(
            children: [
              const Text("自キャラ"),
              Switch(
                value: item.isMyself,
                onChanged: item.controller.text.isEmpty
                    ? null
                    : (bool value) {
                        setState(() {
                          PlayerColor? prevColor, nextColor;
                          if (value) {
                            nextColor = item.color;
                            final prevItem = items.firstWhereOrNull(
                                (element) => element.isMyself);
                            prevItem?.isMyself = false;
                            prevColor = prevItem?.color;
                          } else {
                            prevColor = item.color;
                          }
                          item.isMyself = value;
                          widget.viewModel.changeMySelf(nextColor, prevColor);
                        });
                      },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget debugButton() {
    return ElevatedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: const Text("デバッグ"),
                children: <Widget>[
                  // コンテンツ領域
                  SimpleDialogOption(
                    onPressed: () {
                      for (var i = 0; i < 15; i++) {
                        final item = items[i];
                        if (item.controller.text.isEmpty) {
                          item.controller.text = "デバッグ";
                        }
                      }
                      Navigator.pop(context);
                    },
                    child: const Text("15人登録"),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      for (var i = 0; i < 15; i++) {
                        final item = items[i];
                        item.controller.clear();
                      }
                      Navigator.pop(context);
                    },
                    child: const Text("全解除"),
                  ),
                ],
              );
            });
      },
      child: const Text("デバッグ"),
    );
  }
}

class FieldItem {
  final PlayerColor color;
  final TextEditingController controller;
  final focusNode = FocusNode();
  var isMyself = false;

  FieldItem(this.color, this.controller);
}
