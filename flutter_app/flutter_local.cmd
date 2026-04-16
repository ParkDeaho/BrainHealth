@echo off
setlocal
set "HERE=%~dp0"
set "REPO_ROOT=%HERE%.."
set "FLUTTER_BAT=%REPO_ROOT%\flutter_sdk\flutter\bin\flutter.bat"
if not exist "%FLUTTER_BAT%" (
  echo [오류] flutter_sdk를 찾을 수 없습니다: %FLUTTER_BAT%
  echo 저장소 루트에서 install_flutter_windows.ps1 을 먼저 실행하세요.
  exit /b 1
)
set "PATH=%REPO_ROOT%\flutter_sdk\flutter\bin;%PATH%"
cd /d "%HERE%"
call "%FLUTTER_BAT%" %*
exit /b %ERRORLEVEL%
