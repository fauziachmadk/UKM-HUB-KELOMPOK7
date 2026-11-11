# UKM Hub — Kelompok 07

UKM Hub adalah aplikasi katalog unit kegiatan mahasiswa untuk proyek UTS mata kuliah Pengembangan Aplikasi Bergerak. Kelompok 07 mengerjakan Proyek 4 dengan aplikasi Flutter dan REST API Dart berbasis Shelf.

Aplikasi menyediakan katalog UKM, informasi organisasi, filter bidang, dan formulir minat bergabung. Repository kelompok tersedia di [GitHub](https://github.com/fauziachmadk/UKM-HUB-KELOMPOK7).

## 1. Anggota dan pembagian tugas

| Nama | NIM | Tugas |
| --- | --- | --- |
| Fauzi Achmad Koesnaedi | 102022300352 | Struktur aplikasi, tema, dan integrasi |
| Muhammad Azka Azkiya | 102022300166 | Halaman Jelajah, kartu UKM, dan halaman detail |
| Vanesa Rizka Alfatihah | 102022300121 | Form minat bergabung dan Pendaftaran Saya |
| Muhammad Aditya Djalil | 102022300225 | Server Shelf, dataset JSON, dan pengujian server |
| Arief Setiawan | 102022300098 | Layanan HTTP dan pengujian aplikasi |

Riwayat commit dan pull request mencatat perubahan yang dikerjakan setiap anggota.

## 2. Cara menjalankan

### Persiapan

Siapkan Flutter stable dengan versi Dart yang memenuhi ketentuan SDK `^3.10.0`, Android SDK, JDK yang sesuai, serta emulator atau HP Android dengan USB debugging. Koneksi internet diperlukan untuk mengunduh dependensi pertama kali.

Periksa lingkungan dan perangkat:

```powershell
flutter doctor -v
flutter devices
```

Buka folder utama repository yang berisi `app/` dan `server/`. Jalankan server dan aplikasi pada dua terminal berbeda.

### Menjalankan server

Pada terminal pertama, dari folder utama repository:

```powershell
cd server
dart pub get
dart run bin/server.dart
```

Server memuat 15 UKM dari `data/ukm.json` dan berjalan pada port 8080. Buka [katalog JSON](http://localhost:8080/ukm) melalui browser komputer. Biarkan terminal server tetap berjalan selama aplikasi digunakan.

Secara default, server menerima koneksi pada `0.0.0.0`. Untuk mengaksesnya dari komputer yang sama, gunakan `localhost`. Pengaturan host dan port dapat diubah melalui variabel lingkungan `HOST` dan `PORT`.

### Menjalankan aplikasi pada emulator

Nyalakan emulator Android. Pada terminal kedua, dari folder utama repository:

```powershell
cd app
flutter pub get
flutter run --dart-define=API_URL=http://10.0.2.2:8080
```

Alamat `10.0.2.2` digunakan emulator Android standar untuk mengakses komputer host. Jika terdapat beberapa perangkat, pilih ID yang ditampilkan oleh `flutter devices`. Contoh:

```powershell
flutter run -d emulator-5554 --dart-define=API_URL=http://10.0.2.2:8080
```

Ganti `emulator-5554` sesuai ID emulator yang digunakan.

### Menjalankan aplikasi pada HP melalui jaringan lokal

Hubungkan HP dan komputer server ke jaringan lokal yang sama. Cari IPv4 komputer menggunakan `ipconfig`, lalu gunakan alamat tersebut pada `API_URL`. Dari folder `app`, contoh perintahnya:

```powershell
flutter run --dart-define=API_URL=http://192.168.1.10:8080
```

Ganti IP contoh dengan IP komputer server. Pastikan HP terdeteksi oleh `flutter devices` dan akses port 8080 diizinkan pada jaringan privat. Alamat `localhost` pada HP merujuk ke HP itu sendiri.

Setelah mengganti `API_URL`, hentikan sesi aplikasi sebelumnya dan jalankan kembali agar konfigurasi baru digunakan.

### Endpoint API

| Metode | Endpoint | Respons |
| --- | --- | --- |
| GET | `/ukm` | Daftar seluruh UKM dalam array JSON |
| GET | `/ukm/<id>` | Satu objek UKM berdasarkan ID |
| GET | `/ukm?bidang=Teknologi` | Daftar UKM bidang Teknologi yang difilter oleh server |

Contoh URL untuk membuka detail Aksara adalah `http://localhost:8080/ukm/aksara`.

Permintaan yang berhasil mendapat status `200`. ID atau endpoint yang tidak ditemukan mendapat status `404` dengan pesan JSON. Filter yang tidak memiliki hasil mengembalikan array kosong.

### Penggunaan aplikasi

1. Buka Jelajah untuk melihat katalog UKM.
2. Pilih bidang atau gunakan kolom pencarian untuk menemukan UKM.
3. Ketuk kartu untuk membuka informasi lengkap UKM.
4. Pada UKM yang membuka rekrutmen, tekan Saya berminat.
5. Isi nama, NIM, dan alasan bergabung, lalu simpan. UKM pilihan sudah ditampilkan pada form.
6. Hasil pendaftaran minat muncul pada Pendaftaran Saya dan dapat diubah atau dihapus.
7. Gunakan pengaturan tema pada Profil atau tombol di header Jelajah untuk mengganti tema.

Data UKM merupakan contoh untuk pembelajaran. Pendaftaran minat disimpan selama sesi aplikasi dan tidak dikirim kepada pengurus UKM. Setiap UKM hanya dapat didaftari sekali dalam satu sesi. Data sesi dapat hilang setelah aplikasi dimulai ulang.

## 3. Screenshot Android

<!-- SCREENSHOTS:START -->
Seluruh 16 screenshot dalam folder `screenshots/` ditampilkan di bawah ini.

| Jelajah - tampilan awal | Detail UKM - tampilan awal |
| --- | --- |
| ![Jelajah - tampilan awal](screenshots/01-jelajah.png) | ![Detail UKM - tampilan awal](screenshots/02-detail.png) |

| Form minat - tampilan awal | Pendaftaran Saya - tampilan awal |
| --- | --- |
| ![Form minat - tampilan awal](screenshots/03-form.png) | ![Pendaftaran Saya - tampilan awal](screenshots/04-pendaftaran.png) |

| Profil | Jelajah dengan tema gelap - tampilan awal |
| --- | --- |
| ![Profil](screenshots/05-profil.png) | ![Jelajah dengan tema gelap - tampilan awal](screenshots/06-jelajah-gelap.png) |

| Filter bidang Teknologi | Pesan gagal saat server dimatikan |
| --- | --- |
| ![Filter bidang Teknologi](screenshots/07-filter-teknologi.png) | ![Pesan gagal saat server dimatikan](screenshots/08-server-mati.png) |

| Katalog setelah Coba lagi berhasil | Jelajah dengan pilihan tema |
| --- | --- |
| ![Katalog setelah Coba lagi berhasil](screenshots/09-retry-berhasil.png) | ![Jelajah dengan pilihan tema](screenshots/10-jelajah-tema.png) |

| Detail dan identitas UKM | Form minat dengan identitas UKM |
| --- | --- |
| ![Detail dan identitas UKM](screenshots/11-detail-identitas.png) | ![Form minat dengan identitas UKM](screenshots/12-form-identitas.png) |

| Hasil pada Pendaftaran Saya | UKM yang sudah didaftari |
| --- | --- |
| ![Hasil pada Pendaftaran Saya](screenshots/13-pendaftaran-tunggal.png) | ![UKM yang sudah didaftari](screenshots/14-detail-terkunci.png) |

| Jelajah dengan tema gelap | Informasi kegiatan UKM |
| --- | --- |
| ![Jelajah dengan tema gelap](screenshots/15-jelajah-gelap.png) | ![Informasi kegiatan UKM](screenshots/16-detail-kegiatan.png) |

Screenshot diambil pada emulator Android saat pengujian versi pengembangan tanggal 11 November 2026. Rincian asal gambar tersedia pada [catatan screenshot](screenshots/README.md) dan [catatan QA](docs/QA.md#asal-screenshot-yang-disertakan). Pengujian perangkat setelah penggabungan perubahan belum diulang; perbarui gambar jika versi yang dikumpulkan berbeda.
<!-- SCREENSHOTS:END -->

## 4. Tabel pemenuhan fitur UTS

Tabel berikut memuat 28 poin pemeriksaan dari Bagian 3 panduan UTS. Lokasi file dihitung dari folder utama repository. Hasil pengujian tanggal 12 November 2026 tercatat pada [catatan QA](docs/QA.md#pemeriksaan-versi-gabungan-12-november-2026).

<!-- CHECKLIST:BEGIN -->
| Poin | File:baris | Keterangan |
| --- | --- | --- |
| P01–P02: 1. Pembuatan proyek dan nama paket | [docs/QA.md:9](docs/QA.md#L9); [app/android/app/build.gradle.kts:19](app/android/app/build.gradle.kts#L19) | Proyek dibuat dengan organisasi id.ac.telkomuniversity; nama paket Android id.ac.telkomuniversity.ukm_hub. |
| P01–P02: 2. Nama aplikasi pada launcher | [app/android/app/src/main/AndroidManifest.xml:4](app/android/app/src/main/AndroidManifest.xml#L4) | Nama aplikasi yang ditampilkan adalah UKM Hub. |
| P01–P02: 3. Android dan minimal 4 screenshot | [screenshots/README.md:1](screenshots/README.md#L1) | Seluruh 16 screenshot Android ditampilkan pada bagian 3. Asal gambar dan catatan pengujian perangkat dijelaskan pada QA. |
| P01–P02: 4. Hasil flutter analyze | [docs/QA.md:54](docs/QA.md#L54) | flutter analyze selesai tanpa error maupun warning pada 12 November 2026. |
| P03: 1. StatelessWidget, StatefulWidget, dan setState | [app/lib/widgets/ukm_card.dart:8](app/lib/widgets/ukm_card.dart#L8); [app/lib/screens/main_page.dart:17](app/lib/screens/main_page.dart#L17); [app/lib/screens/main_page.dart:56](app/lib/screens/main_page.dart#L56) | UkmCard menggunakan StatelessWidget; MainPage menggunakan StatefulWidget dan setState untuk memperbarui tampilan. |
| P03: 2. TextField, controller, dan dispose | [app/lib/screens/jelajah_page.dart:199](app/lib/screens/jelajah_page.dart#L199); [app/lib/screens/jelajah_page.dart:46](app/lib/screens/jelajah_page.dart#L46) | Kolom pencarian menggunakan controller yang ditutup melalui dispose. |
| P03: 3. Minimal 2 jenis tombol Material 3 | [app/lib/screens/registration_form.dart:219](app/lib/screens/registration_form.dart#L219); [app/lib/screens/registration_form.dart:232](app/lib/screens/registration_form.dart#L232) | Form menyediakan FilledButton dan OutlinedButton. IconButton juga digunakan pada aplikasi. |
| P03: 4. Pilihan menggunakan chip | [app/lib/screens/jelajah_page.dart:226](app/lib/screens/jelajah_page.dart#L226) | ChoiceChip menyediakan pilihan Semua dan lima bidang UKM. |
| P03: 5. Umpan balik menggunakan SnackBar | [app/lib/screens/main_page.dart:62](app/lib/screens/main_page.dart#L62) | SnackBar menampilkan pesan penyimpanan minat dan menyediakan aksi Urungkan setelah penghapusan. |
| P04: 1. Model minimal 6 field, DateTime, dan bool | [app/lib/models/ukm.dart:8](app/lib/models/ukm.dart#L8); [app/lib/models/ukm.dart:25](app/lib/models/ukm.dart#L25); [app/lib/models/ukm.dart:26](app/lib/models/ukm.dart#L26) | Ukm memiliki delapan field utama, termasuk bukaRekrutmen bertipe bool dan berdiri bertipe DateTime. |
| P04: 2. Kartu dengan Row, Column, Expanded, dan Stack | [app/lib/widgets/ukm_card.dart:87](app/lib/widgets/ukm_card.dart#L87); [app/lib/widgets/ukm_card.dart:31](app/lib/widgets/ukm_card.dart#L31); [app/lib/widgets/ukm_card.dart:34](app/lib/widgets/ukm_card.dart#L34); [app/lib/widgets/ukm_card.dart:35](app/lib/widgets/ukm_card.dart#L35) | UkmCard menyusun logo, informasi UKM, dan lencana rekrutmen menggunakan keempat widget tersebut. |
| P04: 3. Daftar menggunakan builder | [app/lib/screens/jelajah_page.dart:344](app/lib/screens/jelajah_page.dart#L344) | Katalog UKM ditampilkan menggunakan GridView.builder. |
| P04: 4. NavigationBar minimal 3 tab dan IndexedStack | [app/lib/screens/main_page.dart:135](app/lib/screens/main_page.dart#L135); [app/lib/screens/main_page.dart:168](app/lib/screens/main_page.dart#L168) | Tersedia tab Jelajah, Pendaftaran Saya, dan Profil; IndexedStack mempertahankan halaman saat berpindah tab. |
| P05: 1. Detail menerima objek melalui konstruktor | [app/lib/screens/main_page.dart:37](app/lib/screens/main_page.dart#L37); [app/lib/screens/detail_page.dart:14](app/lib/screens/detail_page.dart#L14) | Navigator.push membuka DetailPage dengan objek Ukm melalui konstruktor. |
| P05: 2. Form mengembalikan data dan memperbarui daftar | [app/lib/screens/registration_form.dart:59](app/lib/screens/registration_form.dart#L59); [app/lib/screens/main_page.dart:37](app/lib/screens/main_page.dart#L37); [app/lib/screens/main_page.dart:57](app/lib/screens/main_page.dart#L57) | Form mengembalikan data melalui Navigator.pop. MainPage menunggu hasil dengan await, menambah data, lalu membuka Pendaftaran Saya. |
| P05: 3. Pemeriksaan mounted setelah await | [app/lib/screens/main_page.dart:48](app/lib/screens/main_page.dart#L48); [app/lib/screens/detail_page.dart:58](app/lib/screens/detail_page.dart#L58) | mounted diperiksa sebelum memakai context atau memperbarui state setelah await. |
| P05: 4. Minimal 3 widget test dan hasil pengujian | [app/test/flows_test.dart:74](app/test/flows_test.dart#L74); [docs/QA.md:54](docs/QA.md#L54) | Sebanyak 12 widget test dan 5 tes layanan lulus pada 12 November 2026. |
| P06: 1. ThemeData, ColorScheme.fromSeed, dan darkTheme | [app/lib/core/theme.dart:12](app/lib/core/theme.dart#L12); [app/lib/core/app.dart:32](app/lib/core/app.dart#L32) | Aplikasi menyediakan tema terang dan gelap dengan warna dasar hijau. |
| P06: 2. Warna widget dari ColorScheme | [app/lib/widgets/ukm_card.dart:21](app/lib/widgets/ukm_card.dart#L21) | Warna widget diambil dari ColorScheme pada tema aplikasi. |
| P06: 3. Font kustom | [app/pubspec.yaml:22](app/pubspec.yaml#L22) | Font Manrope disimpan sebagai aset lokal dan disertai lisensi SIL OFL. |
| P06: 4. Ikon launcher sendiri | [app/pubspec.yaml:16](app/pubspec.yaml#L16); [app/android/app/src/main/AndroidManifest.xml:6](app/android/app/src/main/AndroidManifest.xml#L6) | Ikon UKM Hub dibuat menggunakan flutter_launcher_icons dan digunakan pada launcher Android. |
| P06: 5. Gambar aset lokal | [app/pubspec.yaml:20](app/pubspec.yaml#L20); [app/lib/widgets/hub_widgets.dart:25](app/lib/widgets/hub_widgets.dart#L25) | Aset gambar didaftarkan dalam pubspec dan logo ditampilkan melalui UkmLogo. |
| P07: 1. Shelf, Shelf Router, dan minimal 12 item JSON | [server/pubspec.yaml:8](server/pubspec.yaml#L8); [server/pubspec.yaml:9](server/pubspec.yaml#L9); [server/data/ukm.json:2](server/data/ukm.json#L2) | Server menggunakan shelf dan shelf_router. Dataset berisi 15 UKM dalam lima bidang. |
| P07: 2. GET daftar, detail, dan endpoint khas | [server/lib/api.dart:13](server/lib/api.dart#L13); [server/lib/api.dart:14](server/lib/api.dart#L14); [server/lib/api.dart:26](server/lib/api.dart#L26) | API menyediakan daftar UKM, detail berdasarkan ID, dan filter bidang pada server. |
| P07: 3. Paket http dan konfigurasi API_URL | [app/lib/services/api_service.dart:5](app/lib/services/api_service.dart#L5); [app/lib/services/api_service.dart:27](app/lib/services/api_service.dart#L27) | ApiService menggunakan paket http; alamat server ditentukan melalui API_URL saat menjalankan aplikasi. |
| P07: 4. fromJson, toJson, dan konversi DateTime | [app/lib/models/ukm.dart:38](app/lib/models/ukm.dart#L38); [app/lib/models/ukm.dart:45](app/lib/models/ukm.dart#L45); [app/lib/models/ukm.dart:52](app/lib/models/ukm.dart#L52) | Model menyediakan fromJson dan toJson dengan konversi tanggal ISO ke DateTime dan sebaliknya. |
| P07: 5. FutureBuilder dengan tiga keadaan | [app/lib/screens/jelajah_page.dart:241](app/lib/screens/jelajah_page.dart#L241); [app/lib/screens/jelajah_page.dart:258](app/lib/screens/jelajah_page.dart#L258); [app/lib/screens/jelajah_page.dart:267](app/lib/screens/jelajah_page.dart#L267) | FutureBuilder menampilkan keadaan memuat, pesan gagal dengan tombol Coba lagi, dan katalog saat berhasil. |
| P07: 6. Pengujian menggunakan MockClient | [app/test/api_service_test.dart:20](app/test/api_service_test.dart#L20); [docs/QA.md:54](docs/QA.md#L54) | Lima tes MockClient lulus, mencakup filter, detail, status HTTP, format JSON, dan kegagalan koneksi. |
<!-- CHECKLIST:END -->

Untuk memperbarui nomor baris setelah perubahan kode, jalankan dari folder utama repository:

```powershell
python tools/update_maps.py --readme-only
```

## 5. Pengujian dan pembuatan APK

### Pengujian server

Dari folder utama repository:

```powershell
cd server
dart pub get
dart analyze
dart test
```

Pengujian mencakup kelengkapan dataset, daftar UKM, detail, filter bidang, dan respons untuk data yang tidak ditemukan. Pemeriksaan logo pada dataset memerlukan aset di folder `app/assets`.

### Pengujian aplikasi

Pada terminal lain, dari folder utama repository:

```powershell
cd app
flutter pub get
flutter analyze
flutter test --concurrency=1
```

Pada pemeriksaan 12 November 2026, analisis server dan Flutter selesai tanpa error maupun warning. Seluruh tes lulus: 5 tes server dan 17 tes Flutter, terdiri atas 12 widget test dan 5 tes layanan dengan MockClient. Rincian hasil tersedia pada [docs/QA.md](docs/QA.md#pemeriksaan-versi-gabungan-12-november-2026).

### Membuat APK debug

Dari folder `app`:

```powershell
flutter build apk --debug --dart-define=API_URL=http://10.0.2.2:8080
```

APK dihasilkan pada `app/build/app/outputs/flutter-apk/app-debug.apk`. Perintah tersebut menggunakan alamat server untuk emulator. Untuk penggunaan pada HP melalui jaringan lokal, ganti `API_URL` dengan IP komputer server saat build.

## 6. Fitur khas UKM Hub

| Ketentuan Proyek 4 | Implementasi |
| --- | --- |
| Model Ukm | id, nama, bidang, ketua, jumlahAnggota, bukaRekrutmen, berdiri, dan logo |
| Lima bidang | Olahraga, Seni, Teknologi, Keagamaan, dan Sosial |
| Tiga tab | Jelajah, Pendaftaran Saya, dan Profil |
| Form minat bergabung | Nama, NIM, UKM pilihan, dan alasan multi-baris |
| Katalog berisi logo | GridView.builder dengan aset logo lokal |
| Lencana Open Recruitment | Stack dan Positioned pada kartu UKM |
| Filter bidang | GET /ukm?bidang=... dengan penyaringan pada server |

Fitur tambahan yang tersedia adalah pull-to-refresh dan animasi Hero antara kartu dan halaman detail. POST pendaftaran belum diterapkan. Penyimpanan hasil form di memori aplikasi memenuhi ketentuan wajib UTS.

## 7. Video demo dan pengumpulan

**Tautan video demo: belum diisi.**

Sesuai panduan UTS, video berdurasi 3-5 menit dan menampilkan:

1. Proses menyalakan server.
2. Aplikasi memuat data dari server.
3. Keadaan gagal saat server dimatikan, kemudian berhasil setelah server dinyalakan dan Coba lagi ditekan.
4. Semua tab aplikasi.
5. Halaman detail UKM.
6. Pengisian form sampai data muncul di daftar.
7. Hasil `flutter test`.

Untuk menguji keadaan gagal, lakukan refresh atau ubah filter setelah server dimatikan agar aplikasi mengirim permintaan baru.

Satu anggota mengumpulkan berkas atas nama kelompok melalui LMS:

- Tautan repository yang dapat diakses dosen.
- ZIP isi repository tanpa folder `build/`, `.dart_tool/`, dan `android/.gradle/`.
- APK debug.
- Tautan video demo melalui YouTube unlisted atau Google Drive.

Lengkapi tautan video dan pastikan source code, screenshot, APK, serta video sesuai dengan versi yang dikumpulkan. Tenggat pengumpulan mengikuti ketentuan pada LMS.

## 8. Struktur proyek

```text
UKM-HUB-KELOMPOK7/
  app/                   Aplikasi Flutter, aset, dan pengujian
  server/
    bin/server.dart      Menjalankan server dan membaca dataset
    lib/api.dart         Endpoint API dan respons JSON
    data/ukm.json        Dataset 15 UKM
    test/                Pengujian server
  screenshots/           Screenshot Android
  docs/                  Catatan QA dan panduan proyek
  tools/                 Skrip pembaruan dokumentasi
  README.md
```

Dokumentasi pendukung: [panduan memulai](docs/START_HERE.md), [pembagian modul](docs/OWNERSHIP.md), dan [daftar tugas](docs/TASKS.md). Font Manrope disertai lisensi SIL OFL pada `app/assets/fonts/Manrope-OFL.txt`.
