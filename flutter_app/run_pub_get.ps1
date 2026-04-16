# 프로젝트 루트에 설치된 로컬 Flutter로 pub get 실행 (PATH 설정 없이 동작)
$ErrorActionPreference = 'Stop'
$Here = $PSScriptRoot
$RepoRoot = Split-Path -Parent $Here
$FlutterBat = Join-Path $RepoRoot 'flutter_sdk\flutter\bin\flutter.bat'

if (-not (Test-Path $FlutterBat)) {
  Write-Host "로컬 Flutter가 없습니다. 먼저 저장소 루트에서 실행하세요:"
  Write-Host "  powershell -ExecutionPolicy Bypass -File .\tools\install_flutter_windows.ps1"
  exit 1
}

$env:Path = "$(Split-Path $FlutterBat -Parent);$env:Path"
Set-Location $Here
& $FlutterBat pub get
Write-Host "[완료] dart run build_runner build --delete-conflicting-outputs 도 같은 터미널에서 실행할 수 있습니다."
