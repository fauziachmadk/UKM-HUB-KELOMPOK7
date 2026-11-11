# Pekerjaan anggota dari fondasi sampai final

Fondasi menyediakan integrasi dasar agar modul tidak dimulai dari proyek kosong.
Pekerjaan di bawah belum dinyatakan selesai. Mark dengan bukti commit/test/capture
setelah benar-benar dikerjakan. Kepemilikan bukan klaim penulis baseline.

## Fauzi Achmad Koesnaedi - 102022300352

1. Baca core/app.dart, core/theme.dart, models, widgets/hub_widgets.dart,
   screens/main_page.dart dan screens/profile_page.dart di app/lib.
2. Fondasi sudah menyediakan tiga tab IndexedStack, tema, identitas sesi, state
   pendaftaran, serta handler edit/hapus/undo. Jaga satu sumber state ini.
3. Sepakati kontrak filter Djalil/Arief sebelum Azka menambahkan chips. Review
   handoff form Vanesa dan layout detail Azka pada region terpisah.
4. Integrasikan PR aktual, jaga mounted/duplikat, jalankan regresi semua modul.
5. Lengkapi README 28 poin dengan baris nyata, screenshot Android 4+, APK final,
   demo 3-5 menit, akses dosen, ZIP source. Deadline PDF 12 Nov 2026 23.59 WIB
   kecuali LMS mengubahnya. Jangan unggah cache atau klaim pekerjaan teman.

## Muhammad Azka Azkiya - 102022300166

1. Baca models/ukm.dart, services/api_service.dart, widgets/hub_widgets.dart.
2. Buka screens/jelajah_page.dart: dasar FutureBuilder/retry sudah ada; kerjakan
   state bidang, ChoiceChip lima bidang + semua, query service, pencarian nama
   lokal, dispose controller, empty state, responsif, dan kualitas UI acuan DEV.
3. Buka widgets/ukm_card.dart: kerjakan Row/Column/Expanded/Stack, badge Open
   Recruitment dengan Positioned, konteks terdaftar, layout teks/logo yang baik.
4. Pada screens/detail_page.dart hanya edit AZKA-DETAIL-GUIDE/VIEW. Tambahkan
   ketua, anggota, berdiri, deskripsi/kegiatan, status, nama yang tetap jelas.
   Jangan menulis alur form kedua atau mengubah region Vanesa.
5. Uji server mati/retry, bidang, search kosong, layar sempit, tema gelap,
   rekrutmen tutup dan terdaftar. Koordinasi tes dengan Arief. Hero/refresh bonus.

## Vanesa Rizka Alfatihah - 102022300121

1. Baca models/pendaftaran.dart dan flow MainPage, lalu registration_form.dart.
2. Fondasi sudah punya controller/dispose, menolak kolom kosong, mengembalikan
   record. Kerjakan Form/validator nyata (nama, NIM String, alasan), error field,
   alasan multi-baris, keyboard, logo/nama/bidang, dan desain sesuai acuan DEV.
3. Kerjakan registrations_page.dart: kartu nama/NIM/alasan/tanggal dan aksi
   edit/hapus menggunakan onEdit/onDelete. Callback induk sudah ada. Pertahankan
   tanggal saat edit. Jangan membuat daftar state permanen kedua.
4. Di detail_page.dart hanya VANESA-DETAIL-HANDOFF. Uji await hasil, mounted,
   batal, invalid dan hasil langsung tampil. Koordinasi file bersama dengan Azka.
5. Pertahankan satu minat per UKM walau NIM diganti; uji edit/hapus/undo dan UKM
   lain. Uji overflow/keyboard/tema bersama Arief. Ini minat sesi, bukan kiriman.

## Muhammad Aditya Djalil - 102022300225

1. Baca kontrak docs/ARCHITECTURE.md serta models/ukm.dart pada app/lib.
2. Lengkapi server/data/ukm.json dari 5 menjadi minimal 12 UKM (target DEV 15),
   semua field/tipe valid, id unik, lima kategori, dan logo aset yang tersedia.
3. Di server/lib/api.dart kerjakan filter bidang server-side. Baseline query
   bidang menghasilkan 501 secara jujur, bukan filter palsu. Sepakati case dan
   bidang tak dikenal: mengikuti DEV, case-insensitive dan array kosong.
4. Perkuat server/bin/server.dart: validasi startup/error, middleware relevan,
   URL browser tetap localhost/ukm. Jangan hardcode lokasi file laptop.
5. Kembangkan server/test/api_test.dart: 12+ item, tipe/kategori/logo, detail,
   filter dan 404. Jalankan dart analyze/test; serahkan contoh JSON ke Arief.

## Arief Setiawan - 102022300098

1. Baca kontrak model/API; buka services/api_service.dart. Fondasi baru GET
   katalog dasar. Kerjakan getUkmById, queryParameters bidang, normalisasi URL,
   Accept JSON, timeout, error HTTP/koneksi/JSON/model, dan ownership client.
2. Di app/test/api_service_test.dart, perluas MockClient: path/query, detail,
   status error, JSON rusak, jaringan/timeout, DateTime round-trip. Jangan
   mengganti error dengan list kosong yang terlihat seperti request sukses.
3. Di app/test/flows_test.dart tambahkan loading/error/retry terkontrol, filter,
   search, validasi/batal, edit/hapus/undo dan tema. Ada 4 widget test dasar
   untuk retry, navigasi, detail constructor, dan hasil form/duplikat sebagai fondasi.
4. Review backend test Djalil melalui koordinasi, bukan mengedit bersamaan.
5. QA Android dengan server nyata, catat commit/perangkat/API_URL/hasil. Picu
   request baru setelah server mati untuk menunjukkan error; nyalakan dan retry.

Semua file app yang disingkat berada di app/lib kecuali test. Cari nama/ID pada
docs/OWNERSHIP.md untuk path dan baris terkini. Setiap PR mencantumkan perilaku,
file/region, tes yang dijalankan, screenshot jika UI, dan masalah yang tersisa.
