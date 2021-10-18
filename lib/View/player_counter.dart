import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/View/home_screen.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';

class PlayerCounter extends StatelessWidget {
  final HomeViewModel viewModel;

  const PlayerCounter(this.viewModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counts = viewModel.numberOfPlayerEachStatus();
    return SizedBox(
      height: HomeScreen.buttonBarHeight,
      width: 150,
      child: Center(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
            ),
            children: [
              const TextSpan(
                text: "生:",
              ),
              TextSpan(
                text: "${counts[0]}",
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(
                text: " 殺:",
              ),
              TextSpan(
                text: "${counts[1]}",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(
                text: " 追:",
              ),
              TextSpan(
                text: "${counts[2]}",
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
