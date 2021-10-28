#include "flutter_window.h"

#include <optional>

#include "flutter/generated_plugin_registrant.h"
#include "flutter/method_channel.h"
#include "flutter/standard_method_codec.h"

#define GetMonitorRect(rc)  SystemParametersInfo(SPI_GETWORKAREA,0,rc,0)

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  setMethodChannel(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());
  return true;
}

void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}

void FlutterWindow::setMethodChannel(flutter::FlutterEngine *engine) {
  const std::string test_channel("jp.co.kk22/amongustool");
  const flutter::StandardMethodCodec& codec = flutter::StandardMethodCodec::GetInstance();

  flutter::MethodChannel method_channel_(engine->messenger(), test_channel, &codec);
  method_channel_.SetMethodCallHandler([&](const auto& call, auto result) {
    std::string name = call.method_name();
    if (name.compare("expandHwnd") == 0) {
      RECT monitorRect, wndRect;
      GetMonitorRect(&monitorRect);
      GetWindowRect(contentHwnd, &wndRect);
      INT monitorHeight = (monitorRect.bottom - monitorRect.top);
      INT wndHeight = (wndRect.bottom - wndRect.top);
      INT pointY = (monitorHeight - wndHeight) / 2;
      // `-8` is instead of `monitorRect.left`.
      SetWindowPos(contentHwnd, NULL, -8, pointY, 0, 0,
        (SWP_NOSIZE | SWP_NOZORDER | SWP_NOOWNERZORDER));
      result->Success();
    } else if (name.compare("isDeveloping") == 0) {
      result->Success(IS_DEVELOPING);
    } else {
	    std::cout << "No register method. name=" << name << std::endl;
    }
  });
}
