import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/View/map_widget.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';
import 'package:kk_amongus_tool/util/hwnd_util.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, model, child) {
      return Center(
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  child: const Text('clearボタン'),
                  onPressed: () {
                    model.clearPlayers();
                  },
                ),
                ElevatedButton(
                  child: const Text('プレイヤー登録'),
                  onPressed: () {
                    final hwnd = HwndUtil.findHwnd("Chrome_WidgetWin_1");
                    HwndUtil.captureImage(hwnd);
                  },
                ),
              ],
            ),
            const Expanded(
              child: SizedBox(
                width: 1000,
                child: MapWidget(),
              ),
            ),
          ],
        ),
      );
    });
  }
}
