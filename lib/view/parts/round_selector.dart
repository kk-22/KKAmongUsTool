import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/view_model/player_view_model.dart';
import 'package:kk_amongus_tool/view_model/round_view_model.dart';
import 'package:provider/provider.dart';

class RoundSelector extends StatefulWidget {
  const RoundSelector({Key? key}) : super(key: key);

  @override
  State<RoundSelector> createState() {
    return _RoundSelectorState();
  }
}

class _RoundSelectorState extends State<RoundSelector> {
  var _isExpanding = false;

  static const _minHeight = 28.0;
  static const _gridItemHeight = 30.0;

  @override
  Widget build(BuildContext context) {
    final roundModel = Provider.of<RoundViewModel>(context);
    final numberOfLine = min(3, ((roundModel.lastRound + 1) ~/ 5 + 1));
    final double gridHeight = _isExpanding ? _gridItemHeight * numberOfLine : 0;
    return Container(
      color: Colors.white,
      height: _minHeight + gridHeight,
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
                    "ラウンド：${roundModel.currentRound + 1}",
                    style: TextStyle(
                      decoration:
                          _isExpanding ? TextDecoration.underline : null,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              if (_isExpanding)
                SizedBox(height: gridHeight, child: roundList(roundModel)),
            ],
          ),
        ),
      ),
    );
  }

  Widget roundList(RoundViewModel roundModel) {
    final count = min(roundModel.lastRound + 2, RoundViewModel.maxRound);
    return GridView.count(
      crossAxisCount: RoundViewModel.maxRound ~/ 3,
      children: List.generate(count, (index) {
        final isSelected = roundModel.currentRound == index;
        return SizedBox(
          height: _gridItemHeight,
          child: TextButton(
            child: Text(
              "${index + 1}",
              style: TextStyle(
                color: (isSelected) ? Colors.white : Colors.blue,
                fontSize: (9 <= index) ? 12 : 14,
              ),
            ),
            style: (isSelected)
                ? TextButton.styleFrom(backgroundColor: Colors.blue)
                : TextButton.styleFrom(),
            onPressed: () {
              context.read<PlayerViewModel>().cancelSelectingColor();
              roundModel.changeRound(index);
            },
          ),
        );
      }),
    );
  }
}
