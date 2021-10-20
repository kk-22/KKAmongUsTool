import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/model/moving_route.dart';
import 'package:kk_amongus_tool/view/screen/home_screen.dart';
import 'package:provider/provider.dart';

class RouteController extends StatelessWidget {
  const RouteController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final route = Provider.of<MovingRoute>(context, listen: false);
    return Container(
      height: HomeScreen.buttonBarHeight,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              constraints: const BoxConstraints(),
              onPressed: () => route.clear(),
              icon: Image.asset("assets/icon/trash_box.png")),
          IconButton(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              constraints: const BoxConstraints(),
              onPressed: () => route.undo(),
              icon: Image.asset("assets/icon/left_arrow.png")),
          IconButton(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              constraints: const BoxConstraints(),
              onPressed: () => route.redo(),
              icon: Image.asset("assets/icon/right_arrow.png")),
        ],
      ),
    );
  }
}
