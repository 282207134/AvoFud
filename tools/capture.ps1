param([string]$Device = 'emulator-5556')
$ErrorActionPreference = 'Stop'
Push-Location (Split-Path $PSScriptRoot -Parent)
try {
    flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart -d $Device
    if ($LASTEXITCODE -ne 0) { throw 'Android verification failed.' }
    Write-Host 'Screenshots saved to docs/screenshots.'
} finally {
    Pop-Location
}
