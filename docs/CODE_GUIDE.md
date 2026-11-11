# Cara membaca dan mengubah kode

1. Mulai app/lib/main.dart -> core/app.dart -> screens/main_page.dart.
2. Baca model Ukm/Pendaftaran sebelum mengubah UI. API ada di services, bukan
   di widget. Backend berada di server/bin dan server/lib.
3. Cari `TODO(NAMA)` atau `BEGIN UKM07-NAMA-...` di pencarian VS Code.
4. Baca header, input/output, kriteria, dan komentar akhir `NAMA SAMPAI SINI`.
5. Ubah hanya bagian sendiri. Pada detail, constructor/field Fauzi, getter/view
   Azka, method _register Vanesa. Koordinasikan giliran file bersama.
6. Setelah edit, format, analyze, test; perbarui peta nomor baris lewat
   `python tools/update_maps.py` dari root. Nomor baris bukan batas permanen.

## Format komentar

```dart
// BEGIN UKM07-AZKA-CARD
// MULAI BAGIAN AZKA.
// TODO(AZKA): tugas substantif dan kriteria selesai di sini.
// ... implementasi yang dikerjakan dan dipahami pemilik tugas ...
// END UKM07-AZKA-CARD - AZKA SAMPAI SINI.
```

Setiap region unik, BEGIN/END berpasangan, tidak bersarang. Teks tugas dapat
diringkas setelah selesai; alasan penting tetap. Header ownership bukan bukti
bahwa anggota menulis baseline. Kontribusi nyata dilihat melalui riwayat Git.
JSON tidak mendukung komentar; instruksi dataset berada di server/data/README.md.

## Pemeriksaan

Dari app: `dart format lib test`, `flutter analyze`, `flutter test`.
Dari server: `dart format bin lib test`, `dart analyze`, `dart test`.
Tes dasar tidak berarti semua poin final lulus. Periksa tabel status README dan
TASKS, ambil bukti Android baru setelah integrasi. Jangan menyalin nomor baris,
screenshot, atau hasil tes DEV untuk mengklaim hasil kerangka kelompok.
