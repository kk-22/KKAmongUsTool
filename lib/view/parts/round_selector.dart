import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:kk_amongus_tool/view_model/home_view_model.dart';

class RoundSelector extends StatefulWidget {
  final HomeViewModel _viewModel;

  const RoundSelector(this._viewModel, {Key? key}) : super(key: key);

  @override
  State<RoundSelector> createState() {
    return _RoundSelectorState();
  }
}

class _RoundSelectorState extends State<RoundSelector> {
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
      width: 130,
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
              SizedBox(
                height: _minHeight,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Text(
                    "ラウンド：${widget._viewModel.currentRound + 1}",
                    style: TextStyle(
                      decoration: _isExpanding ? TextDecoration.underline : null,
                      color: Colors.blue,
                    ),
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
                fontSize: 9,
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
