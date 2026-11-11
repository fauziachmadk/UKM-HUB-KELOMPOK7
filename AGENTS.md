# UKM Hub - kerangka kolaborasi Kelompok 07

Fondasi ini dapat dijalankan, tetapi belum aplikasi UTS final. DEV tetap acuan
perilaku lengkap. Jangan menyelesaikan region anggota lain tanpa instruksi.
Nama ownership adalah tanggung jawab, bukan klaim penulis implementasi awal.

| Penanggung jawab | NIM | Batas |
| --- | --- | --- |
| Fauzi Achmad Koesnaedi | 102022300352 | Core/theme/model kontrak/main state/Profil/integrasi |
| Muhammad Azka Azkiya | 102022300166 | Jelajah/kartu/detail tampilan |
| Vanesa Rizka Alfatihah | 102022300121 | Form/daftar/handoff detail |
| Muhammad Aditya Djalil | 102022300225 | Shelf/dataset/test backend |
| Arief Setiawan | 102022300098 | HTTP/MockClient/widget test/QA |

- Baca README, docs/START_HERE.md, docs/OWNERSHIP.md dan docs/TASKS.md.
- Cari `BEGIN UKM07-...`; akhir region berbunyi `... SAMPAI SINI`.
- File detail bersama: Fauzi kontrak, Azka tampilan, Vanesa handoff form.
- Jangan mengubah signature bersama tanpa mengoordinasikan pemanggilnya.
- Gunakan Material 3, Manrope, ColorScheme dan aset lokal. Scope P01-P07;
  tanpa auth, database, admin, atau fitur cloud.
- Satu pemilik state pendaftaran di MainPage; satu minat per UKM per sesi.
- Controller/client ditutup pemiliknya. Periksa mounted setelah await.
- Komentar Indonesia menjelaskan alasan/alur; jangan menulis nomor baris statis
  dalam komentar batas. docs/OWNERSHIP.md mencatat nomor baris aktual.
- JSON tidak boleh memuat komentar. Instruksi dataset di server/data/README.md.
- Sesudah edit Dart: format, analyze, dan test modul terkait. Uji Android bila
  perubahan memengaruhi integrasi/native; catat hasil yang benar-benar diamati.
- Jalankan python tools/update_maps.py setelah format/perubahan baris.
- README memiliki satu baris tiap 28 poin; status belum jangan diubah tanpa bukti.
- Jangan mengarang kontribusi, screenshot, jumlah tes, atau status selesai.
- Simpan checkpoint lokal. Tidak push/merge/ubah author tanpa instruksi pengguna.
- Jangan menyalin build/cache/AVD/SDK/junction mesin Fauzi ke repo atau ZIP.
