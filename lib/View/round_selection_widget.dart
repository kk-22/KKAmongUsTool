import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/Model/player.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';

class RoundSelectionWidget extends StatefulWidget {
  final HomeViewModel _viewModel;

  const RoundSelectionWidget(this._viewModel, {Key? key}) : super(key: key);

  @override
  State<RoundSelectionWidget> createState() {
    return _RoundSelectionWidgetState();
  }
}

class _RoundSelectionWidgetState extends State<RoundSelectionWidget> {
  var _isExpanding = false;

  static const _minHeight = 28.0;
  static const _gridItemHeight = 30.0;
  static const _gridHeight = _gridItemHeight * 3;
  static const _maxHeight = _minHeight + _gridHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: _isExpanding ? _maxHeight : _minHeight,
      width: 150,
      child: GestureDetector(
        child: MouseRegion(
          onEnter: (_) => setState(() {
            _isExpanding = true;
          }),
          onExit: (_) => setState(() {
            _isExpanding = false;
          }),
          child: Column(
            children: [
              FittedBox(
                fit: BoxFit.fill,
                child: Text(
                  "ラウンド：${widget._viewModel.currentRound + 1}",
                  style: TextStyle(
                    decoration: _isExpanding ? TextDecoration.underline : null,
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),
              ),
              Visibility(
                visible: _isExpanding,
                child: SizedBox(height: _gridHeight, child: roundList()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget roundList() {
    return GridView.count(
      crossAxisCount: Player.maxRound ~/ 3,
      children: List.generate(Player.maxRound, (index) {
        return SizedBox(
          height: _gridItemHeight,
          child: TextButton(
            child: Text(
              "${index + 1}",
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
            onPressed: () {
              widget._viewModel.changeRound(index);
            },
          ),
        );
      }),
    );
  }
}
