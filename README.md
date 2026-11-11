# UKM Hub - Kerangka Kelompok 07

**Fondasi kolaborasi yang bisa dijalankan, belum aplikasi UTS final.** Struktur
app/server/kontrak dan alur minat dasar sudah tersedia. Tiap anggota mengerjakan
implementasi substansial di regionnya; jangan hanya mengganti komentar/nama.
DEV terpisah menjadi acuan perilaku/desain lengkap.

Repo tujuan: https://github.com/fauziachmadk/UKM-HUB-KELOMPOK7.
Folder ini belum di-push/di-merge otomatis ke repo tersebut. Penanggung jawab
di bawah adalah pembagian kerja, bukan klaim semua anggota menulis fondasi.

| Anggota | NIM | Tugas |
| --- | --- | --- |
| Fauzi Achmad Koesnaedi | 102022300352 | Core/theme/model bersama/navigasi/state/Profil/integrasi |
| Muhammad Azka Azkiya | 102022300166 | Jelajah, kartu, tampilan detail |
| Vanesa Rizka Alfatihah | 102022300121 | Form, daftar minat, handoff detail |
| Muhammad Aditya Djalil | 102022300225 | Shelf, JSON, filter, tes backend |
| Arief Setiawan | 102022300098 | HTTP client, MockClient, widget test, QA |

## Baca sebelum coding

1. [START_HERE](docs/START_HERE.md): setup, terminal, emulator/HP, Git.
2. [OWNERSHIP](docs/OWNERSHIP.md): file dan nomor baris region tiap anggota.
3. [TASKS](docs/TASKS.md): langkah dan kriteria selesai masing-masing.
4. [Arsitektur](docs/ARCHITECTURE.md), [Desain](docs/DESIGN.md),
   [Panduan kode](docs/CODE_GUIDE.md), [QA](docs/QA.md).

Di kode cari `BEGIN UKM07-NAMA-...` sampai `END ... - NAMA SAMPAI SINI`.
Nomor baris aktual ada pada OWNERSHIP dan dapat berubah setelah edit/format.
File bersama detail dibagi jelas: Fauzi constructor, Azka view, Vanesa handoff.
Konfigurasi platform hasil flutter create dikelola Fauzi, bukan region anggota.

## Menjalankan - dua terminal berbeda

Alat: Flutter/Dart, Git, Android SDK dan Java kompatibel. Versi acuan DEV:
Flutter 3.47.5 / Dart 3.13.4; batas Dart source ^3.10.0. Periksa flutter doctor -v.
Jangan menjalankan flutter create lagi pada source yang sudah di-clone.

Terminal A, dari root:

```powershell
cd .\server
dart pub get
dart run bin/server.dart
```

Buka **http://localhost:8080/ukm** di browser laptop. Biarkan terminal hidup.
Tekan Ctrl+C di terminal pemilik server untuk menghentikannya.

Terminal B, dari root; nyalakan AVD yang sudah tersedia pada Device Manager:

```powershell
cd .\app
flutter pub get
flutter devices
flutter run -d emulator-5554 --dart-define=API_URL=http://10.0.2.2:8080
```

Ganti ID dengan perangkat Android yang tampil. Untuk HP USB gunakan ADB reverse
dan API_URL=http://127.0.0.1:8080, atau Wi-Fi bersama dan IP LAN laptop. Langkah
lengkap [di sini](docs/START_HERE.md#4b-alternatif-samsunghp-melalui-usb).
API_URL adalah URL dasar tanpa /ukm. Nilai define berubah setelah stop/run ulang.

Folder source boleh ditempatkan di
`D:\ENJOY-CODE\Flutter-Project\UKM-HUB-KELOMPOK7`; lokasi tersebut tidak dibuat
oleh kerangka. Tidak perlu mengunduh emulator baru per proyek. Jangan membawa
AVD, cache Gradle, SDK, build atau junction dari komputer Fauzi ke repo kelompok.

## Kondisi awal yang disengaja

- 5 UKM contoh (lima bidang), bukan 12+ yang diperlukan final.
- GET /ukm dan GET /ukm/{id} bekerja. Query bidang backend masih 501; client
  filter/detail belum diimplementasikan penuh oleh Arief. UI belum memiliki filter/search.
- Kartu/grid/detail dasar, belum layout final Stack/Positioned/konteks kaya.
- Form menolak kosong dan mengembalikan data; alasan masih satu baris dan
  validasi rinci belum ada. Daftar belum memiliki UI edit/hapus.
- Root sudah melindungi satu minat per UKM dan menyediakan handler edit/hapus/undo;
  Vanesa menghubungkan UI. Tidak ada auth, persistensi/POST, cloud DB, atau admin.
- Baseline memiliki 4 widget test + 1 MockClient dan 3 tes server. Cakupan final
  masih pekerjaan anggota. Hasil pemeriksaan aktual ada di docs/QA.md.

## Screenshot dan bukti perangkat

Minimal 4 screenshot Android final **belum tersedia**. Lihat
[screenshots/README.md](screenshots/README.md). Capture smoke-test kerangka jika
tersedia dicatat pada QA, bukan dipakai mengklaim seluruh fitur kelompok selesai.

## Tabel 28 poin pemeriksaan UTS

Satu baris per poin Bagian 3. Status jujur kerangka; path:baris menunjuk source
dasar atau lokasi tugas yang nyata, bukan klaim fitur final telah selesai.
Sesudah edit/format, dari root jalankan `python tools/update_maps.py`.

<!-- CHECKLIST:BEGIN -->
| Poin | File:baris aktual | Status kerangka |
| --- | --- | --- |
| P01/P02-1 org/paket | [app/android/app/build.gradle.kts:19](app/android/app/build.gradle.kts#L19) | Dasar tersedia: id.ac.telkomuniversity.ukm_hub; flutter create sesuai org. |
| P01/P02-2 launcher | [app/android/app/src/main/AndroidManifest.xml:4](app/android/app/src/main/AndroidManifest.xml#L4) | Nama UKM Hub dan ikon lokal; QA perangkat dicatat terpisah. |
| P01/P02-3 Android/4 capture | [screenshots/README.md:1](screenshots/README.md#L1) | Belum final: perlu run versi gabungan dan minimal 4 screenshot perangkat. |
| P01/P02-4 analyze | [docs/QA.md:1](docs/QA.md#L1) | Lihat hasil aktual QA; wajib diulang setelah implementasi anggota. |
| P03-1 widget/state | [app/lib/screens/main_page.dart:17](app/lib/screens/main_page.dart#L17) | Dasar: custom Stateful/Stateless dan setState pada integrasi. |
| P03-2 controller/dispose | [app/lib/screens/registration_form.dart:41](app/lib/screens/registration_form.dart#L41) | Dasar tersedia; validasi akhir dan multiline tugas Vanesa. |
| P03-3 dua tombol M3 | [app/lib/screens/jelajah_page.dart:38](app/lib/screens/jelajah_page.dart#L38) | Dasar IconButton dan FilledButton; OutlinedButton pada daftar/Profil. |
| P03-4 pilihan | [app/lib/screens/profile_page.dart:104](app/lib/screens/profile_page.dart#L104) | Dasar pilihan tema; chip bidang Jelajah belum dibuat Azka. |
| P03-5 SnackBar | [app/lib/screens/main_page.dart:51](app/lib/screens/main_page.dart#L51) | Dasar feedback minat; uji gabungan tetap diperlukan. |
| P04-1 model 6+/tanggal/bool | [app/lib/models/ukm.dart:26](app/lib/models/ukm.dart#L26) | Kontrak model tersedia, termasuk bool dan DateTime. |
| P04-2 custom card layout | [app/lib/widgets/ukm_card.dart:8](app/lib/widgets/ukm_card.dart#L8) | Belum: Row/Column/Expanded/Stack dan Positioned badge tugas Azka. |
| P04-3 builder | [app/lib/screens/jelajah_page.dart:80](app/lib/screens/jelajah_page.dart#L80) | Grid dasar tersedia; filter/search/responsif perlu diselesaikan. |
| P04-4 tiga tab/IndexedStack | [app/lib/screens/main_page.dart:135](app/lib/screens/main_page.dart#L135) | Dasar tersedia: Jelajah, Pendaftaran Saya, Profil. |
| P05-1 detail constructor | [app/lib/screens/main_page.dart:40](app/lib/screens/main_page.dart#L40) | Ukm diteruskan melalui push dan constructor. |
| P05-2 pop/await/data langsung | [app/lib/screens/registration_form.dart:64](app/lib/screens/registration_form.dart#L64) | Alur dasar tersedia; validasi/list akhir masih tugas Vanesa. |
| P05-3 mounted | [app/lib/screens/detail_page.dart:47](app/lib/screens/detail_page.dart#L47) | Guard dasar tersedia setelah await; jaga saat mengembangkan. |
| P05-4 tiga widget test | [app/test/flows_test.dart:51](app/test/flows_test.dart#L51) | 4 widget test dasar; cakupan final dikembangkan Arief. |
| P06-1 seed/darkTheme | [app/lib/core/app.dart:33](app/lib/core/app.dart#L33) | Dua tema dan ColorScheme.fromSeed pada core/theme tersedia. |
| P06-2 warna skema | [app/lib/widgets/hub_widgets.dart:31](app/lib/widgets/hub_widgets.dart#L31) | Widget memakai skema; jaga maksimal 3 Colors.xxx saat pengembangan. |
| P06-3 font | [app/pubspec.yaml:22](app/pubspec.yaml#L22) | Font lokal Manrope dengan lisensi OFL. |
| P06-4 ikon | [app/pubspec.yaml:16](app/pubspec.yaml#L16) | Generator ikon dan aset disediakan; hasil perangkat di QA. |
| P06-5 aset lokal | [app/pubspec.yaml:20](app/pubspec.yaml#L20) | Logo/ilustrasi terdaftar; UkmLogo dipakai kartu/detail. |
| P07-1 Shelf/12 JSON | [server/data/ukm.json:3](server/data/ukm.json#L3) | Sebagian: Shelf/router ada, seed baru 5; Djalil wajib 12+. |
| P07-2 tiga GET/filter | [server/lib/api.dart:19](server/lib/api.dart#L19) | Sebagian: daftar/detail ada; filter bidang masih 501, belum memenuhi final. |
| P07-3 http/API_URL | [app/lib/services/api_service.dart:26](app/lib/services/api_service.dart#L26) | GET daftar dasar; Arief melengkapi query/detail/error/timeout. |
| P07-4 JSON/DateTime | [app/lib/models/ukm.dart:45](app/lib/models/ukm.dart#L45) | fromJson/toJson tersedia; uji round-trip perlu ditambah. |
| P07-5 FutureBuilder | [app/lib/screens/jelajah_page.dart:51](app/lib/screens/jelajah_page.dart#L51) | Dasar loading/error/retry/sukses tersedia; perlu regresi Arief. |
| P07-6 MockClient | [app/test/api_service_test.dart:17](app/test/api_service_test.dart#L17) | 1 tes dasar; perlu variasi error dan query/detail. |
<!-- CHECKLIST:END -->

## Verifikasi dan pengumpulan

Dari app: `dart format lib test`, `flutter analyze`, `flutter test`.
Dari server: `dart format bin lib test`, `dart analyze`, `dart test`.
Build debug dari app:

```powershell
flutter build apk --debug --dart-define=API_URL=http://10.0.2.2:8080
```

Hasil: app/build/app/outputs/flutter-apk/app-debug.apk. APK contoh memakai alamat
emulator; sesuaikan untuk HP. Skrip opsional `tools/verify.ps1` memeriksa kedua
package tanpa path mesin Fauzi. Python hanya untuk generator peta/ZIP, bukan
syarat menjalankan aplikasi atau server.

UTS PAB Kelompok 07 / Proyek 4. Deadline PDF **12 November 2026, 23.59 WIB**
kecuali LMS mengubahnya. Final memerlukan repo dapat diakses dosen, ZIP tanpa
build/.dart_tool/android/.gradle, APK debug, video 3-5 menit menampilkan server,
data, gagal/retry, semua tab, detail, hasil form dan flutter test. Hero/refresh
boleh setelah wajib; POST opsional. Commit tiap anggota harus kontribusi nyata,
bukan ganti author pekerjaan orang lain. Tidak ada angka minimum push pada PDF.

Aset Manrope disertai lisensi OFL di app/assets/fonts/Manrope-OFL.txt. Data dan
logo adalah contoh tema, bukan klaim informasi UKM resmi universitas.
