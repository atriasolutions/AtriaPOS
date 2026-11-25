# Smoke companion LAN en la PC (SLICE-115). Requiere POS en ejecución con TLS en puerto 8765.
param(
    [Parameter()]
    [string]$TargetHost = '127.0.0.1',

    [Parameter()]
    [int]$Port = 8765,

    [switch]$SkipTlsVerify = $true
)

$ErrorActionPreference = 'Stop'

function Get-CompanionBody {
    param([string]$Url)
    $curlArgs = @('-sS', '--max-time', '8')
    if ($SkipTlsVerify) { $curlArgs += '-k' }
    $curlArgs += $Url
    $out = & curl.exe @curlArgs 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "curl falló ($LASTEXITCODE): $out"
    }
    return [string]$out
}

function Test-CompanionHealth {
    param([string]$Base)
    Write-Host "SC-115-01 GET $Base/health" -ForegroundColor Cyan
    $body = Get-CompanionBody -Url "$Base/health"
    if ($body -notmatch '"ok"\s*:\s*true') {
        throw "Health sin ok:true. Cuerpo: $($body.Substring(0, [Math]::Min(120, $body.Length)))"
    }
    Write-Host '  OK health' -ForegroundColor Green
}

function Test-CompanionPwaIndex {
    param([string]$Base)
    Write-Host "SC-115-02 GET $Base/companion/" -ForegroundColor Cyan
    $body = Get-CompanionBody -Url "$Base/companion/"
    if ($body -eq 'No encontrado' -or $body.Trim() -eq 'No encontrado') {
        throw 'PWA ausente (No encontrado). Ejecute prepare-companion-pwa.ps1 y reinicie el POS con COMPANION_WEB_ROOT.'
    }
    if ($body -notmatch '(?i)<html' -and $body -notmatch 'base href') {
        throw "Respuesta /companion/ no parece HTML de la PWA. Inicio: $($body.Substring(0, [Math]::Min(80, $body.Length)))"
    }
    Write-Host '  OK PWA index' -ForegroundColor Green
}

function Test-CompanionCaHelp {
    param([string]$Base)
    Write-Host "SC-115-03 GET $Base/companion/instalar-certificado" -ForegroundColor Cyan
    $body = Get-CompanionBody -Url "$Base/companion/instalar-certificado"
    if ($body -notmatch '(?i)<html') {
        throw 'Página instalar-certificado no devolvió HTML.'
    }
    if ($body -notmatch 'atria-ca\.pem') {
        throw 'La página no enlaza atria-ca.pem.'
    }
    Write-Host '  OK ayuda CA' -ForegroundColor Green
}

try {
    $scheme = 'https'
    $base = "${scheme}://${TargetHost}:${Port}"
    Write-Host "== Companion LAN smoke ($base) ==" -ForegroundColor Yellow
    if (-not (Get-Command curl.exe -ErrorAction SilentlyContinue)) {
        throw 'curl.exe no está en PATH (Windows 10+ suele incluirlo).'
    }
    Test-CompanionHealth -Base $base
    Test-CompanionPwaIndex -Base $base
    Test-CompanionCaHelp -Base $base
    Write-Host ''
    Write-Host 'Smoke companion LAN: OK (siguiente paso: piloto en celular).' -ForegroundColor Green
    exit 0
}
catch {
    Write-Host ''
    Write-Host "Smoke companion LAN: FALLO — $($_.Exception.Message)" -ForegroundColor Red
    Write-Host 'Compruebe: POS en ejecución, puerto 8765, prepare-companion-pwa.ps1 y firewall.' -ForegroundColor Yellow
    exit 1
}