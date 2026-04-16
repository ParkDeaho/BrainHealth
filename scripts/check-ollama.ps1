# Check local Ollama (default port 11434).
# From repo root:
#   powershell -ExecutionPolicy Bypass -File scripts/check-ollama.ps1
# Custom base URL:
#   powershell -File scripts/check-ollama.ps1 -BaseUrl "http://10.0.2.2:11434"

param(
  [string]$BaseUrl = "http://127.0.0.1:11434"
)

$BaseUrl = $BaseUrl.TrimEnd('/')
$uri = "$BaseUrl/api/tags"

try {
  $resp = Invoke-WebRequest -Uri $uri -UseBasicParsing -TimeoutSec 8
  if ($resp.StatusCode -ge 200 -and $resp.StatusCode -lt 300) {
    Write-Host "OK: Ollama responded ($($resp.StatusCode)) at $uri" -ForegroundColor Green
    exit 0
  }
  Write-Host "Unexpected status: $($resp.StatusCode)" -ForegroundColor Yellow
  exit 1
}
catch {
  Write-Host "FAIL: $uri" -ForegroundColor Red
  Write-Host $_.Exception.Message
  Write-Host "Ensure Ollama is running and the URL matches your setup (Android emulator: http://10.0.2.2:11434)."
  exit 1
}
