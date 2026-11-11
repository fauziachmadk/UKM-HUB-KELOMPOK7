# Mulai dari sini

Kerangka ini berbeda dari DEV lengkap: ada implementasi minimum yang berjalan,
sementara pekerjaan final anggota ada di [TASKS.md](TASKS.md). Semua tanda
`TODO(NAMA)` adalah tugas nyata. Jangan menghapus TODO lalu mengklaim selesai.

## 1. Buka folder yang benar

Di VS Code: File > Open Folder > pilih folder induk yang memuat `app`, `server`,
`docs`, dan README. Jika nanti namanya UKM-HUB-KELOMPOK7 di drive D, itu tetap
root. Nama direktori boleh berubah; nama package Dart `ukm_hub` tetap.

Lokasi `D:\ENJOY-CODE\Flutter-Project\UKM-HUB-KELOMPOK7` aman untuk source.
Alat Flutter/Java/Android SDK tidak ikut dipindahkan. Emulator yang sudah ada
dapat dipakai lagi. Folder ini tidak dibuat otomatis oleh pekerjaan kerangka.

Jika mengambil repo untuk kolaborasi, clone lebih dahulu agar riwayat Git ada.
Jika root clone sudah memuat `.git`, pertahankan `.git` milik clone saat menyalin
isi kerangka. Jangan menyalin `.git`, `build`, `.dart_tool`, atau local.properties
dari workspace pembuat. Jangan menjalankan flutter create lagi setelah clone.

## 2. Periksa alat dan identitas pribadi

Di terminal baru: `flutter --version`, `dart --version`, `flutter doctor -v`,
`flutter doctor --android-licenses`, `git --version`. Pasang Flutter SDK, Android
SDK/Platform-Tools/Build-Tools/Command-line Tools dan Java yang kompatibel.
Ekstensi Flutter/Dart VS Code membantu mengedit; bukan pengganti SDK.

Di root clone kelompok, periksa `git config user.name` dan `git config user.email`.
Set dengan nama serta email GitHub sendiri menggunakan `git config user.name
"NAMA SENDIRI"` dan `git config user.email "EMAIL GITHUB SENDIRI"`.
Jangan memakai identitas Fauzi pada laptop anggota lain.

## 3. Terminal A - SERVER

Terminal > New Terminal. Mulai di root, masuk ke server sekali:

```powershell
cd .\server
dart pub get
dart run bin/server.dart
```

Biarkan hidup. Buka **http://localhost:8080/ukm** pada browser laptop. Lima UKM
contoh adalah kondisi awal yang disengaja; Djalil wajib melengkapinya menjadi
minimal 12 dan mengerjakan filter. `0.0.0.0` bukan alamat tujuan browser.

## 4A. Terminal B - APP dengan emulator

Buka Android Studio > Device Manager; tekan Play pada emulator yang sudah ada.
Tunggu Android siap. Buat terminal kedua lewat tombol +, pastikan di root:

```powershell
cd .\app
flutter pub get
flutter devices
flutter run -d emulator-5554 --dart-define=API_URL=http://10.0.2.2:8080
```

Ganti emulator-5554 dengan ID Android yang benar dari flutter devices. Jangan
menyalin Windows/Chrome/Edge sebagai bagian ID. Server tidak menyala otomatis
karena emulator menyala. Menekan ikon lama tidak membuktikan source terbaru.

## 4B. Alternatif Samsung/HP melalui USB

Aktifkan Developer options (ketuk Build number tujuh kali), USB debugging,
sambungkan kabel data, buka kunci HP, izinkan dialog RSA komputer sendiri.
Pastikan `flutter devices` menampilkan HP siap; periksa driver bila tidak muncul.
Pada Terminal B di app, isi ID HP dan lokasi ADB laptop masing-masing:

```powershell
$hpId = 'GANTI_DENGAN_ID_HP'
$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
& $adb -s $hpId reverse tcp:8080 tcp:8080
flutter run -d $hpId --dart-define=API_URL=http://127.0.0.1:8080
```

127.0.0.1 bisa dipakai di HP karena reverse aktif. Periksa ulang setelah kabel
dicabut/restart. Alternatif tanpa reverse: HP/laptop satu LAN, server bind
0.0.0.0, izinkan firewall privat yang diperlukan, ambil IPv4 laptop lewat
ipconfig. Coba `http://IP_LAPTOP:8080/ukm` dari browser HP, lalu gunakan
`--dart-define=API_URL=http://IP_LAPTOP:8080`. Jangan matikan seluruh firewall.

## 5. Coding, berhenti, dan verifikasi

- Buat branch peran, baca [OWNERSHIP.md](OWNERSHIP.md), cari BEGIN region di kode.
- Simpan source; tekan r pada terminal Flutter untuk hot reload, R untuk hot
  restart. Mengubah API_URL perlu stop/run ulang, bukan hanya reload.
- q menghentikan sesi Flutter; Ctrl+C pada **terminal server pemilik proses**
  menghentikan API. Ctrl+C pada terminal lain tidak mematikan server tersebut.
- State minat hanya memori sesi. Restart proses dapat mengosongkan daftar.
- Dari app: `flutter analyze`, `flutter test`. Dari server: `dart analyze`,
  `dart test`. Dari root: `python tools/update_maps.py` setelah format/edit.
- Tidak ada helper berisi path D/cache/emulator Fauzi yang menjadi syarat teman.

## 6. Mengirim perubahan ketika repo kelompok sudah siap

Di root clone bersih: `git switch main`, `git pull --ff-only`, lalu
`git switch -c feat/NAMA-MODUL` dengan nama branch sendiri. Tinjau git diff,
stage file yang benar-benar dikerjakan, commit perubahan bermakna, kemudian
`git push -u origin NAMA_BRANCH`. Buka PR ke main; Fauzi meninjau/menggabungkan.
Commit merekam perubahan, push mengirim commit; PDF tidak memberi minimum push.

Repo tujuan: https://github.com/fauziachmadk/UKM-HUB-KELOMPOK7.
Kerangka ini belum diunggah/di-merge otomatis. Setiap anggota harus memahami,
menguji, dan menjelaskan kontribusi yang benar-benar dia kerjakan.
