# Build companion_web para servir desde POS en /companion/ (piloto smartphone).
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$webApp = Join-Path $root 'apps\companion_web'
$outDir = Join-Path $webApp 'build\web'

Write-Host '== companion_web: pub get ==' -ForegroundColor Cyan
Push-Location $webApp
flutter pub get
if ($LASTEXITCODE -ne 0) { Pop-Location; exit $LASTEXITCODE }

Write-Host '== companion_web: build web (base-href /companion/) ==' -ForegroundColor Cyan
flutter build web --base-href=/companion/
Pop-Location
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

if (-not (Test-Path $outDir)) {
    Write-Host "No se encontró $outDir" -ForegroundColor Red
    exit 1
}

Write-Host ''
Write-Host 'Build listo:' -ForegroundColor Green
Write-Host "  $outDir"
Write-Host ''
Write-Host 'Arrancar POS (desde la raíz del repo):' -ForegroundColor Yellow
Write-Host @"
  cd apps\pos_app
  flutter run -d windows `
    --dart-define=COMPANION_WEB_ROOT=$($outDir.Replace('\', '/')) `
    --dart-define=COMPANION_LAN_PORT=8765
"@
Write-Host ''
Write-Host 'Celular: misma WiFi que el PC *o* USB tethering (compartir datos al PC).' -ForegroundColor Yellow
Write-Host 'Sin Wi-Fi en PC: ipconfig -> IP adaptador "Remote NDIS"/USB -> COMPANION_LAN_HOST=esa IP.' -ForegroundColor Yellow
Write-Host 'Con el POS en ejecución, smoke en esta PC:' -ForegroundColor Yellow
Write-Host '  .\scripts\verify-companion-lan.ps1'
Write-Host 'Prueba previa en el telefono: https://{IP-PC}:8765/health' -ForegroundColor Yellow
Write-Host 'Firewall: permitir TCP entrante puerto 8765 (red privada).' -ForegroundColor Yellow