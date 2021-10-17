import 'package:flutter/material.dart';
import 'package:kk_amongus_tool/View/map_widget.dart';
import 'package:kk_amongus_tool/View/round_selection_widget.dart';
import 'package:kk_amongus_tool/ViewModel/home_view_model.dart';
import 'package:kk_amongus_tool/dialog/map_selection_dialog.dart';
import 'package:provider/provider.dart';

import '../dialog/name_registration_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, model, child) {
      return Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: MapWidget(GlobalKey()),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                child: const Text("マップ変更"),
                onPressed: () async {
                  final String? mapPath = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      return const MapSelectionDialog();
                    },
                  );
                  if (mapPath != null) {
                    model.changeMap(mapPath);
                  }
                },
              ),
              ElevatedButton(
                child: const Text("位置リセット"),
                onPressed: () {
                  model.clearPlayerInfo();
                },
              ),
              ElevatedButton(
                child: const Text("プレイヤー登録"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return NameRegistrationScreen(model);
                    },
                  );
                },
              ),
              RoundSelectionWidget(model),
            ],
          ),
        ],
      );
    });
  }
}
