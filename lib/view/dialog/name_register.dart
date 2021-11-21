import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/view_model/player_view_model.dart';
import 'package:kk_amongus_tool/view_model/wnd_view_model.dart';
import 'package:provider/provider.dart';

class NameRegister extends StatefulWidget {
  final PlayerViewModel _playerModel;

  const NameRegister(this._playerModel, {Key? key}) : super(key: key);

  @override
  State<NameRegister> createState() {
    return _NameRegisterState();
  }
}

class _NameRegisterState extends State<NameRegister> {
  static const size = Size(500, 450);
  late List<FieldItem> items;
  late WndViewModel _wndModel;

  @override
  void initState() {
    super.initState();
    _wndModel = context.read<WndViewModel>();
    _wndModel.moveWndToRightDown(size.width.toInt(), size.height.toInt());

    items = PlayerColor.values.map((color) {
      var player = widget._playerModel.playerOfColor(color);
      final controller = TextEditingController(text: player?.name ?? "");
      controller.addListener(() {
        widget._playerModel.changeName(controller.text, color);
        if (controller.text.isEmpty) {
          items[color.index].isMyself = false;
        }
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    items.first.focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final buttonSkipFocus = FocusNode();
    buttonSkipFocus.skipTraversal = true;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height - 40,
        margin: const EdgeInsets.only(bottom: 40),
        // Windowの下部バーとボタンが重ならないようにする
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            SizedBox(
              height: 380,
              child: GridView.count(
                crossAxisCount: 6,
                childAspectRatio: 0.65,
                crossAxisSpacing: 1,
                children: List.generate(PlayerColorEx.count, (index) {
                  return gridChild(items[index]);
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    focusNode: buttonSkipFocus,
                    onPressed: () {
                      var count = widget._playerModel.numberOfPlayers();
                      for (final item in items) {
                        if (item.controller.text.isEmpty) {
                          item.controller.text = "Name";
                          count++;
                          if (15 <= count) {
                            break;
                          }
                        }
                      }
                      backToPrevScreen();
                    },
                    child: const Text("15人登録"),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    focusNode: buttonSkipFocus,
                    onPressed: () {
                      for (var i = 0; i < PlayerColor.values.length; i++) {
                        final item = items[i];
                        if (!item.isMyself) item.controller.clear();
                      }
                    },
                    child: const Text("全解除"),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "プレイヤー数：${widget._playerModel.numberOfPlayers()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      backToPrevScreen();
                    },
                    child: const Text("閉じる"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget gridChild(FieldItem item) {
    final skipFocus = FocusNode();
    skipFocus.skipTraversal = true;
    final isEmpty = item.controller.text.isEmpty;
    return Column(
      children: [
        SizedBox(
          height: 22,
          child: TextField(
            controller: item.controller,
            focusNode: item.focusNode,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            color: isEmpty ? Colors.grey : Colors.transparent,
            width: MediaQuery.of(context).size.width,
            child: IconButton(
              focusNode: skipFocus,
              onPressed: () {
                if (isEmpty) {
                  item.focusNode.requestFocus();
                  item.controller.text = "Name";
                } else {
                  item.controller.clear();
                  item.isMyself = false;
                }
              },
              icon: Image.asset(
                item.color.imageName,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
          child: isEmpty
              ? const SizedBox.shrink()
              : FittedBox(
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
        ),
      ],
    );
  }

  void backToPrevScreen() {
    Navigator.of(context).pop();
    _wndModel.expandWnd();
  }
}

class FieldItem {
  final PlayerColor color;
  final TextEditingController controller;
  final focusNode = FocusNode();
  var isMyself = false;

  FieldItem(this.color, this.controller);
}
