# PATH 설정 없이 저장소에 설치된 Flutter로 명령 실행
# 사용 예: .\flutter_local.ps1 run -d windows
param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$FlutterArgs
)

$Here = $PSScriptRoot
$RepoRoot = Split-Path -Parent $Here
$FlutterBat = Join-Path $RepoRoot 'flutter_sdk\flutter\bin\flutter.bat'

if (-not (Test-Path $FlutterBat)) {
  Write-Host "flutter_sdk가 없습니다. 저장소 루트에서 설치 스크립트를 실행하세요:" -ForegroundColor Yellow
  Write-Host "  powershell -ExecutionPolicy Bypass -File .\tools\install_flutter_windows.ps1"
  exit 1
}

$binDir = Split-Path -LiteralPath $FlutterBat -Parent
$env:Path = "$binDir;$env:Path"
Set-Location $Here
& $FlutterBat @FlutterArgs
exit $LASTEXITCODE
