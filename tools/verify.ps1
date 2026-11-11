# Penanggung jawab: Arief, review integrasi Fauzi. Tidak mengatur cache/SDK mesin.
param([switch]$BuildApk)
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
Push-Location (Join-Path $repo 'server')
try {
    dart pub get
    if ($LASTEXITCODE) { throw 'Dependensi server gagal' }
    dart analyze
    if ($LASTEXITCODE) { throw 'Analyze server gagal' }
    dart test
    if ($LASTEXITCODE) { throw 'Tes server gagal' }
} finally { Pop-Location }
Push-Location (Join-Path $repo 'app')
try {
    flutter pub get
    if ($LASTEXITCODE) { throw 'Dependensi Flutter gagal' }
    flutter analyze
    if ($LASTEXITCODE) { throw 'Analyze Flutter gagal' }
    flutter test --concurrency=1
    if ($LASTEXITCODE) { throw 'Tes Flutter gagal' }
    if ($BuildApk) {
        flutter build apk --debug --dart-define=API_URL=http://10.0.2.2:8080
        if ($LASTEXITCODE) { throw 'APK gagal' }
    }
} finally { Pop-Location }
