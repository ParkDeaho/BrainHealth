@echo off
setlocal
REM Bundled Flutter (no global PATH required). From repo root:
REM   flutter_bundle.cmd pub get
REM   flutter_bundle.cmd run -d windows
REM Or from flutter_app: use flutter_local.cmd (same behavior).

set "REPO=%~dp0"
if "%REPO:~-1%"=="\" set "REPO=%REPO:~0,-1%"
set "FLUTTER_BAT=%REPO%\flutter_sdk\flutter\bin\flutter.bat"
if not exist "%FLUTTER_BAT%" (
  echo [flutter_bundle] Missing: %FLUTTER_BAT%
  echo Run: powershell -ExecutionPolicy Bypass -File .\tools\install_flutter_windows.ps1
  exit /b 1
)
set "PATH=%REPO%\flutter_sdk\flutter\bin;%PATH%"
call "%FLUTTER_BAT%" %*
exit /b %ERRORLEVEL%
