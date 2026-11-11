# Arief: uji peluncur tanpa Flutter, Dart, emulator, atau API sungguhan.
# Perintah eksternal diganti fungsi lokal; listener TCP hanya port acak sementara.
$ErrorActionPreference = 'Stop'
$launcher = Join-Path (Split-Path $PSScriptRoot -Parent) 'run_here.ps1'
$global:ukmDevices = '[]'
$global:ukmEmulators = '[]'
$global:ukmCalls = @()
$global:ukmPubFails = $false
$global:ukmReply = @()
$passed = 0

function global:flutter {
    $a = @($args)
    $global:LASTEXITCODE = 0
    $global:ukmCalls += [PSCustomObject]@{ Tool = 'flutter'; Arguments = $a; Location = (Get-Location).Path; AvdHome = $env:ANDROID_AVD_HOME }
    if ($a[0] -eq 'devices' -and $a[1] -eq '--machine') { $global:ukmDevices }
    elseif ($a[0] -eq 'emulators' -and $a.Count -eq 1) {
        'Id | Name | Manufacturer | Platform'
        $list = $global:ukmEmulators | ConvertFrom-Json
        foreach ($item in $list) { "$($item.id) | $($item.name) | Generic | $($item.platformType)" }
        "To run an emulator, run 'flutter emulators --launch <emulator id>'."
    }
    elseif ($a[0] -eq 'emulators' -and $a[1] -eq '--launch') { }
    elseif ($a[0] -eq 'pub' -and $a[1] -eq 'get') { if ($global:ukmPubFails) { $global:LASTEXITCODE = 1 } }
    elseif ($a[0] -ne 'run') { throw "Argumen Flutter tidak diharapkan: $a" }
}
function global:dart {
    $global:LASTEXITCODE = 0
    $global:ukmCalls += [PSCustomObject]@{ Tool = 'dart'; Arguments = @($args); Location = (Get-Location).Path; Port = $env:PORT; Bind = $env:HOST }
    if ($global:ukmPubFails) { $global:LASTEXITCODE = 1 }
}
function global:Invoke-RestMethod { param($Uri, $TimeoutSec) $global:ukmReply }
function Reset-UkmTest($Devices = @(), $Emulators = @()) {
    $global:ukmDevices = ConvertTo-Json -InputObject @($Devices) -Depth 5
    $global:ukmEmulators = ConvertTo-Json -InputObject @($Emulators) -Depth 5
    $global:ukmCalls = @()
    $global:ukmPubFails = $false
    $global:ukmReply = @()
}
function Assert-UkmTest($Condition, [string]$Message) { if (-not $Condition) { throw $Message } }
function Assert-UkmReject([scriptblock]$Action, [string]$Pattern) {
    $caught = $false
    try { & $Action | Out-Null }
    catch {
        $caught = $true
        if ($_.Exception.Message -notmatch $Pattern) { throw "Error tidak sesuai: $($_.Exception.Message)" }
    }
    Assert-UkmTest $caught 'Seharusnya ditolak.'
}
function Assert-UkmRun([string]$Id, [string]$Url) {
    $runs = @($global:ukmCalls | Where-Object { $_.Tool -eq 'flutter' -and $_.Arguments[0] -eq 'run' })
    Assert-UkmTest ($runs.Count -eq 1) 'Harus tepat satu flutter run.'
    Assert-UkmTest (($runs[0].Arguments -join '|') -eq "run|-d|$Id|--dart-define=API_URL=$Url") 'Argumen perangkat/URL tidak benar.'
    Assert-UkmTest ((Split-Path $runs[0].Location -Leaf) -eq 'app') 'Flutter harus dijalankan dari app.'
}
$emu = @{ name = 'Android'; id = 'emulator-5554'; targetPlatform = 'android-x64'; emulator = $true }
$emu2 = @{ name = 'Android 2'; id = 'emulator-5556'; targetPlatform = 'android-x64'; emulator = $true }
$windows = @{ name = 'Windows'; id = 'windows'; targetPlatform = 'windows-x64'; emulator = $false }
$chrome = @{ name = 'Chrome'; id = 'chrome'; targetPlatform = 'web-javascript'; emulator = $false }
$phone = @{ name = 'Samsung'; id = 'samsung-test'; targetPlatform = 'android-arm64'; emulator = $false }
$avd = @{ name = 'AVD satu'; id = 'AVD_one'; platformType = 'android' }
$avd2 = @{ name = 'AVD dua'; id = 'AVD_two'; platformType = 'android' }

Reset-UkmTest @($emu, $windows, $chrome)
& $launcher -Mode App
Assert-UkmRun 'emulator-5554' 'http://10.0.2.2:8080'; $passed++
Reset-UkmTest @($windows, $chrome, $emu)
& $launcher -Mode App -Port 18081
Assert-UkmRun 'emulator-5554' 'http://10.0.2.2:18081'; $passed++
Reset-UkmTest @($windows, $chrome)
Assert-UkmReject { & $launcher -Mode App } 'satu Android'; $passed++
Reset-UkmTest @($emu, $emu2)
Assert-UkmReject { & $launcher -Mode App } 'satu Android'; $passed++
& $launcher -Mode App -DeviceId 'emulator-5556'
Assert-UkmRun 'emulator-5556' 'http://10.0.2.2:8080'; $passed++
Reset-UkmTest @($emu)
Assert-UkmReject { & $launcher -Mode App -DeviceId 'not-connected' } 'satu Android'; $passed++
Reset-UkmTest @(@{ name = 'Invalid'; id = @('emulator-5554', 'windows'); targetPlatform = 'android-x64'; emulator = $true })
Assert-UkmReject { & $launcher -Mode App } 'ID harus satu'; $passed++
Reset-UkmTest @($phone)
Assert-UkmReject { & $launcher -Mode App } 'HP fisik'; $passed++
& $launcher -Mode App -ApiUrl 'http://192.168.1.10:8080/'
Assert-UkmRun 'samsung-test' 'http://192.168.1.10:8080'; $passed++
Reset-UkmTest @($phone)
Assert-UkmReject { & $launcher -Mode App -ApiUrl 'http://10.0.2.2:8080' } 'khusus Android Emulator'; $passed++
Reset-UkmTest @($emu)
Assert-UkmReject { & $launcher -Mode App -ApiUrl 'file:///tmp/api' } 'URL dasar'; $passed++
Assert-UkmReject { & $launcher -Mode App -ApiUrl 'http://host/ukm?bidang=Seni' } 'URL dasar'; $passed++

Reset-UkmTest @() @($avd)
& $launcher -Mode Emulator
$launch = @($global:ukmCalls | Where-Object { $_.Arguments[0] -eq 'emulators' -and $_.Arguments[1] -eq '--launch' })
Assert-UkmTest (($launch[0].Arguments -join '|') -eq 'emulators|--launch|AVD_one') 'AVD harus dipilih dari daftar Flutter.'; $passed++
Reset-UkmTest @() @($avd, $avd2)
Assert-UkmReject { & $launcher -Mode Emulator } 'Pilih satu emulator'; $passed++
& $launcher -Mode Emulator -EmulatorId AVD_two
$launch = @($global:ukmCalls | Where-Object { $_.Arguments[0] -eq 'emulators' -and $_.Arguments[1] -eq '--launch' })
Assert-UkmTest ($launch[0].Arguments[2] -eq 'AVD_two') 'EmulatorId tidak dipakai.'; $passed++
Reset-UkmTest @() @()
Assert-UkmReject { & $launcher -Mode Emulator } 'Pilih satu emulator'; $passed++
Reset-UkmTest @($emu) @($avd)
& $launcher -Mode Emulator
Assert-UkmTest ($global:ukmCalls.Count -eq 1) 'Emulator aktif tidak boleh diluncurkan lagi.'; $passed++

Reset-UkmTest @() @($avd)
$beforeAvd = $env:ANDROID_AVD_HOME
& $launcher -Mode Emulator -AvdHome $PSScriptRoot
Assert-UkmTest ($global:ukmCalls[0].AvdHome -eq $PSScriptRoot) 'AvdHome tidak diteruskan.'
Assert-UkmTest ($env:ANDROID_AVD_HOME -eq $beforeAvd) 'AvdHome terminal tidak dipulihkan.'; $passed++

# Pilih port acak: tidak menyentuh API pengguna di 8080.
$listener = New-Object System.Net.Sockets.TcpListener([Net.IPAddress]::Loopback, 0)
$listener.Start(); $freePort = $listener.LocalEndpoint.Port; $listener.Stop()
Reset-UkmTest
$oldPort = $env:PORT; $oldHost = $env:HOST
& $launcher -Mode Server -Port $freePort
$runs = @($global:ukmCalls | Where-Object { $_.Tool -eq 'dart' -and $_.Arguments[0] -eq 'run' })
Assert-UkmTest (($runs[0].Arguments -join '|') -eq 'run|bin/server.dart') 'Server tidak dijalankan melalui Dart.'
Assert-UkmTest ($runs[0].Port -eq [string]$freePort) 'Port server tidak diteruskan.'
Assert-UkmTest ($env:PORT -eq $oldPort -and $env:HOST -eq $oldHost) 'Environment server tidak dipulihkan.'; $passed++

$listener = New-Object System.Net.Sockets.TcpListener([Net.IPAddress]::Loopback, 0)
$listener.Start()
try {
    Reset-UkmTest
    $global:ukmReply = @([PSCustomObject]@{ id = 'demo'; bukaRekrutmen = $true })
    & $launcher -Mode Server -Port $listener.LocalEndpoint.Port
    Assert-UkmTest ($global:ukmCalls.Count -eq 0) 'API aktif tidak boleh diduplikasi.'; $passed++
    Reset-UkmTest
    Assert-UkmReject { & $launcher -Mode Server -Port $listener.LocalEndpoint.Port } 'Port .+ sudah dipakai'
    Assert-UkmTest ($global:ukmCalls.Count -eq 0) 'Port terpakai tidak boleh diluncurkan lagi.'; $passed++
} finally { $listener.Stop() }

Reset-UkmTest @($emu)
$global:ukmPubFails = $true
Assert-UkmReject { & $launcher -Mode App } 'Dependensi Flutter'
Assert-UkmTest (@($global:ukmCalls | Where-Object { $_.Arguments[0] -eq 'run' }).Count -eq 0) 'Pub gagal harus menghentikan run.'; $passed++
Write-Host "$passed kasus regresi lulus pada PowerShell $($PSVersionTable.PSVersion)."
