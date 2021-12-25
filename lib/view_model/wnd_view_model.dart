import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:kk_amongus_tool/util/hwnd_util.dart';
import 'package:kk_amongus_tool/view/screen/home_screen.dart';
import 'package:win32/win32.dart';

class WndViewModel with ChangeNotifier {
  static const _minShrinkIntervalMsec = 300;

  var _isDeveloping = false;
  var _dateToStopShrinking = DateTime.now(); // この日時より前なら縮小させない
  var _isShrinking = false;

  get isShrinking => _isShrinking;

  WndViewModel() {
    const MethodChannel('jp.co.kk22/amongustool')
        .invokeMethod("isDeveloping")
        .then((value) => _isDeveloping = value);
  }

  bool shrinkWndIfNeeded() {
    if (!_isDeveloping && DateTime.now().isAfter(_dateToStopShrinking)) {
      _shrinkWnd();
      return true;
    }
    return false;
  }

  void activeGameWnd() {
    // AmongUs をアクティブウィンドウにする
    int gameWnd = FindWindowEx(0, 0, nullptr, TEXT("Among Us"));
    if (0 < gameWnd) {
      SetForegroundWindow(gameWnd);
    }
  }

  void _shrinkWnd() {
    _isShrinking = true;
    final desktopWnd = GetDesktopWindow();
    final desktopRect = calloc<RECT>();
    GetClientRect(desktopWnd, desktopRect);
    final appWnd = FindWindowEx(0, 0, nullptr, TEXT("kk_amongus_tool"));
    final appRect = calloc<RECT>();
    GetWindowRect(appWnd, appRect);

    int dx = -appRect.ref.width() ~/ 3 - 20;
    int dy = desktopRect.ref.height() - HomeScreen.overlayBarHeight.toInt();
    SetWindowPos(
        appWnd, 0, dx, dy, 0, 0, SWP_NOSIZE | SWP_NOZORDER | SWP_NOOWNERZORDER);

    activeGameWnd();
  }

  void expandWnd() {
    _isShrinking = false;
    _dateToStopShrinking = DateTime.now()
        .add(const Duration(milliseconds: _minShrinkIntervalMsec));

    final desktopWnd = GetDesktopWindow();
    final desktopRect = calloc<RECT>();
    GetClientRect(desktopWnd, desktopRect);

    final appWnd = FindWindowEx(0, 0, nullptr, TEXT("kk_amongus_tool"));
    final appRect = calloc<RECT>();
    GetWindowRect(appWnd, appRect);

    // 画面左と下の隙間を無くすためにマイナス
    final appY = desktopRect.ref.height() - appRect.ref.height() + 1;
    // カーソルがアプリから外れないように事前に移動
    SetCursorPos(
        appRect.ref.width() ~/ 2, (appY + appRect.ref.height() * 0.3).toInt());
    SetWindowPos(appWnd, 0, -1, appY, 0, 0,
        SWP_NOSIZE | SWP_NOZORDER | SWP_NOOWNERZORDER);
  }

  void moveWndToRightDown(int width, int height) {
    _dateToStopShrinking = DateTime.now()
        .add(const Duration(milliseconds: _minShrinkIntervalMsec));

    final desktopWnd = GetDesktopWindow();
    final desktopRect = calloc<RECT>();
    GetClientRect(desktopWnd, desktopRect);

    final appWnd = FindWindowEx(0, 0, nullptr, TEXT("kk_amongus_tool"));
    final appRect = calloc<RECT>();
    GetWindowRect(appWnd, appRect);

    int dx = desktopRect.ref.width() - width;
    int dy = desktopRect.ref.height() - height;
    // 移動後に操作しやすいようにカーソル移動
    SetCursorPos(dx + width ~/ 2, dy + height ~/ 2);
    SetWindowPos(
        appWnd, 0, dx, dy, 0, 0, SWP_NOSIZE | SWP_NOZORDER | SWP_NOOWNERZORDER);
  }
}
