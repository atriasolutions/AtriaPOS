# Paridad local con .github/workflows/ci.yml (SC-026-01)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

function Invoke-Step {
    param([string]$Label, [scriptblock]$Block)
    Write-Host "== $Label ==" -ForegroundColor Cyan
    & $Block
    if ($LASTEXITCODE -ne 0) {
        Write-Host "FAILED: $Label" -ForegroundColor Red
        exit $LASTEXITCODE
    }
}

Invoke-Step 'core' {
    Set-Location (Join-Path $root 'packages\core')
    dart pub get
    dart test
}

Invoke-Step 'adapters' {
    Set-Location (Join-Path $root 'packages\adapters')
    dart pub get
    dart test
}

Invoke-Step 'pos_app' {
    Set-Location (Join-Path $root 'apps\pos_app')
    flutter pub get
    flutter test
}

Write-Host 'All suites passed (core, adapters, pos_app).' -ForegroundColor Green
exit 0