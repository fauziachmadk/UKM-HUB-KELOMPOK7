# QA UKM Hub

Dokumen ini memisahkan hasil pemeriksaan fondasi terdahulu dan pemeriksaan
versi gabungan. Bagian riwayat dipertahankan sebagai bukti pada waktunya;
hasil terbaru dan batasnya tercatat pada bagian Pemeriksaan versi gabungan.

## Riwayat pemeriksaan fondasi - 11 November 2026

- Proyek dibuat memakai `flutter create --org id.ac.telkomuniversity
  --project-name ukm_hub app`; launcher UKM Hub dan ikon lokal digenerasikan.
- `flutter analyze`: No issues found. `flutter test --concurrency=1`: 5 lulus,
  terdiri dari 4 widget test dan 1 MockClient. Widget test mencakup tiga tab,
  constructor detail, form kembali/duplikat, dan kegagalan request/retry.
- Server `dart analyze`: No issues found; `dart test`: 3 lulus. Seed 5 id unik,
  tipe dasar/tanggal, katalog, dan 404 diuji. Target 12+ dan filter belum final.
- APK debug berhasil dibangun untuk API uji 18081 dan API normal 8080. Build
  memakai SDK/Gradle yang sudah ada, bukan mengunduh AVD baru atau menyalin cache.
- Android Emulator UKM_Hub_DEV, Android 17, emulator-5560, resolusi 1080x2400:
  katalog dari API sungguhan menampilkan 5 UKM; Aksara membuka detail; form berisi
  identitas demo menghasilkan satu record pada Pendaftaran Saya; detail UKM sama
  menampilkan Sudah terdaftar dengan enabled=false.
- API uji bind 127.0.0.1:18081, aplikasi mengakses 10.0.2.2:18081. Server uji
  dihentikan, aplikasi memicu request baru saat proses dimulai ulang, lalu error
  dan Coba lagi terlihat. API dinyalakan kembali; menekan Coba lagi memulihkan
  katalog tanpa restart aplikasi pada tahap pemulihan.
- Smoke test menemukan callback setState yang mengembalikan Future pada retry.
  Callback diperbaiki menjadi blok sinkron; tes regresi ditambah dan lulus.
  Pengujian Android error/retry kemudian diulang dengan APK hasil perbaikan.
- Tidak ada flutter:E/AndroidRuntime:E pada pemeriksaan log setelah uji akhir.
  SDK Java memberi peringatan native-access saat build, bukan error analyze;
  assembleDebug tetap berhasil. Tidak ada perubahan toolchain global.
- Server port 8080 pengguna tidak disentuh. Port 18081 diperiksa kosong dan
  emulator uji ditutup setelah pengujian, termasuk VM Dart anak pemilik port.
- Semua BEGIN/END diperiksa generator: 24 batas tugas termasuk dataset,
  masing-masing ID unik/berpasangan/tidak bersarang; 28 baris README diperbarui.
- Cache build lokal kerangka (sekitar 2 GB) dibersihkan setelah verifikasi;
  APK normal tetap disimpan di artifacts (diabaikan Git/ZIP). Jalankan pub get
  sebelum run pada source bersih. Cache SDK/Gradle bersama tidak dihapus.

APK normal API 8080: SHA-256
`c4cf48b11313441f1df7781f5de6826e084b7b9b7196ffb1afdc519530afbb57`.

## Bukti dan batas

Lihat [evidence/README.md](../evidence/README.md) untuk screenshot smoke-test
dan versi sumber terkait. Screenshot ini bukti alur dasar, bukan screenshot
fitur final kelompok. Tidak ada pengujian Samsung baru.

Belum final: dataset 12+, filter server/client/chips, pencarian nama, custom
card Stack/Positioned, detail kaya, alasan multiline/validasi rinci, UI edit/hapus,
cakupan QA anggota dan screenshot final. Lihat TASKS dan tabel status README.
Belum push/merge/publikasi kelompok, video, atau pengumpulan LMS.

## Pemeriksaan versi gabungan - 12 November 2026

Pemeriksaan di folder `D:\TUGAS UTS MOBILE APP\UKM-HUB-KELOMPOK7`,
pada source setelah commit `f198669`. Zona waktu: Asia/Jakarta (WIB).

| Perintah | Hasil yang diamati |
| --- | --- |
| `dart analyze` pada server | No issues found |
| `dart test` pada server | 5 tes lulus |
| `flutter analyze` pada app | No issues found |
| `flutter test --concurrency=1` pada app | 17 tes lulus: 12 widget dan 5 layanan MockClient |

Source dataset berisi 15 UKM. Pemeriksaan ini menjalankan analisis dan tes;
tidak membangun APK baru atau menjalankan ulang skenario Android setelah merge.
Pemberitahuan versi paket yang lebih baru saat pub get bukan error analisis.

### Asal screenshot yang disertakan

Empat gambar `10-jelajah-tema.png`, `11-detail-identitas.png`,
`12-form-identitas.png`, dan `13-pendaftaran-tunggal.png` tersedia di repo.
Checksum keempat file cocok dengan manifest sumber DEV yang dicatat pada
11 November 2026: emulator Android 17 / API 37 / x86_64, 1080 x 2400.
Capture tersebut menggunakan API uji 10.0.2.2:18080, dengan dataset contoh UKM.
Ini asal berkas gambar, bukan klaim capture ulang versi gabungan kelompok.
Lakukan verifikasi perangkat dan ambil capture baru bila versi source berbeda.

Tautan video demo belum diberikan. Build APK, demo perangkat versi gabungan,
dan pengumpulan LMS tidak dinyatakan selesai oleh pemeriksaan ini.

### Pemeriksaan dokumentasi

Tabel README diperbarui dari anchor source aktual: 28 poin Bagian 3 UTS.
Gunakan `python tools/update_maps.py --readme-only` untuk memperbarui tabel
tanpa mengubah peta region. Validasi seluruh peta region pada source gabungan
menemukan penanda region belum ditutup pada `app/lib/models/ukm.dart`.
Penanda kode tersebut tidak diubah dalam pekerjaan dokumentasi ini;
analisis dan tes Dart/Flutter tetap lulus seperti dicatat di atas.
