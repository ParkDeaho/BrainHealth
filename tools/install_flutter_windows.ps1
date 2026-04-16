# Flutter SDK 설치 + 현재 사용자 PATH에 flutter\bin 추가
# 관리자 권한 불필요 (사용자 환경 변수)
$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$FlutterSdkDir = Join-Path $RepoRoot 'flutter_sdk'
$FlutterHome = Join-Path $FlutterSdkDir 'flutter'
$FlutterBin = Join-Path $FlutterHome 'bin'
$FlutterBat = Join-Path $FlutterBin 'flutter.bat'

$ZipUrl = 'https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.41.6-stable.zip'
$ZipExpectedSha256 = 'e30303d47ab13c17e0388303ade1a8a24bfe5698b4a28494e6cbee25fc073022'

function Add-FlutterToUserPath {
  param([string]$BinPath)
  $current = [Environment]::GetEnvironmentVariable('Path', 'User')
  if (-not $current) { $current = '' }
  if ($current -like "*$BinPath*") {
    Write-Host "[PATH] 이미 사용자 PATH에 등록되어 있습니다: $BinPath"
    Write-Host "       터미널에서 flutter 가 안 보이면 Cursor/터미널을 완전히 다시 열거나 flutter_bundle.cmd 를 사용하세요."
    return
  }
  $newPath = if ($current) { "$current;$BinPath" } else { $BinPath }
  [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
  Write-Host "[PATH] 사용자 PATH에 추가했습니다: $BinPath"
  Write-Host "       새 터미널/IDE를 열면 flutter 명령이 인식됩니다."
  Write-Host "       (Cursor 등은 완전히 종료 후 다시 열어야 할 수 있습니다.)"
  Write-Host "       PATH 반영 전에도 저장소 루트의 flutter_bundle.cmd 로 실행할 수 있습니다."
}

if (Test-Path $FlutterBat) {
  Write-Host "[OK] Flutter가 이미 있습니다: $FlutterBat"
  Add-FlutterToUserPath -BinPath $FlutterBin
  $env:Path = "$FlutterBin;$env:Path"
  & $FlutterBat --version
  exit 0
}

Write-Host "[다운로드] Flutter stable Windows SDK (용량이 큽니다, 수 분 걸릴 수 있음)..."
New-Item -ItemType Directory -Force -Path $FlutterSdkDir | Out-Null
# TEMP 고정 파일명은 다른 터미널/IDE 백그라운드 다운로드와 충돌할 수 있음 → 저장소 전용 캐시 + 고유 이름
$DownloadDir = Join-Path $RepoRoot '.flutter_download_cache'
New-Item -ItemType Directory -Force -Path $DownloadDir | Out-Null
$zipName = "flutter_windows_3.41.6_stable_$PID.zip"
$zipPath = Join-Path $DownloadDir $zipName
if (Test-Path $zipPath) {
  try {
    Remove-Item -LiteralPath $zipPath -Force -ErrorAction Stop
  } catch {
    Write-Warning "기존 ZIP을 지울 수 없습니다(다른 프로그램이 사용 중). 잠시 후 재시도하거나 작업 관리자에서 powershell/다운로드를 종료하세요."
    throw
  }
}
Invoke-WebRequest -Uri $ZipUrl -OutFile $zipPath -UseBasicParsing

$hash = (Get-FileHash -Path $zipPath -Algorithm SHA256).Hash.ToLower()
if ($hash -ne $ZipExpectedSha256) {
  Write-Warning "SHA256가 목록과 다를 수 있습니다(공식 패치 등). 계속 압축 해제합니다. 예상: $ZipExpectedSha256 / 실제: $hash"
}

Write-Host "[압축 해제] $FlutterSdkDir ..."
if (Test-Path $FlutterHome) {
  Remove-Item -Recurse -Force $FlutterHome
}
Expand-Archive -Path $zipPath -DestinationPath $FlutterSdkDir -Force
Remove-Item $zipPath -Force

if (-not (Test-Path $FlutterBat)) {
  throw "압축 후 flutter.bat을 찾을 수 없습니다: $FlutterBat"
}

Add-FlutterToUserPath -BinPath $FlutterBin
$env:Path = "$FlutterBin;$env:Path"

Write-Host "[실행] flutter --version"
& $FlutterBat --version
Write-Host ""
Write-Host "[다음] 새 PowerShell을 연 뒤: cd <flutter_app 경로> ; flutter pub get"
Write-Host "      또는 Android Studio를 한 번 재시작하세요."
