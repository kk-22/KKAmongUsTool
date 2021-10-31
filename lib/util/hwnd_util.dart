import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:kk_amongus_tool/view/screen/home_screen.dart';
import 'package:win32/win32.dart';

extension RECTExtension on RECT {
  int width() => right - left;

  int height() => bottom - top;
}

class HwndUtil {
  static Future<bool> isDeveloping() async {
    return await const MethodChannel('jp.co.kk22/amongustool')
        .invokeMethod("isDeveloping");
  }

  static void shrinkWnd() {
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

    // AmongUs をアクティブウィンドウにする
    int gameWnd = FindWindowEx(0, 0, nullptr, TEXT("Among Us"));
    if (0 < gameWnd) {
      SetForegroundWindow(gameWnd);
    }
  }

  static void expandWnd() {
    final desktopWnd = GetDesktopWindow();
    final desktopRect = calloc<RECT>();
    GetClientRect(desktopWnd, desktopRect);

    final appWnd = FindWindowEx(0, 0, nullptr, TEXT("kk_amongus_tool"));
    final appRect = calloc<RECT>();
    GetWindowRect(appWnd, appRect);

    int dy = (desktopRect.ref.height() - appRect.ref.height()) ~/ 2;

    // カーソルがアプリから外れないように事前に移動
    SetCursorPos(appRect.ref.width() ~/ 2,
        (desktopRect.ref.height().toInt() * 0.7).toInt());
    SetWindowPos(
        appWnd, 0, 0, dy, 0, 0, SWP_NOSIZE | SWP_NOZORDER | SWP_NOOWNERZORDER);
  }

  static int findHwnd(String className) {
    final hwnd = FindWindowEx(0, 0, TEXT(className), nullptr);
    if (hwnd > 0) {
      ShowWindow(hwnd, SW_RESTORE); // 最小化解除
      return hwnd;
    } else {
      print('No $className window found.');
      return 0;
    }
  }

  static void captureImage(int hwnd) {
    // 全画面のキャプチャー(画面サイズはhwnd引数相当)しか撮れないため、全画面を対象とする
    hwnd = GetDesktopWindow();

    final hdcScreen = GetDC(NULL);
    final hdcWindow = GetDC(hwnd);

    final hdcMemDC = CreateCompatibleDC(hdcWindow);
    final bmpScreen = calloc<BITMAP>();

    try {
      if (hdcMemDC == 0) {
        MessageBox(
            hwnd, TEXT('CreateCompatibleDC failed.'), TEXT('Failed'), MB_OK);
        return;
      }

      final rcClient = calloc<RECT>();
      GetClientRect(hwnd, rcClient);

      SetStretchBltMode(hdcWindow, HALFTONE);

      StretchBlt(
          hdcWindow,
          0,
          0,
          rcClient.ref.right,
          rcClient.ref.bottom,
          hdcScreen,
          0,
          0,
          GetSystemMetrics(SM_CXSCREEN),
          GetSystemMetrics(SM_CYSCREEN),
          SRCCOPY);

      final hbmScreen = CreateCompatibleBitmap(
          hdcWindow,
          rcClient.ref.right - rcClient.ref.left,
          rcClient.ref.bottom - rcClient.ref.top);

      SelectObject(hdcMemDC, hbmScreen);

      BitBlt(hdcMemDC, 0, 0, rcClient.ref.right - rcClient.ref.left,
          rcClient.ref.bottom - rcClient.ref.top, hdcWindow, 0, 0, SRCCOPY);

      GetObject(hbmScreen, sizeOf<BITMAP>(), bmpScreen);

      final bitmapFileHeader = calloc<BITMAPFILEHEADER>();
      final bitmapInfoHeader = calloc<BITMAPINFOHEADER>()
        ..ref.biSize = sizeOf<BITMAPINFOHEADER>()
        ..ref.biWidth = bmpScreen.ref.bmWidth
        ..ref.biHeight = bmpScreen.ref.bmHeight
        ..ref.biPlanes = 1
        ..ref.biBitCount = 32
        ..ref.biCompression = BI_RGB;

      final dwBmpSize =
          ((bmpScreen.ref.bmWidth * bitmapInfoHeader.ref.biBitCount + 31) /
                  32 *
                  4 *
                  bmpScreen.ref.bmHeight)
              .toInt();

      final lpBitmap = calloc<Uint8>(dwBmpSize);

      GetDIBits(hdcWindow, hbmScreen, 0, bmpScreen.ref.bmHeight, lpBitmap,
          bitmapInfoHeader.cast(), DIB_RGB_COLORS);

      final hFile = CreateFile(TEXT('capture.bmp'), GENERIC_WRITE, 0, nullptr,
          CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);

      final dwSizeOfDIB =
          dwBmpSize + sizeOf<BITMAPFILEHEADER>() + sizeOf<BITMAPINFOHEADER>();
      bitmapFileHeader.ref.bfOffBits =
          sizeOf<BITMAPFILEHEADER>() + sizeOf<BITMAPINFOHEADER>();

      bitmapFileHeader.ref.bfSize = dwSizeOfDIB;
      bitmapFileHeader.ref.bfType = 0x4D42; // BM

      final dwBytesWritten = calloc<DWORD>();
      WriteFile(hFile, bitmapFileHeader, sizeOf<BITMAPFILEHEADER>(),
          dwBytesWritten, nullptr);
      WriteFile(hFile, bitmapInfoHeader, sizeOf<BITMAPINFOHEADER>(),
          dwBytesWritten, nullptr);
      WriteFile(hFile, lpBitmap, dwBmpSize, dwBytesWritten, nullptr);

      CloseHandle(hFile);
    } finally {
      DeleteObject(hdcMemDC);
      ReleaseDC(NULL, hdcScreen);
      ReleaseDC(hwnd, hdcWindow);
    }
  }
}
