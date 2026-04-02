@echo off
echo === Flutter Windows ビルド ===
echo.

:: Windowsアプリをリリースビルド
echo flutter build windows (release)...
flutter build windows --release
if %errorlevel% neq 0 (
    echo エラー: ビルドに失敗しました
    pause
    exit /b 1
)

echo.
echo ビルド完了！
echo 出力先: build\windows\x64\runner\Release\
echo.

:: 出力フォルダを開く
start "" "build\windows\x64\runner\Release\"

pause
