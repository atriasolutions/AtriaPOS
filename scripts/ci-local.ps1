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

Invoke-Step 'check-no-person-names' {
    Set-Location $root
    & (Join-Path $root 'scripts\check-no-person-names.ps1')
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

Invoke-Step 'scanner_companion' {
    Set-Location (Join-Path $root 'apps\scanner_companion')
    flutter pub get
    flutter test
}

Invoke-Step 'companion_web' {
    Set-Location (Join-Path $root 'apps\companion_web')
    flutter pub get
    flutter test
}

Write-Host 'All suites passed (core, adapters, pos_app, scanner_companion, companion_web).' -ForegroundColor Green
exit 0