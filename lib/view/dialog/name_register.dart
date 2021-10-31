import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/view_model/player_view_model.dart';

class NameRegister extends StatefulWidget {
  final PlayerViewModel _playerModel;

  const NameRegister(this._playerModel, {Key? key}) : super(key: key);

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
      var player = widget._playerModel.playerOfColor(color);
      final controller = TextEditingController(text: player?.name ?? "");
      controller.addListener(() {
        widget._playerModel.changeName(controller.text, color);
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
          width: 660,
          height: 410,
          child: GridView.count(
            crossAxisCount: 6,
            childAspectRatio: 0.85,
            crossAxisSpacing: 1,
            children: List.generate(PlayerColorEx.count, (index) {
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
                "プレイヤー数：${widget._playerModel.numberOfPlayers()}",
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
    final skipFocus = FocusNode();
    skipFocus.skipTraversal = true;
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
            focusNode: skipFocus,
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
                focusNode: skipFocus,
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
                          widget._playerModel
                              .changeMySelf(nextColor, prevColor);
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
                      var count = widget._playerModel.numberOfPlayers();
                      for (final item in items) {
                        if (item.controller.text.isEmpty) {
                          item.controller.text = "デバッグ";
                          count++;
                          if (15 <= count) {
                            break;
                          }
                        }
                      }
                      Navigator.pop(context);
                      Navigator.pop(context); // プレイヤー登録ダイアログも閉じる
                    },
                    child: const Text("15人登録"),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      for (var i = 0; i < PlayerColor.values.length; i++) {
                        final item = items[i];
                        if (!item.isMyself) item.controller.clear();
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
