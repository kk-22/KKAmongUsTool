import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kk_amongus_tool/model/moving_route.dart';
import 'package:kk_amongus_tool/model/player.dart';
import 'package:provider/provider.dart';

class RouteBoard extends StatelessWidget {
  const RouteBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final route = Provider.of<MovingRoute>(context, listen: false);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GestureDetector(
        onPanStart: (details) => route.addPaint(details.localPosition),
        onPanUpdate: (details) => route.updatePaint(details.localPosition),
        onPanEnd: (_) => route.endPaint(),
        child: Consumer<MovingRoute>(builder: (context, value, child) {
          return CustomPaint(
            painter: RoutePainter(value),
          );
        }),
      ),
    );
  }
}

class RoutePainter extends CustomPainter {
  final MovingRoute _route;

  RoutePainter(this._route);

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 3.0;
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    for (final route in _route.routeList) {
      paint.color = route.color.hexColor();
      // 一番最初にタップした地点に点を打つ。タップして離しただけの時に描画するため。
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: route.offsets[0],
              width: strokeWidth,
              height: strokeWidth),
          const Radius.circular(strokeWidth),
        ),
        paint,
      );
      // ひとかたまりの線の描画
      for (var i = 0; i < route.offsets.length - 1; i++) {
        canvas.drawLine(route.offsets[i], route.offsets[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant RoutePainter oldDelegate) {
    return true;
  }
}
