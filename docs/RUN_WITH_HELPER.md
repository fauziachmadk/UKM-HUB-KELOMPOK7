# Menjalankan UKM Hub dengan helper kelompok

Peluncur `tools/run_here.ps1` memakai Flutter/Dart pada PATH dan emulator yang
sudah terpasang. Tidak ada nama emulator, cache, atau lokasi SDK Fauzi yang
diwajibkan. Script tidak memasang SDK, membuat AVD baru, pull, merge, atau push.
Perintah dasar manual pada START_HERE tetap dapat digunakan.

## Dua terminal, tiga langkah

Buka root repo di VS Code. Pada komputer Fauzi root final berada di
`D:\ENJOY-CODE\Flutter-Project\UKM-HUB-KELOMPOK7`; anggota lain memakai lokasi
clone masing-masing. Setiap blok di bawah dijalankan dari root, bukan app/server.

**Langkah 1 - Terminal A: nyalakan emulator yang sudah tersedia.**

```powershell
.\tools\run_here.ps1 -Mode Emulator
```

Script memilih satu AVD Android dari daftar Flutter. Kalau ada beberapa AVD,
pilih ID yang ditampilkan, misalnya:

```powershell
.\tools\run_here.ps1 -Mode Emulator -EmulatorId ID_AVD_ANDA
```

Ganti ID_AVD_ANDA, jangan ketik literal. Tunggu layar utama Android siap.
Jika emulator sudah aktif, script memakai perangkat tersebut. Mode Emulator
tidak menyalakan server atau aplikasi secara otomatis.

**Langkah 2 - masih Terminal A: nyalakan API.**

```powershell
.\tools\run_here.ps1 -Mode Server
```

Server berjalan di terminal ini. Biarkan terbuka. JSON di browser komputer:
http://localhost:8080/ukm. Ctrl+C pada terminal ini menghentikan server yang
dijalankan di sini. Jika API sudah aktif, script melaporkannya tanpa duplikat;
untuk menghentikan API lama, gunakan terminal pemilik proses lama tersebut.

**Langkah 3 - klik + untuk Terminal B: jalankan aplikasi.**

Pastikan terminal kedua di root yang sama; jika ragu gunakan cd ke alamat root.

```powershell
.\tools\run_here.ps1 -Mode App
```

Script menjalankan pub get, memilih satu Android siap, lalu Flutter dengan
API_URL=http://10.0.2.2:8080 untuk emulator. Biarkan terbuka; r untuk hot reload,
R untuk restart, q untuk menghentikan sesi Flutter. Jika ada beberapa Android:

```powershell
.\tools\run_here.ps1 -Mode App -DeviceId emulator-5554
```

Ganti ID sesuai perangkat sebenarnya. ID AVD pada langkah 1 berbeda dari ID
perangkat emulator-5554 setelah AVD menyala. Jangan menyalin Windows/Chrome/Edge
sebagai argumen perangkat. Tidak ada pemilihan Windows otomatis.

## Diagnosis dan opsi lain

`-Mode Check` hanya menampilkan perangkat/AVD yang ditemukan dan URL JSON:

```powershell
.\tools\run_here.ps1 -Mode Check
```

- Jika Flutter/Dart tidak ditemukan, periksa PATH dan buka terminal baru.
- Jika tidak ada AVD, siapkan sekali melalui Android Studio Device Manager.
  Jika AVD memang disimpan pada lokasi khusus, gunakan `-AvdHome 'LOKASI_AVD'`
  ketika menyalakan emulator. Lokasi itu harus sudah ada; tidak dibuat script.
- HP fisik: tambahkan `-DeviceId ID_HP -ApiUrl http://IP_LAPTOP:8080` pada mode
  App; HP/laptop satu LAN dan API harus dapat diakses dari HP. Alternatif USB
  ADB reverse memerlukan pemetaan terlebih dahulu, lalu ApiUrl 127.0.0.1:8080.
- Port selain 8080: berikan `-Port NOMOR` yang sama pada Server dan App emulator.
  Bila memakai ApiUrl eksplisit, sesuaikan port di URL tersebut juga.
- Port terpakai tidak diambil alih atau dihentikan. Periksa proses pemiliknya.
- Jika Flutter gagal build/test karena kode gabungan, perbaiki error Dart yang
  dilaporkan. Helper tidak mengganti source atau menyembunyikan kegagalan build.

## Verifikasi helper

12 November 2026: 22 kasus regresi lulus pada Windows PowerShell 5.1 dan
PowerShell 7.6.9. Flutter/Dart diganti tiruan pada tes sehingga tidak menyalakan
aplikasi/API/AVD sungguhan. Tes mencakup satu/multi perangkat, URL HP, duplikat
port, environment sementara, dan kegagalan pub get. Jalankan ulang melalui:

```powershell
powershell -NoProfile -File .\tools\tests\run_here_test.ps1
```

Mode Check juga diuji memakai Flutter asli: daftar emulator Android terbaca.
Perintah emulators memakai format tabel CLI yang terpasang, bukan opsi machine
yang tidak didukung. Mode Server/App/Emulator nyata belum dijalankan dalam
pemasangan helper ini; pengguna menjalankannya dari terminal sendiri.
