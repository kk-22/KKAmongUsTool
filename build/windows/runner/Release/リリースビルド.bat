cd ..\..\..\..\
git restore windows/runner/win32_window.h
flutter build windows

# ビルド完了直後にバッチが強制終了するため、起動できない
start build\windows\runner\Release\kk_amongus_tool.exe
echo キーを押すと終了します
set /P input=
exit