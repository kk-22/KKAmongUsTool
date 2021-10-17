import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';

class PlayerCounter extends StatelessWidget {
  final HomeViewModel viewModel;

  const PlayerCounter(this.viewModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counts = viewModel.numberOfPlayerEachStatus();
    return Container(
      width: 180,
      color: Colors.green,
      child: Center(
        child: Text(
          "生:${counts[0]}　殺:${counts[1]}　追:${counts[2]}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
