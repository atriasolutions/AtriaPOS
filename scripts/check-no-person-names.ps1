# SLICE-57 — rechaza nombres propios en archivos versionados (DEC-045).
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$denyFile = Join-Path $PSScriptRoot 'deny-person-names.txt'

if (-not (Test-Path $denyFile)) {
    Write-Error "Falta $denyFile"
}

$patterns = Get-Content $denyFile |
    Where-Object { $_ -and -not $_.TrimStart().StartsWith('#') }

if ($patterns.Count -eq 0) {
    Write-Error 'deny-person-names.txt sin patrones'
}

$combined = ($patterns -join '|')
$rg = Get-Command rg -ErrorAction SilentlyContinue
if (-not $rg) {
    Write-Error 'rg (ripgrep) no está en PATH; requerido para check-no-person-names'
}

$args = @(
    '--ignore-case',
    '--line-number',
    '--hidden',
    $combined,
    $root,
    '-g', '!.git/**',
    '-g', '!**/node_modules/**',
    '-g', '!**/.plugin_symlinks/**',
    '-g', '!**/ephemeral/**',
    '-g', '!**/build/**',
    '-g', '!scripts/deny-person-names.txt'
)

$matches = & rg @args 2>$null
if ($LASTEXITCODE -eq 0 -and $matches) {
    Write-Host 'Nombres propios detectados (SLICE-57):' -ForegroundColor Red
    $matches | ForEach-Object { Write-Host $_ }
    exit 1
}

if ($LASTEXITCODE -gt 1) {
    Write-Error "rg falló con código $LASTEXITCODE"
}

Write-Host 'check-no-person-names: OK' -ForegroundColor Green
exit 0