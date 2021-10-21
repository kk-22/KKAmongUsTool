import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/view/screen/home_screen.dart';
import 'package:kk_amongus_tool/view_model/home_view_model.dart';
import 'package:provider/provider.dart';

class PlayerCounter extends StatelessWidget {
  const PlayerCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: HomeScreen.overlayBarHeight,
      width: 150,
      color: Colors.white,
      alignment: Alignment.center,
      child: Consumer<HomeViewModel>(builder: (context, model, child) {
        final counts = model.numberOfPlayerEachStatus();
        return RichText(
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
        );
      }),
    );
  }
}
