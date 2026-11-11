# Penanggung jawab: Fauzi (peluncur), Arief (regresi). Kompatibel PowerShell 5.1+.
# Memakai Flutter/Dart pada PATH; tidak memasang SDK, membuat AVD, atau mengubah
# pengaturan Windows. Setiap mode dijalankan sendiri pada terminal pengguna.
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('Server', 'Emulator', 'App', 'Check')]
    [string]$Mode,
    [string]$DeviceId,
    [string]$EmulatorId,
    [string]$ApiUrl,
    [ValidateRange(1, 65535)][int]$Port = 8080,
    [string]$AvdHome
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent

function Require-UkmCommand([string]$Name) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "$Name belum tersedia di terminal. Periksa PATH Flutter/Dart lalu buka terminal baru."
    }
}

function Read-UkmFlutterList([string[]]$Arguments) {
    $raw = @(& flutter @Arguments)
    if ($LASTEXITCODE) { throw "Flutter gagal membaca daftar ($($Arguments -join ' '))." }
    try { $parsed = ($raw -join [Environment]::NewLine) | ConvertFrom-Json }
    catch { throw 'Daftar perangkat/emulator dari Flutter bukan JSON valid. Periksa flutter doctor -v.' }
    # Foreach sengaja eksplisit: ConvertFrom-Json PowerShell 5.1 dapat meneruskan
    # seluruh array sebagai satu objek pipeline jika langsung memakai filter.
    foreach ($item in $parsed) { $item }
}

function Assert-UkmId($Value) {
    if ($Value -isnot [string] -or $Value -notmatch '^[a-zA-Z0-9_.:-]+$') {
        throw 'ID harus satu nilai perangkat/emulator yang valid, bukan seluruh daftar Flutter.'
    }
}

function Read-UkmEmulators {
    # Flutter emulators tidak menyediakan --machine. Ambil hanya ID pada baris
    # tabel yang berakhir dengan platform android, bukan teks petunjuk/header.
    # Tidak bergantung karakter bullet Unicode agar tetap cocok PowerShell 5.1.
    $raw = @(& flutter emulators)
    if ($LASTEXITCODE) { throw 'Flutter gagal membaca emulator. Periksa flutter emulators dan Android SDK.' }
    foreach ($line in $raw) {
        if ($line -match '^\s*([a-zA-Z0-9_.:-]+)\s+.+\s+android\s*$') {
            [PSCustomObject]@{ id = $Matches[1]; name = $Matches[1]; platformType = 'android' }
        }
    }
}

function Test-UkmPort([int]$Number) {
    $socket = New-Object System.Net.Sockets.TcpClient
    try { return $socket.ConnectAsync('127.0.0.1', $Number).Wait(700) -and $socket.Connected }
    catch { return $false }
    finally { $socket.Dispose() }
}

function Invoke-UkmMode {
    if ($Mode -eq 'Server') {
        if (Test-UkmPort $Port) {
            try {
                $data = Invoke-RestMethod "http://localhost:$Port/ukm" -TimeoutSec 3
                $items = @(foreach ($item in $data) { $item })
                if ($items.Count -gt 0 -and $items[0].id -and $items[0].bukaRekrutmen -is [bool]) {
                    Write-Host "API UKM sudah aktif ($($items.Count) UKM): http://localhost:$Port/ukm"
                    Write-Host 'Tidak menyalakan duplikat. Untuk berhenti, gunakan terminal pemilik server tersebut.'
                    return
                }
            } catch { }
            throw "Port $Port sudah dipakai, tetapi API UKM belum dapat dikonfirmasi. Tidak menyalakan duplikat. Periksa terminal server atau gunakan -Port lain."
        }
        Require-UkmCommand 'dart'
        $oldPort = $env:PORT
        $oldHost = $env:HOST
        Push-Location (Join-Path $repo 'server')
        try {
            dart pub get
            if ($LASTEXITCODE) { throw 'Dependensi server gagal diambil.' }
            $env:PORT = [string]$Port
            $env:HOST = '0.0.0.0'
            Write-Host "Server berjalan di terminal INI. JSON: http://localhost:$Port/ukm"
            Write-Host 'Biarkan terbuka. Ctrl+C di terminal ini untuk menghentikan server.'
            dart run bin/server.dart
            if ($LASTEXITCODE) { throw 'Server berhenti dengan error. Baca pesan Dart di atas.' }
        } finally {
            Pop-Location
            $env:PORT = $oldPort
            $env:HOST = $oldHost
        }
        return
    }

    Require-UkmCommand 'flutter'
    $devices = @(Read-UkmFlutterList -Arguments @('devices', '--machine'))
    $android = @(foreach ($device in $devices) {
        if ($device.targetPlatform -like 'android*') { $device }
    })

    if ($Mode -eq 'Check') {
        Write-Host "Project: $repo"
        Write-Host 'Perangkat Android siap:'
        $android | Select-Object name, id, emulator | Format-Table -AutoSize
        Write-Host 'Emulator Android terpasang:'
        @(Read-UkmEmulators) | Select-Object id | Format-Table -AutoSize
        Write-Host "JSON komputer (ketika server hidup): http://localhost:$Port/ukm"
        return
    }

    if ($Mode -eq 'Emulator') {
        if (@($android | Where-Object { $_.emulator }).Count -gt 0) {
            Write-Host 'Emulator Android sudah aktif. Memakai perangkat tersebut; tidak membuat/menyalakan duplikat.'
            return
        }
        $available = @(Read-UkmEmulators)
        $emulators = @($available | Where-Object { $_.platformType -eq 'android' })
        if ($EmulatorId) { $emulators = @($emulators | Where-Object { $_.id -eq $EmulatorId }) }
        if ($emulators.Count -ne 1) {
            $available | Where-Object { $_.platformType -eq 'android' } |
                Select-Object name, id | Format-Table -AutoSize | Out-Host
            throw 'Pilih satu emulator yang terpasang dengan -EmulatorId ID_AVD. Jika belum ada, siapkan lewat Device Manager; script tidak membuat AVD baru.'
        }
        $selectedAvd = $emulators[0].id
        Assert-UkmId $selectedAvd
        flutter emulators --launch $selectedAvd
        if ($LASTEXITCODE) { throw 'Emulator gagal dinyalakan. Periksa Device Manager/virtualisasi.' }
        Write-Host 'Tunggu layar utama Android siap, lalu jalankan mode App. Server dijalankan terpisah.'
        return
    }

    if ($DeviceId) { $android = @($android | Where-Object { $_.id -eq $DeviceId }) }
    if ($android.Count -ne 1) {
        $devices | Select-Object name, id, targetPlatform | Format-Table -AutoSize | Out-Host
        throw 'Harus ada satu Android siap. Tunggu emulator boot atau gunakan -DeviceId ID_ANDROID jika ada beberapa perangkat.'
    }
    $selected = $android[0]
    Assert-UkmId $selected.id
    if (-not $ApiUrl) {
        if (-not $selected.emulator) {
            throw 'HP fisik memerlukan -ApiUrl http://IP_LAPTOP:8080 atau URL loopback setelah ADB reverse disiapkan.'
        }
        $ApiUrl = "http://10.0.2.2:$Port"
    }
    $uri = $null
    if (-not [Uri]::TryCreate($ApiUrl, [UriKind]::Absolute, [ref]$uri) -or
        $uri.Scheme -notin @('http', 'https') -or $uri.Query -or $uri.Fragment -or $uri.UserInfo) {
        throw 'ApiUrl harus URL dasar http/https yang valid tanpa query, kredensial, atau fragment.'
    }
    if (-not $selected.emulator -and $uri.Host -eq '10.0.2.2') {
        throw '10.0.2.2 khusus Android Emulator; HP fisik gunakan IP LAN laptop atau ADB reverse.'
    }
    $apiBase = $uri.AbsoluteUri.TrimEnd('/')
    Push-Location (Join-Path $repo 'app')
    try {
        flutter pub get
        if ($LASTEXITCODE) { throw 'Dependensi Flutter gagal diambil.' }
        Write-Host "Menjalankan UKM Hub di $($selected.name) [$($selected.id)] dengan API $apiBase"
        Write-Host 'Biarkan terbuka. r = hot reload, R = restart, q = berhenti.'
        $runArguments = @('run', '-d', $selected.id, "--dart-define=API_URL=$apiBase")
        & flutter @runArguments
        if ($LASTEXITCODE) { throw 'Flutter run gagal. Baca error pertama di atas.' }
    } finally { Pop-Location }
}

$previousAvdHome = $env:ANDROID_AVD_HOME
try {
    if ($AvdHome) {
        if (-not (Test-Path -LiteralPath $AvdHome -PathType Container)) {
            throw 'AvdHome tidak ditemukan. Isi lokasi AVD yang memang sudah tersedia.'
        }
        $env:ANDROID_AVD_HOME = (Resolve-Path -LiteralPath $AvdHome).Path
    }
    Invoke-UkmMode
} finally { $env:ANDROID_AVD_HOME = $previousAvdHome }
